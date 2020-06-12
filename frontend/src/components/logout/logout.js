import React from 'react';
import MyContext from '../../context.js';

function Logout(props) {
  return (
    <MyContext.Consumer>
      {({clearAll, addError}) => (
        <button onClick={() => {
          window.localStorage.removeItem('user');
          clearAll();
        }}>Logout</button>
      )}
    </MyContext.Consumer>
  );
}

export default Logout;
