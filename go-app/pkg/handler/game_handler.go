package handler

import "net/http"

type GameHandler struct {
}

func NewGameHandler() *GameHandler {
	return &GameHandler{}
}

func (g *GameHandler) StartGame(w http.ResponseWriter, r *http.Request) {
}
func (g *GameHandler) PossibleMoves(w http.ResponseWriter, r *http.Request) {
}
func (g *GameHandler) Move(w http.ResponseWriter, r *http.Request) {
}
func (g *GameHandler) Delete(w http.ResponseWriter, r *http.Request) {
}
func (g *GameHandler) CreateGame(w http.ResponseWriter, r *http.Request) {
}
func (g *GameHandler) Index(w http.ResponseWriter, r *http.Request) {
}
