export type SocketResponse<T> = {
  data: T;
  message: string;
};

export type JoinSuccess = SocketResponse<{
  joined: boolean;
  room: string;
  username: string;
}>;

interface SocketStateJoined {
  joined: true;
  room: string;
  username: string;
}

interface SocketStateInitial {
  joined: false;
}

export type SocketState = SocketStateJoined | SocketStateInitial;

export interface SocketMessage {
  username: string;
  message: string;
  createdAt: string;
  options?: {
    isAdmin?: boolean;
  };
}

export type SocketUser = {
  icon?: string;
  username: string;
  room: string;
};

export type RoomData = {
  room: string;
  users: SocketUser[];
};

export type SocketRoomDataResponse = SocketResponse<RoomData>;
