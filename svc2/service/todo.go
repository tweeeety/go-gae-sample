package service

import (
	"github.com/tweeeety/go-gae-sample/svc1/model"
)

type Db struct {
	Connectoin string
}

type TodoService struct {
	Db Db
}

func NewTodoService() (ts TodoService) {
	todoService := TodoService{}
	todoService.Db = DbOpen()
	return todoService
}

func DbOpen() Db {
	var db Db
	db.Connectoin = ""
	return db
}

func (ts TodoService) GetAll() []model.Todo {

	var todos = []model.Todo{
		{Text: "hogehoge", Status: "todo"},
		{Text: "fugafuga", Status: "doing"},
		{Text: "piyopiyo", Status: "close"},
	}

	return todos
}
