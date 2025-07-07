class Item {
  final String code;
  final String name;
  final String type;
  final String status;
  final int usageHours;
  final String damageNotes;
  final String location; // ✅ NEW FIELD

  Item({
    required this.code,
    required this.name,
    required this.type,
    required this.status,
    required this.usageHours,
    required this.damageNotes,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'type': type,
      'status': status,
      'usageHours': usageHours,
      'damageNotes': damageNotes,
      'location': location,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      code: map['code'],
      name: map['name'],
      type: map['type'],
      status: map['status'],
      usageHours: map['usageHours'],
      damageNotes: map['damageNotes'],
      location: map['location'] ?? '',
    );
  }
}