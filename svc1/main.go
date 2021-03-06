package main

import (
	"fmt"
	"log"
	"net/http"
	"runtime"

	"google.golang.org/appengine"

	"github.com/gin-gonic/gin"
	"github.com/tweeeety/go-gae-sample/svc1/controller"
	"github.com/tweeeety/go-gae-sample/svc1/middleware"
)

func init() {
	log.Println("Hello, init!")
}

func main() {
	router := gin.Default()
	router.LoadHTMLGlob("./template/*.html")
	router.Use(middleware.RecordUaAndTime)

	router.GET("/", controller.TodoIndex)

	// appengine用
	// router.Run()の代わり
	//router.Run()
	http.Handle("/", router)
	appengine.Main()
}

func myError(err error) error {
	_, file, line, _ := runtime.Caller(1)
	newErr := fmt.Errorf("[ERROR] %+v:%+v %w", file, line, err)
	return newErr
}
