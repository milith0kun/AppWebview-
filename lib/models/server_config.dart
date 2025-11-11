/// Modelo para la configuración de servidor
class ServerConfig {
  final String name;
  final String url;

  const ServerConfig({
    required this.name,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory ServerConfig.fromJson(Map<String, dynamic> json) {
    return ServerConfig(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  @override
  String toString() => 'ServerConfig(name: $name, url: $url)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServerConfig && other.name == name && other.url == url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
