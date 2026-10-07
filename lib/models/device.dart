class Device {
  final String id;
  final String name;
  final String description;
  final String category;
  final String imageUrl;
  final String status; // 'available', 'unavailable', 'borrowed'
  final bool isNew; // For hot/new devices

  Device({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.status = 'available',
    this.isNew = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'status': status,
      'isNew': isNew ? 1 : 0,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      imageUrl: map['imageUrl'],
      status: map['status'],
      isNew: map['isNew'] == 1,
    );
  }
}
