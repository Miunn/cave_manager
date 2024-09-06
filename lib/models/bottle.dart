import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class Bottle {
  int? id;
  String? name;
  int? capacity;
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
  int? clusterSubY;
  int? clusterX;
  bool? isInCellar;
  bool? isOpen;
  DateTime? createdAt;
  DateTime? registeredInCellarAt;
  DateTime? openedAt;
  String? tastingNote;

  Bottle(this.name, this.createdAt, this.isOpen,
      {this.id,
      this.capacity,
      this.isInCellar,
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
      this.clusterSubY,
      this.clusterX,
      this.registeredInCellarAt,
      this.openedAt,
      this.tastingNote});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'capacity': capacity,
      'signature': signature,
      'vintageYear': vintageYear,
      'color': color,
      'alcoholLevel': alcoholLevel,
      'grapeVariety': grapeVariety,
      'country': country,
      'area': area,
      'subArea': subArea,
      'imageUri': imageUri,
      'isInCellar': (isInCellar != null && isInCellar!) || (clusterX != null && clusterY != null && clusterSubY != null) ? 1 : 0,
      'isOpen': (isOpen != null && isOpen!) ? 1 : 0,
      'clusterId': clusterId,
      'clusterY': clusterY,
      'clusterSubY': clusterSubY ?? 0,
      'clusterX': clusterX,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'registeredInCellarAt': registeredInCellarAt?.millisecondsSinceEpoch,
      'openedAt': openedAt?.millisecondsSinceEpoch,
      'tastingNote': tastingNote
    };
  }

  Bottle.fromMap(Map<String, dynamic> map) {
    debugPrint("Map: $map");
    id = map['id'];
    name = map['name'];
    capacity = map['capacity'];
    signature = map['signature'];
    vintageYear = map['vintageYear'];
    color = map['color'];
    alcoholLevel = map['alcoholLevel'];
    grapeVariety = map['grapeVariety'];
    country = map['country'];
    area = map['area'];
    subArea = map['subArea'];
    imageUri = map['imageUri'];
    isInCellar = map['isInCellar'] == 1 ? true : false;
    isOpen = map['isOpen'] == 1 ? true : false;
    clusterId = map['clusterId'];
    clusterY = map['clusterY'];
    clusterSubY = map['clusterSubY'];
    debugPrint(map['clusterX'].toString());
    clusterX = map['clusterX'];
    createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']);
    registeredInCellarAt = (map['registeredInCellarAt'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['registeredInCellarAt']) : null;
    openedAt = (map['openedAt'] != null) ? DateTime.fromMillisecondsSinceEpoch(map['openedAt']) : null;
    tastingNote = map['tastingNote'];
  }

  static empty() {
    return Bottle(null, null, null);
  }

  @override
  String toString() {
    return 'Bottle{'
        'id: $id, '
        'name: $name, '
        'capacity: $capacity, '
        'signature: $signature, '
        'vintageYear: $vintageYear, '
        'color: $color, '
        'alcoholLevel: $alcoholLevel, '
        'grapeVariety: $grapeVariety, '
        'country: $country, '
        'area: $area, '
        'subArea: $subArea, '
        'imageUri: $imageUri, '
        'isInCellar: $isInCellar, '
        'isOpen: $isOpen, '
        'clusterId: $clusterId, '
        'clusterY: $clusterY, '
        'clusterSubY: $clusterSubY, '
        'clusterX: $clusterX, '
        'createdAt: $createdAt, '
        'registeredInCellarAt: $registeredInCellarAt, '
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

  deleteImage() async {
    if (imageUri != null) {
      await File(imageUri!).delete();
      imageUri = null;
    }
  }
}
