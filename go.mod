module github.com/bbdshow/qelog

go 1.14

replace (
	github.com/bbdshow/qelog/api => ./api
	github.com/bbdshow/qelog/qezap => ./qezap
)

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/bbdshow/qelog/api v1.0.1
	github.com/bbdshow/qelog/qezap v0.0.0-00010101000000-000000000000
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/gin-gonic/gin v1.6.3
	github.com/json-iterator/go v1.1.10
	go.mongodb.org/mongo-driver v1.4.4
	go.uber.org/multierr v1.5.0
	go.uber.org/zap v1.16.0
	google.golang.org/grpc v1.34.1
)
