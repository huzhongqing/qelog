FROM golang:1.14.13-alpine3.12 as builder
WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN set -eux; \
      export GOPROXY="https://goproxy.io,direct"; \
      go version && go mod download \
      ;

COPY . .

RUN set -eux; \
        mkdir -p ./bin && rm -r ./bin; \
        # shellcheck disable=SC2006
        go build -ldflags "-s -w -X 'main.buildTime=`date`' -X 'main.goVersion=`go version`' -X main.gitHash=`git rev-parse HEAD`"  \
                -o bin/receiver cmd/receiver/main.go; \
        # shellcheck disable=SC2006
        go build -ldflags "-s -w -X 'main.buildTime=`date`' -X 'main.goVersion=`go version`'-X main.gitHash=`git rev-parse HEAD`" \
            -o bin/admin cmd/admin/main.go;

FROM alpine:3.12
WORKDIR /app

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 时区
RUN set -eux; \
        apk update && apk add --no-cache\
            tzdata \
        ;\
        cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
        echo 'Asia/Shanghai' > /etc/timezone; \
        rm -rf /var/cache/apk/*;

COPY --from=builder ./app/bin .
COPY --from=builder ./app/configs ./configs
COPY --from=builder ./app/web ./web

CMD ["/bin/sh"]