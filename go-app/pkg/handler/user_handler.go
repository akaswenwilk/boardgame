package handler

import "net/http"

type UserHandler struct{}

func NewUserHandler() *UserHandler {
	return &UserHandler{}
}

func (u *UserHandler) Login(w http.ResponseWriter, r *http.Request) {
}

func (u *UserHandler) CreateUser(w http.ResponseWriter, r *http.Request) {
}

func (u *UserHandler) ConnectUser(w http.ResponseWriter, r *http.Request) {
}
