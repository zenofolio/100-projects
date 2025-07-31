import { $string } from "../../common/utils/validation";
import { $error } from "./helpers/socket-response";
import { SocketItem } from "./types/socket-item";

/**
 * Socket manager to handle sockets and rooms easily
 * using linked rooms and sockets increases performance
 *
 */

class SocketManager {
  private sockets = new Map<string, SocketItem>();
  private rooms = new Map<string, Set<string>>();
  private usernames = new Set<string>();

  /**
   *
   * Join socket to room
   * - If room is not exists, create it
   * - will add socket to room
   * - will add socket to usernames set
   * - will return user object
   *
   *
   * @param room
   * @param data
   * @returns
   */
  join(room: string, data: { id: string; username: string; icon?: string }) {
    const { username, id } = data;

    if (!$string(room)) return $error("Room is missing or invalid.");
    if (!$string(username)) return $error("Username is missing or invalid.");
    if (this.usernames.has(username))
      return $error("Username is already taken.");

    const user = {
      ...data,
      room,
    };

    this.sockets.set(id, user);
    this.joinToRoom(user.room, user.id);
    this.usernames.add(user.username);

    return user;
  }

  /**
   * Get socket by id
   *
   * @param id
   * @returns
   */
  get(id: string) {
    return this.sockets.get(id);
  }

  /**
   * Get all sockets by room
   *
   * @param room
   * @returns
   */
  getByRoom(room: string) {
    const sockets: SocketItem[] = [];

    for (const id of this.rooms.get(room) || []) {
      const item = this.sockets.get(id);
      if (!item) continue;
      sockets.push(item);
    }

    return sockets;
  }

  /**
   * Remove socket by id
   *
   * @param id
   * @returns
   */
  remove(id: string) {
    const item = this.sockets.get(id);
    if (!item) return $error("User is not found");

    this.sockets.delete(id);
    this.usernames.delete(item.username);
    this.leaveRoom(item.room, item.id);

    return item;
  }

  ////////////////////
  /// Private methods
  ///////////////////

  /**
   * Join socket to room
   *
   * @param room
   * @param id
   * @returns
   */
  private joinToRoom(room: string, id: string) {
    let ids = this.rooms.get(room);
    if (!ids) {
      ids = new Set([id]);
      this.rooms.set(room, ids);
      return;
    }

    ids.add(id);
  }

  /**
   * Leave socket from room
   *
   * @param room
   * @param id
   * @returns
   */
  private leaveRoom(room: string, id: string) {
    let ids = this.rooms.get(room);
    if (!ids) return;

    ids.delete(id);
    if (ids.size === 0) this.rooms.delete(room);
  }
}

export const socketManager = new SocketManager();
