package router

import (
	"github.com/akaswenwilk/boardgame/pkg/handler"
	"github.com/gorilla/mux"
)

type Router struct {
	*mux.Router
}

func NewRouter() Router {
	r := mux.NewRouter()

	playersHandler := handler.NewPlayerHandler()
	usersHandler := handler.NewUserHandler()
	gamesHandler := handler.NewGameHandler()

	r.HandleFunc("/games/{game_id}/players", playersHandler.CreatePlayer).Methods("POST")

	r.HandleFunc("/users/login", usersHandler.Login).Methods("POST")
	r.HandleFunc("/users", usersHandler.CreateUser).Methods("POST")
	r.HandleFunc("/games/{game_id}/users/{user_id}", usersHandler.ConnectUser)

	r.HandleFunc("/games/{game_id}/start", gamesHandler.StartGame).Methods("POST")
	r.HandleFunc("/games/{game_id}/players/{player_id}/possible_moves", gamesHandler.PossibleMoves).Methods("POST")
	r.HandleFunc("/games/{game_id}/players/{player_id}/move", gamesHandler.Move).Methods("POST")
	r.HandleFunc("/games/{game_id}", gamesHandler.Delete).Methods("DELETE")
	r.HandleFunc("/games", gamesHandler.CreateGame).Methods("POST")
	r.HandleFunc("/games", gamesHandler.Index).Methods("GET")

	return Router{r}
}
