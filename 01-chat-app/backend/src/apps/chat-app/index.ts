import { Filter } from "bad-words";
import { Server } from "socket.io";
import { socketManager } from "./socket-manager";
import { toMessage } from "./helpers/to-message";
import { $error, $success } from "./helpers/socket-response";
import { JoinRoomEvent } from "./types/socket-events";
import { $string } from "../../common/utils/validation";

const filter = new Filter();

export default async function chatApp(io: Server) {
  ////////////////////
  /// Helpers
  ///////////////////

  /**
   * Send room data to all conenctions when socket connect or disconnect
   *
   * @param room
   * @returns
   */
  const sendRoomData = (room: string) =>
    io.to(room).emit(
      "room-data",
      $success({
        room,
        users: socketManager
          .getByRoom(room)
          .map((i) => ({ ...i, id: undefined, room: undefined })),
      })
    );

  /**
   * Send message to room
   *
   * @param room
   * @param username
   * @param msg
   * @param options
   */
  const sendRoom = (
    room: string,
    username: string,
    msg: string,
    options: any = {}
  ) => {
    io.to(room).emit("message", toMessage(username, msg, options));
  };

  /**
   * Send a message with admin username
   *
   * @param room
   * @param message
   * @param options
   * @returns
   */
  const sendAsAdmin = (room: string, message: string, options: any = {}) =>
    sendRoom(room, "Admin", message, {
      isAdmin: true,
      ...options,
    });

  /////////////////////
  // Listeners
  /////////////////////

  io.on("connection", (socket) => {
    /**
     * handle socket when disconnect
     *
     */
    socket.on("disconnect", () => {
      const result = socketManager.remove(socket.id);
      if ("error" in result) return;

      sendAsAdmin(result.room, `User ${result.username} leave the room!`);
    });

    /**
     *
     * Join socket to room
     *
     */
    socket.on("join", (data: JoinRoomEvent, callback) => {
      if (!data) return callback($error("Join data is missing"));

      const id = socket.id;
      const { username, room, icon } = data;

      const result = socketManager.join(room, {
        username,
        id,
        icon,
      });

      if ("error" in result) return callback(result);

      socket.join(room);

      callback(
        $success(
          {
            joined: true,
            room,
            username,
            icon,
          },
          "Joined!"
        )
      );

      sendAsAdmin(room, `User ${username} has joined!`);

      /// send room data
      sendRoomData(room);
    });

    /**
     * Leave room from socket
     */
    socket.on("leave", (data, callback) => {
      const result = socketManager.remove(socket.id);
      if ("error" in result) return callback($error(result.error));

      callback("");

      socket.leave(result.room);
      sendRoomData(result.room);
    });

    /**
     * Handle messages from client side
     */
    socket.on("message", (data, callback) => {
      console.log(data, callback);

      if (!$string(data)) return callback($error("Message is missing!"));

      const user = socketManager.get(socket.id);
      if (!user) return callback($error("User no found"));

      const message = filter.clean(data);

      callback("");

      sendRoom(user.room, user.username, message);
      sendRoomData(user.room);
    });
  });
}
