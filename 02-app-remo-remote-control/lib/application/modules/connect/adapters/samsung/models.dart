import 'dart:convert';

/// Base class for all Samsung WebSocket messages
sealed class SamsungSocketMessage {
  final String event;

  const SamsungSocketMessage(this.event);

  factory SamsungSocketMessage.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as String?;

    if (event == null) {
      throw FormatException("Missing 'event' field in socket message.");
    }

    switch (event) {
      case 'ms.channel.connect':
        return SamsungSocketMessageAuth.fromJson(json);
      default:
        return SamsungSocketMessageUnknown(event, raw: json);
    }
  }

  factory SamsungSocketMessage.fromString(String data) =>
      SamsungSocketMessage.fromJson(jsonDecode(data));
}


final class SamsungSocketMessageUnknown extends SamsungSocketMessage {
  final Map<String, dynamic> raw;

  SamsungSocketMessageUnknown(super.event, {
    required this.raw,
  });

  factory SamsungSocketMessageUnknown.fromJson(Map<String, dynamic> json) {
    final event = json['event'] as String? ?? json['method'] as String? ?? 'unknown';
    return SamsungSocketMessageUnknown(
      event,
      raw: json,
    );
  }

  @override
  String toString() => 'SamsungSocketMessageUnknown(event: $event, raw: $raw)';
}


/// Message for `ms.channel.connect` event
final class SamsungSocketMessageAuth extends SamsungSocketMessage {
  final String id;
  final String token;
  final List<SamsungSocketClient> clients;
  final Map<String, dynamic> raw;

  const SamsungSocketMessageAuth({
    required this.id,
    required this.token,
    required this.clients,
    required this.raw
  }) : super('ms.channel.connect');



  String? getToken(){

    if(token.isNotEmpty) return token;

    for(var client in clients){
      if(client.attributes.token.isNotEmpty){
        return client.attributes.token;
      }
    }

    return null;
  }



  factory SamsungSocketMessageAuth.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw FormatException("Missing or invalid 'data' in message.");
    }

    return SamsungSocketMessageAuth(
      raw: data,
      id: data['id'] as String? ?? '',
      token: data['token'] as String? ?? '',
      clients:
          (data['clients'] as List<dynamic>? ?? [])
              .map(
                (e) => SamsungSocketClient.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

/// A connected client in the auth message
final class SamsungSocketClient {
  final String id;
  final bool isHost;
  final int connectTime;
  final String deviceName;
  final SamsungSocketClientAttributes attributes;

  const SamsungSocketClient({
    required this.id,
    required this.isHost,
    required this.connectTime,
    required this.deviceName,
    required this.attributes,
  });

  factory SamsungSocketClient.fromJson(Map<String, dynamic> json) {
    return SamsungSocketClient(
      id: json['id'] as String? ?? '',
      isHost: json['isHost'] as bool? ?? false,
      connectTime: json['connectTime'] as int? ?? 0,
      deviceName: json['deviceName'] as String? ?? '',
      attributes: SamsungSocketClientAttributes.fromJson(
        json['attributes'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// Attributes attached to each client (e.g. base64 name)
final class SamsungSocketClientAttributes {
  final String name;
  final String token;

  const SamsungSocketClientAttributes({required this.name, required this.token});

  factory SamsungSocketClientAttributes.fromJson(Map<String, dynamic> json) {
    return SamsungSocketClientAttributes(
      name: json['name'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }
}
