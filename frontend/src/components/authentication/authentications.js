import React, { Component } from 'react';
import MyContext from '../../context.js';
import axios from '../../axios.js';

class Authentication extends Component {
  static contextType = MyContext;

  state = {
    email: '',
    password: '',
    passwordConfirmation: '',
    mode: 'login',
    errors: null,
    rememberMe: false
  }

  emailChangeHandler = (e) => {
    let newValue = e.target.value;
    this.setState(state => {
      return {email: newValue}
    });
  }

  passwordChangeHandler = (e) => {
    let newValue = e.target.value;
    this.setState(state => {
      return {password: newValue}
    });
  }

  passwordConfirmationChangeHandler = (e) => {
    let newValue = e.target.value;
    this.setState(state => {
      return {passwordConfirmation: newValue}
    });
  }

  changeModeHandler = () => {
    this.setState((state) => {
      if (state.mode === 'login') {
        return {mode: 'signup'}
      } else {
        return {mode: 'login'}
      }
    });
  }

  handleRememberMe = () => {
    this.setState((state) => {
      let newValue = !state.rememberMe;
      return {rememberMe: newValue};
    });
  }

  signup = (email, password, passwordConfirmation) => {
    this.context.setLoading();
    let params = {
      email: email,
      password: password,
      password_confirmation: passwordConfirmation
    }

    axios.post('/users', params)
      .then(response => {
        let user = response.data
        this.context.addUser(user)
      }).catch(err => {
        let errors = err.response.data.error_message;
        this.context.addError(errors);
      });
  }

  login = (email, password) => {
    this.context.setLoading();
    let params = {
      email: email,
      password: password
    }

    axios.post('/users/login', params)
      .then(response => {
        let user = response.data;
        if (this.state.rememberMe) {
          window.localStorage.setItem('user', JSON.stringify(user));
        }
        this.context.addUser(user);
      }).catch(err => {
        let errors = err.response.data.error_message;
        this.context.addError(errors);
      });
  }

  submitHandler = () => {
    if (this.state.mode === 'signup') {
      this.signup(this.state.email, this.state.password, this.state.passwordConfirmation);
    } else {
      this.login(this.state.email, this.state.password);
    }
  }


  render() {
    let title = <p>Log in</p>
    let passwordConfirmation = null;
    let buttonText = "Don't have an account? Sign up instead!"

    if (this.state.mode === 'signup') {
      title = <p>Sign up</p>
      passwordConfirmation = (
        <>
          <label>Password Confirmation:</label>
          <input
            onChange={this.passwordConfirmationChangeHandler}
            value={this.state.passwordConfirmation}
            type="password"/>
        </>
      );
      buttonText = "Already have an account? Log in instead!"
    }

    return(
      <div>
        {title}
        <button
          onClick={this.changeModeHandler}
          >
          {buttonText}
        </button>
        <label>email:</label>
        <input
          type="text"
          onChange={this.emailChangeHandler}
          onKeyPress={(e) => {
            if (e.key === 'Enter') {
              this.submitHandler();
            }
          }}
          value={this.state.email}/>
        <label>password:</label>
        <input
          type="password"
          onChange={this.passwordChangeHandler}
          onKeyPress={(e) => {
            if (e.key === 'Enter') {
              this.submitHandler();
            }
          }}
          value={this.state.password}/>
        {passwordConfirmation}
        <label>Remember Me</label>
        <input
          checked={this.state.rememberMe}
          onChange={this.handleRememberMe}
          type="checkbox" />
        <button
          onClick={this.submitHandler}
          >submit</button>
      </div>
    );
  }
}

export default Authentication;
