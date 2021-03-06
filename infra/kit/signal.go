package kit

import (
	"log"
	"os"
	"os/signal"
	"syscall"
)

func SignalAccept(close func() error, reload func() error) {
	// 不同的信号量不同的处理方式
	ch := make(chan os.Signal, 1)
	signal.Notify(ch, syscall.SIGHUP, syscall.SIGQUIT, syscall.SIGTERM, syscall.SIGINT)
	for {
		si := <-ch
		switch si {
		case syscall.SIGQUIT, syscall.SIGTERM, syscall.SIGINT:
			if err := close(); err != nil {
				log.Fatal("exit", err)
			}
			return
		case syscall.SIGHUP:
			if err := reload(); err != nil {
				log.Println(err)
			}
		default:
			return
		}
	}
}
