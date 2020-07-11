import React from 'react';
import styles from './loading_screen.module.css';

function LoadingScreen(props) {
  return (
    <div className={styles.Loading}>
      <div className={styles.Box}>
        <p>Loading...</p>
      </div>
    </div>
  );
}

export default LoadingScreen;
