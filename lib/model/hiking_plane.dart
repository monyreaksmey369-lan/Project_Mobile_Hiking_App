import 'checkpoint.dart';
import 'destination.dart';

enum HikingStatus { upcoming, inProgress, completed }

enum HikingDifficulty { easy, medium, hard }

class HikingPlane {
  final String id;
  final String name;
  final DateTime hikingDate;
  final double distance;

  final HikingDifficulty difficulty;
  final Destination destination;

  final String? offLineMapPath;
  HikingStatus status;

  // One hiking plan can have many checkpoints
  List<Checkpoint> checkpoints;

  HikingPlane({
    required this.id,
    required this.name,
    required this.hikingDate,
    required this.distance,
    this.difficulty = HikingDifficulty.medium,
    required this.destination,
    this.offLineMapPath,
    this.status = HikingStatus.upcoming,
    List<Checkpoint>? checkpoints,
  }) : checkpoints = checkpoints ?? [];  // here is mean if a list is provided it use that list if not provide i create [] to store null
}
