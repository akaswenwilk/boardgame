import React, { Component } from 'react';

class Authentication extends Component {
  state = {
    email: '',
    password: '',
    passwordConfirmation: '',
    mode: 'login',
    errors: null,
    rememberMe: false
  }

  emailChangeHandler = (e) => {
    this.setState({email: e.target.value});
  }

  passwordChangeHandler = (e) => {
    let password = e.target.value;
    this.setState((state) => {
      let errors = null;
      if (state.passwordConfirmation !== password && state.mode === 'signup') {
        errors = 'password must match password confirmation';
      }
      return {password: password, errors: errors};
    });
  }

  passwordConfirmationChangeHandler = (e) => {
    let passwordConfirmation = e.target.value;
    this.setState((state) => {
      let errors = null;
      if (state.password !== passwordConfirmation && state.mode === 'signup') {
        errors = 'password must match password confirmation';
      }
      return {passwordConfirmation: passwordConfirmation, errors: errors};
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

  submitHandler = () => {
    if (!this.state.errors) {
      if (this.state.mode === 'signup') {
        this.props.signupHandler(this.state.email, this.state.password, this.state.passwordConfirmation);
      } else {
        this.props.loginHandler(this.state.email, this.state.password, this.state.rememberMe);
      }
    }
  }

  handleRememberMe = () => {
    this.setState((state) => {
      let newValue = !state.rememberMe;
      return {rememberMe: newValue};
    });
  }

  render() {
    let title = <p>Log in</p>
    let passwordConfirmation = null;
    let buttonText = "Don't have an account? Sign up instead!"
    let errorText = null;

    if (this.state.errors) {
      errorText = <p>{this.state.errors}</p>;
    }

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
        {errorText}
      </div>
    );
  }
}

export default Authentication;
