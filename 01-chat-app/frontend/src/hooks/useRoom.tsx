import moment from "moment-timezone";
import { useCallback, useState } from "react";
import { Socket } from "socket.io-client";

import { useSocketIO, useSocketListen } from "@/contexts/io";
import {
  JoinSuccess,
  RoomData,
  SocketMessage,
  SocketRoomDataResponse,
} from "@/types/socket";
import { $string } from "@/common/utils/validation";

export interface UseRoomProps {}

export default function useRoom() {
  const { socket, state, setState } = useSocketIO();
  const [roomData, setRoomData] = useState<RoomData | undefined>();
  const [lastestMessages, setLastestMessages] = useState<SocketMessage[]>([
    {
      username: "example",
      message: "Example Message",
      createdAt: "any date",
    },
  ]);

  ////////////////////
  /// Methods
  ////////////////////

  const join = async (room: string, username: string) => {
    const result = await emit<JoinSuccess>(socket, "join", {
      username,
      room,
    });

    if (result.data.joined) {
      setState({
        joined: true,
        room: result.data.room,
        username: result.data.username,
      });
    }

    return result;
  };

  const sendMessage = (message: string) => emit(socket, "message", message);

  ///////////////////////
  /// handlers
  ///////////////////////

  const handleNewMessages = useCallback(
    (data: SocketMessage) => {
      const msg = transformMessage(data);

      if (!msg) return;

      setLastestMessages((prev) => {
        prev.push(msg);

        return prev;
      });
    },
    [lastestMessages]
  );

  const handleRoomData = (data: SocketRoomDataResponse) => {
    if (data && data.data) setRoomData(data.data);
  };

  // Listen to socket events
  useSocketListen("message", handleNewMessages);
  useSocketListen("room-data", handleRoomData);

  return {
    state,
    socket,
    join,
    sendMessage,
    lastestMessages,
    roomData,
  };
}

////////////////////
/// Helpers
////////////////////

function emit<T = any>(socket: Socket, event: string, data: any) {
  return new Promise<T>((res, rej) => {
    socket.emit(event, data, (result: any) => {
      if (result && "error" in result) return rej(result.error);
      res(result);
    });
  });
}

function transformMessage(msg: any): SocketMessage | null {
  const { username, message, createdAt, options = {} } = msg || {};

  if (!$string(username) || !$string(message)) return null;

  return {
    username,
    message,
    createdAt: moment(createdAt).format("LLL"),
    options,
  };
}
