package controller

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/tweeeety/go-gae-sample/svc1/service"
)

func TodoIndex(ctx *gin.Context) {
	todoService := service.NewTodoService()
	todos := todoService.GetAll()
	log.Printf("todos: %+v", todos)
	ctx.HTML(http.StatusOK, "index.html", gin.H{
		"h1":    "default(svc1)",
		"todos": todos,
	})
}
