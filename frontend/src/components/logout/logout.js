import React from 'react';

function Logout(props) {
  return (
    <div>
      <button onClick={props.onLogout}>Logout</button>
    </div>
  );
}

export default Logout;
