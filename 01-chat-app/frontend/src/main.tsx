import React from "react";
import ReactDOM from "react-dom/client";
import { Toaster } from "react-hot-toast";
import { BrowserRouter } from "react-router-dom";

import App from "./App.tsx";
import { Provider } from "./provider.tsx";

import "@/styles/globals.css";
import { io } from "socket.io-client";

import { API_URL } from "./config/urls.ts";
import SocketIoProvider from "./contexts/io.tsx";

const socket = io(API_URL);

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <BrowserRouter>
      <Provider>
        <SocketIoProvider socket={socket}>
          <App />
        </SocketIoProvider>
        <Toaster />
      </Provider>
    </BrowserRouter>
  </React.StrictMode>,
);
