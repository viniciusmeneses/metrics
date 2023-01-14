import axios from "axios";

export const api = axios.create({ baseURL: process.env.REACT_APP_API_URL });

api.interceptors.response.use(
  (response) => response.data,
  (error) => Promise.reject(error.response),
);
