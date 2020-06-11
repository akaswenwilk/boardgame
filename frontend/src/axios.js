import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:9292/',
  headers: {'Content-Type': 'application/json'}
});

export default instance;
