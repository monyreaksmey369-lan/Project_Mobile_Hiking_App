class Checkpoint {
  final String id;
  final String name;
  final String? description;

  bool isCompleted;
  
  final double? latitude;
  final double? longitude;
  final String? photoPath;
  final String? notes;

  Checkpoint({
    required this.id,
    required this.name,
    this.description = '',
    this.isCompleted = false,
    this.latitude,
    this.longitude,
    this.photoPath,
    this.notes,
  });
}
