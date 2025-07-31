import { Socket } from "socket.io-client";
import {
  createContext,
  Dispatch,
  ReactNode,
  SetStateAction,
  useContext,
  useEffect,
  useState,
} from "react";

import { SocketState } from "@/types/socket";

type SocketCallback<T = any> = (data: T) => any;

// Context
const SocketIoContexts = createContext<{
  socket: Socket;
  state: SocketState;
  setState: Dispatch<SetStateAction<SocketState>>;
} | null>(null);

///////////////////////
/// Hooks
///////////////////////

export const useSocketIO = () => {
  const ctx = useContext(SocketIoContexts);

  if (!ctx) throw new Error("SocketIoContexts is not implemented");

  return ctx;
};

export function useSocketListen<T = any>(event: string, cb: SocketCallback<T>) {
  const { socket } = useSocketIO();

  useEffect(() => {
    socket.on(event, cb);

    return () => {
      socket.off(event, cb);
    };
  }, [event, cb]);

  return;
}

////////////////////////
/// Provider
///////////////////////

export interface SocketIoProviderProps {
  socket: Socket;
  children: ReactNode;
}
export default function SocketIoProvider({
  socket,
  children,
}: SocketIoProviderProps) {
  const [state, setState] = useState<SocketState>({ joined: false });

  return (
    <SocketIoContexts.Provider
      value={{
        socket,
        state,
        setState,
      }}
    >
      {children}
    </SocketIoContexts.Provider>
  );
}
