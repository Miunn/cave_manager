import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class Bottle {
  int? id;
  String? name;
  String? signature;
  int? vintageYear;
  String? color;
  double? alcoholLevel;
  String? grapeVariety;
  String? country;
  String? area;
  String? subArea;
  String? imageUri;
  int? clusterId;
  int? clusterY;
  int? clusterX;
  bool? isOpen;
  DateTime? createdAt;
  DateTime? openedAt;
  String? tastingNote;

  Bottle(this.name, this.createdAt, this.isOpen,
      {this.id,
      this.signature,
      this.vintageYear,
      this.color,
      this.alcoholLevel,
      this.grapeVariety,
      this.country,
      this.area,
      this.subArea,
      this.imageUri,
      this.clusterId,
      this.clusterY,
      this.clusterX,
      this.openedAt,
      this.tastingNote});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'signature': signature,
      'vintageYear': vintageYear,
      'color': color,
      'alcoholLevel': alcoholLevel,
      'grapeVariety': grapeVariety,
      'country': country,
      'area': area,
      'subArea': subArea,
      'imageUri': imageUri,
      'isOpen': (isOpen != null && isOpen!) ? 1 : 0,
      'clusterId': clusterId,
      'clusterY': clusterY,
      'clusterX': clusterX,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'openedAt': openedAt?.millisecondsSinceEpoch,
      'tastingNote': tastingNote
    };
  }

  Bottle.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    signature = map['signature'];
    vintageYear = map['vintageYear'];
    color = map['color'];
    alcoholLevel = map['alcoholLevel'];
    grapeVariety = map['grapeVariety'];
    country = map['country'];
    area = map['area'];
    subArea = map['subArea'];
    imageUri = map['imageUri'];
    isOpen = map['isOpen'] == 1 ? true : false;
    clusterId = map['clusterId'];
    clusterY = map['clusterY'];
    clusterX = map['clusterX'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']);
    openedAt = (map['openedAt'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(map['openedAt'])
        : null;
    tastingNote = map['tastingNote'];
  }

  @override
  String toString() {
    return 'Bottle{'
        'id: $id, '
        'name: $name, '
        'signature: $signature, '
        'vintageYear: $vintageYear, '
        'color: $color, '
        'alcoholLevel: $alcoholLevel, '
        'grapeVariety: $grapeVariety, '
        'country: $country, '
        'area: $area, '
        'subArea: $subArea, '
        'imageUri: $imageUri, '
        'isOpen: $isOpen, '
        'clusterId: $clusterId, '
        'clusterY: $clusterY, '
        'clusterX: $clusterX, '
        'createdAt: $createdAt, '
        'openedAt: $openedAt, '
        'tastingNote: $tastingNote}';
  }

  setImage(XFile image) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    await image.saveTo('$path/${image.name}');

    // Delete previous saved picture
    if (imageUri != null) {
      await File(imageUri!).delete();
    }

    imageUri = '$path/${image.name}';
  }
}
