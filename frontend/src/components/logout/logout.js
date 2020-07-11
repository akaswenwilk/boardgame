import React from 'react';
import MyContext from '../../context.js';
import styles from './logout.module.css';

function Logout(props) {
  return (
    <MyContext.Consumer>
      {({clearAll, addError}) => (
        <div className={styles.Logout}>
          <button onClick={() => {
            window.localStorage.removeItem('user');
            clearAll();
          }}>Logout</button>
        </div>
      )}
    </MyContext.Consumer>
  );
}

export default Logout;
