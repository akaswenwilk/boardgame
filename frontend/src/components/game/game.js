import React, { Component } from 'react';
import axios from '../../axios.js';
import {
  Link,
  withRouter
} from "react-router-dom";



class Game extends Component {
  constructor(props) {
    super(props);

    this.state = {
      game: this.props.user
    };
  }

  componentDidMount() {
    if (!this.state.game) {
      let { id } = this.props.match.params;

      axios.get(`/games/${id}`).then(res => {
        this.setState({ game: res.data });
      }).catch(err => {
        this.props.onErrorHandler(err.data.error_message);
      });
    }
  }

  render() {
    console.log(this.state.game);

    return (
      <div>
        <Link to="/games">return to games</Link>
        here's the game!
      </div>
    );
  }
}

export default withRouter(Game);
