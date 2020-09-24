import React, { Component } from 'react';
import MyContext from '../../context.js';
import axios from '../../axios.js';

import styles from './authentication.module.css';

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
    console.log('about to sign up')

    axios.post('/users', params)
      .then(response => {
        let user = response.data
        this.context.addUser(user)
      }).catch(err => {
        console.log(err);
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
        console.log(err);
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
    let title = <h1>Log in</h1>
    let passwordConfirmation = null;
    let buttonText = "Don't have an account? Sign up instead!"

    if (this.state.mode === 'signup') {
      title = <h1>Sign up</h1>
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
      <div className={styles.Form}>
        {title}
        <div>
          <button
            className={styles.ChangeForm}
            onClick={this.changeModeHandler}
            >
            {buttonText}
          </button>
        </div>
        <div>
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
        </div>
        <div>
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
        </div>
        <div>
          {passwordConfirmation}
        </div>
        <div>
          <label>Remember Me</label>
          <input
            checked={this.state.rememberMe}
            onChange={this.handleRememberMe}
            type="checkbox" />
        </div>
        <button
          className={styles.Submit}
          onClick={this.submitHandler}
          >submit</button>
      </div>
    );
  }
}

export default Authentication;
