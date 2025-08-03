
class DeviceApp {
  final String? id;
  final String name;
  final String? description;
  final String? imageUrl;

  const DeviceApp({
    this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  /// JSON factory
  factory DeviceApp.fromJson(Map<String, dynamic> json) {
    return DeviceApp(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// JSON converter
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// Copy with method
  DeviceApp copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
  }) {
    return DeviceApp(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  /// Readable string output
  @override
  String toString() {
    return 'DeviceApp(id: $id, name: $name, description: $description, imageUrl: $imageUrl)';
  }



}
