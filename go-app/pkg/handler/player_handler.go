package handler

import "net/http"

type PlayerHandler struct{}

func NewPlayerHandler() *PlayerHandler {
	return &PlayerHandler{}
}

func (p *PlayerHandler) CreatePlayer(w http.ResponseWriter, r *http.Request) {
}
