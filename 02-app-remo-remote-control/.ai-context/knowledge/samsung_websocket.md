# Samsung Smart TV WebSocket Remote Control Protocol

This document summarizes the protocol for controlling Samsung Smart TVs (2016+) via WebSocket, as used in the Samsung adapter.

## Overview
- Control is performed by sending key codes over a WebSocket connection to the TV.
- The protocol is not REST or HTTP-based, but message-based over a persistent socket.

## Connection
- Connect to the TV's IP address, usually port 8001 (WebSocket).
- Example config:
  - host: 192.168.0.10
  - port: 8001
  - method: websocket
  - name: myremote
  - description: PC Remote

## Message Format
- Messages are JSON objects containing the key code to send.
- Example:
```json
{
  "method": "ms.remote.control",
  "params": {
    "Cmd": "Click",
    "DataOfCmd": "KEY_MENU",
    "Option": "false",
    "TypeOfRemote": "SendRemoteKey"
  }
}
```

## Common Key Codes
- KEY_POWEROFF, KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT, KEY_ENTER, KEY_RETURN, KEY_MENU, KEY_SOURCE, KEY_GUIDE, KEY_TOOLS, KEY_INFO, KEY_RED, KEY_GREEN, KEY_YELLOW, KEY_BLUE, KEY_VOLUP, KEY_VOLDOWN, KEY_MUTE, KEY_0–KEY_9, etc.

## References
- https://github.com/Ape/samsungctl
- http://sc0ty.pl/2012/02/samsung-tv-network-remote-control-protocol/

## Notes
- Some key codes may differ by TV model/year.
- Authentication or pairing may be required on first connection.
