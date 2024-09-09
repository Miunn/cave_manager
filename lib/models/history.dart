class History {
  int? id;
  int? bottleId;
  bool? isIncoming;
  DateTime? createdAt;

  History(this.bottleId, this.isIncoming, this.createdAt, {this.id});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'bottleId': bottleId,
      'isIncoming': isIncoming == true ? 1 : 0,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  static History fromMap(Map<String, Object?> map) {
    return History(
      map['bottleId'] as int?,
      map['isIncoming'] == 1 as bool?,
      map['createdAt'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      id: map['id'] as int?,
    );
  }
}