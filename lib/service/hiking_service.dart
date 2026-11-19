import 'package:lms_layered_architecture_example/model/destination.dart';

import '../model/checkpoint.dart';
import '../model/hiking_plane.dart';

class HikingService {
  final List<Checkpoint> checkpoints = [];
  final List<HikingPlane> hikingPlans = [];

  // 1. add hiking plan
  void addHiking({
    required String hikingId,
    required String hikingName,
    required DateTime hikingDate,
    required double distance,
    HikingDifficulty difficulty = HikingDifficulty.medium,
    required Destination destination,
    String? offLineMapPath,
    HikingStatus hikingStatus = HikingStatus.upcoming,
    required Checkpoint checkpoint,
  }) {
    // hiking plan shall not exist already
    if (_findHikingOrNull(hikingId) != null) {
      throw Exception('Hiking ${hikingId}, already exists');
    }
    if (hikingName.trim().isEmpty) {
      throw Exception('Hiking name cannot be empty');
    }
    if (distance <= 0) {
      throw Exception('Distance must be greater than zero');
    }

    hikingPlans.add(HikingPlane(
      id: hikingId,
      name: hikingName,
      hikingDate: hikingDate,
      distance: distance,
      destination: destination,
      difficulty: difficulty,
      offLineMapPath: offLineMapPath,
      status: hikingStatus,
      checkpoints: [checkpoint]
    ));
  }

  // 2. add checkpoint
  void addCheckpoint(
      {required String hikingId,
      required String checkPointId,
      required String checkPointName,
      String? description = '',
      double? latitude,
      double? longitude,
      String? photoPath,
      String? notes,
      bool isCompleted = false}) {
    // check hiking plan
    HikingPlane? hiking = _findHikingOrNull(hikingId);
    if (hiking == null) {
      throw Exception('Hiking ${hikingId} plan not found');
    }

    // check name can not be empty
    if (checkPointName.trim().isEmpty) {
      throw Exception('Checkpoint name cannot be empty');
    }

    // check id cause not need duplicated id
    for (HikingPlane plan in hikingPlans) {
      for (Checkpoint c in plan.checkpoints) {
        if (c.id == checkPointId) {
          throw Exception('Checkpoint $checkPointId already exists');
        }
      }
    }

    hiking.checkpoints.add(Checkpoint(
      id: checkPointId,
      name: checkPointName,
      description: description,
      latitude: latitude,
      longitude: longitude,
      photoPath: photoPath,
      notes: notes,
      isCompleted: isCompleted,
    ));
  }

  // get all hiking plans
  List<HikingPlane> getAllHiking() {
    return List.unmodifiable(hikingPlans);
  }

  // start hiking
  void startHiking(String hikingId) {
    HikingPlane? hiking = _findHikingOrNull(hikingId);

    if (hiking == null) {
      throw Exception('Hiking ${hikingId} not found');
    }

    if (hiking.status != HikingStatus.upcoming) {
      throw Exception('Hiking plan cannot be started');
    }
    hiking.status = HikingStatus.inProgress;
  }

  // complete checkpoint
  void completeCheckPoint(String hikingId, String checkPointId) {
    HikingPlane? hiking = _findHikingOrNull(hikingId);

    if (hiking == null) {
      throw Exception('Hiking ${hikingId} not found');
    }

    if (hiking.status != HikingStatus.inProgress) {
      throw Exception('Start hiking first');
    }

    Checkpoint? checkpoint;
    for (Checkpoint c in hiking.checkpoints) {
      if (c.id == checkPointId) {
        checkpoint = c;
        break;
      }
    }

    if (checkpoint == null) {
      throw Exception('Checkpoint ${checkPointId} not found');
    }
    if (checkpoint.isCompleted) {
      throw Exception('Checkpoint already completed');
    }

    // mark the checkpoint as completed
    checkpoint.isCompleted = true;

    // check whether all checkpoint are completed
    bool allCompleted = hiking.checkpoints.isNotEmpty &&
        hiking.checkpoints.every((c) => c.isCompleted);
    if (allCompleted) {
      hiking.status = HikingStatus.completed;
    }
  }

  // delete hiking plan and its checkpoint
  void deleteHiking(String hikingId) {
    HikingPlane? hiking = _findHikingOrNull(hikingId);

    if (hiking == null) {
      throw Exception('Hiking ${hikingId} not found');
    }

    hikingPlans.remove(hiking);
  }

  // find hiking plan by Id
  HikingPlane? _findHikingOrNull(String hikingId) {
    for (HikingPlane h in hikingPlans) {
      if (h.id == hikingId) return h;
    }
    return null;
  }
}
