import React, { Component } from 'react';
import MyContext from './context.js';
import axios from './axios.js';
import socket from './socket.js';

class GlobalStateProvider extends Component {
  state = {
    user: null,
    errors: null,
    currentGame: null,
    selectedHolder: null,
    selectedColor: null,
    possibleRows: [],
    loading: false
  }

  componentDidMount() {
    if (this.state.user === null) {
      let user = JSON.parse(window.localStorage.getItem('user'));
      if (user) {
        this.setState({ user: user });
      }
    }
  }

  makeMoveHandler = n => {
    this.setLoading();

    let params = {
      token: this.state.user.token,
      color: this.state.selectedColor,
      tile_holder: this.state.selectedHolder,
      row: n,
    }

    axios.post(`/games/${this.state.currentGame.id}/players/${this.state.currentGame.current_player_id}/move`, params)
      .then(res => res.data).then(data => {
        socket.gameSocket.send(JSON.stringify(data));
        this.setState({
          errors: null,
          currentGame: data,
          selectedHolder: null,
          selectedColor: null,
          possibleRows: [],
          loading: false
        });
      }).catch(err => console.log(err) && this.addErrorHandler(err.response.data.error_message));
  }

  selectHolderAndColorHandler = (holder, color) => {
    this.setLoading();

    let params = {
      token: this.state.user.token,
      color: color,
      tile_holder: holder,
    }

    axios.post(`/games/${this.state.currentGame.id}/players/${this.state.currentGame.current_player_id}/possible_moves`, params)
      .then(res => res.data).then(data => {
        this.setState({
          errors: null,
          selectedHolder: holder,
          selectedColor: color,
          loading: false,
          possibleRows: data.possible_rows
        });
      }).catch(err => console.log(err) && this.addErrorHandler(err.response.data.error_message));
  }

  canMakeMoveHandler = () => {
    if (this.state.currentGame && this.state.user) {
      let currentPlayer = this.state.currentGame.players.find(p => p.id === this.state.currentGame.current_player_id);
      return currentPlayer.user_id === this.state.user.id;
    } else {
      return false;
    }
  }

  addErrorHandler = errorMessage => {
    this.setState({
      errors: errorMessage,
      loading: false
    });
  }

  clearErrorsHandler = () => {
    this.setState({
      errors: null,
      loading: false
    });
  }

  addUserHandler = (user, errors = null) => {
    this.setState({
      user: user,
      loading: false,
      errors: errors
    });
  }

  addGameHandler = (game, errors = null) => {
    this.setState({
      currentGame: game,
      loading: false,
      errors: errors
    });
  }

  clearAllHandler = () => {
    this.setState({
      user: null,
      errors: null,
      loading: false,
      currentGame: null
    });
  }

  setLoading = () => {
    this.setState({ loading: true });
  }

  removeLoading = () => {
    this.setState({ loading: false });
  }

  render() {
    return (
      <MyContext.Provider
        value={{
          user: this.state.user,
          errors: this.state.errors,
          currentGame: this.state.currentGame,
          addError: this.addErrorHandler,
          clearErrors: this.clearErrorsHandler,
          addUser: this.addUserHandler,
          addGame: this.addGameHandler,
          clearAll: this.clearAllHandler,
          canMakeMove: this.canMakeMoveHandler,
          selectHolderAndColor: this.selectHolderAndColorHandler,
          selectedHolder: this.state.selectedHolder,
          selectedColor: this.state.selectedColor,
          possibleRows: this.state.possibleRows,
          makeMove: this.makeMoveHandler,
          loading: this.state.loading,
          setLoading: this.setLoading,
          removeLoading: this.removeLoading,
        }}>
        {this.props.children}
      </MyContext.Provider>
    );
  }
}

export default GlobalStateProvider;
