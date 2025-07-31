import Express from "express";
import { Server } from "socket.io";
import { createServer } from "node:http";

export const app = Express();
export const http = createServer(app);
export const io = new Server(http, {
    cors: {
        origin: "*"
    }
});
