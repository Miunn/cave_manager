class CellarCluster {
  int? id;
  String? name;
  int? width;
  int? height;

  CellarCluster({this.id, this.name, this.width, this.height});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'height': height,
    };
  }

  CellarCluster.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    width = map['width'];
    height = map['height'];
  }

  @override
  String toString() {
    return 'CellarCluster{id: $id, name: $name, width: $width, height: $height}';
  }
}