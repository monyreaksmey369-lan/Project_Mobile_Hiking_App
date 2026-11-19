import 'package:lms_layered_architecture_example/model/hiking_plane.dart';
import 'package:test/test.dart';

import '../service/hiking_service.dart';
import '../model/destination.dart';
import '../model/checkpoint.dart';

void main() {
  // normal testing to add hiking and checkpoint
  test('add hiking plan and add checkpoint successful', () {
    final hikingService = HikingService();

    hikingService.addHiking(
        hikingId: 'H001',
        hikingName: 'Kulen Mountain Hiking',
        hikingDate: DateTime(2026, 12, 10),
        distance: 8.0,
        destination: Destination(
            name: 'Pnhom Kulen', latitude: 13.6000, longitude: 104.1000),
        checkpoint: Checkpoint(id: 'C001', name: 'start'));
    hikingService.addCheckpoint(
        hikingId: 'H001', checkPointId: 'C002', checkPointName: 'Waterfall');
    hikingService.addCheckpoint(
        hikingId: 'H001',
        checkPointId: 'C003',
        checkPointName: 'Mountain Viewer');

    expect(hikingService.getAllHiking().length, 1);

    final hiking = hikingService.getAllHiking().first;

    expect(hiking.checkpoints[0].name, 'start');
    expect(hiking.checkpoints[1].name, 'Waterfall');
    expect(hiking.checkpoints[2].name, 'Mountain Viewer');
  });

  test('can not add hiking plan duplicate', () {
    final hikingService = HikingService();

    hikingService.addHiking(
        hikingId: 'H001',
        hikingName: 'Pnhom Kulen Hiking',
        hikingDate: DateTime(2026, 12, 10),
        distance: 8.0,
        destination: Destination(
            name: 'Pnhom Kulen', latitude: 13.6000, longitude: 104.1000),
        checkpoint: Checkpoint(id: 'C001', name: 'start'));
    expect(
        () => hikingService.addHiking(
            hikingId: 'H001',
            hikingName: 'Banon Mountain Hiking',
            hikingDate: DateTime(2026, 12, 11),
            distance: 4.0,
            destination: Destination(
                name: 'Banon Mountain', latitude: 13.5, longitude: 104.0),
            checkpoint: Checkpoint(id: 'C002', name: 'lory')),
        throwsException);

    expect(hikingService.getAllHiking().length, 1);
    final hiking = hikingService.getAllHiking().first;
    expect(hiking.checkpoints[0].name, 'start');
  });

  test('complete hiking when all checkpoint are completed', () {
    final hikingService = HikingService();

    hikingService.addHiking(
        hikingId: 'H001',
        hikingName: 'Kulen Mountain Hiking',
        hikingDate: DateTime(2026, 12, 10),
        distance: 8.0,
        destination: Destination(
            name: 'Pnhom Kulen', latitude: 13.6000, longitude: 104.1000),
        checkpoint: Checkpoint(id: 'C001', name: 'start'));
    hikingService.addCheckpoint(
        hikingId: 'H001', checkPointId: 'C002', checkPointName: 'Waterfall');

    hikingService.startHiking('H001');
    hikingService.completeCheckPoint('H001', 'C001');
    hikingService.completeCheckPoint('H001', 'C002');

    expect(hikingService.getAllHiking().first.status, HikingStatus.completed);
  });

  test('Cannot add hiking with empty name', () {
    final hikingService = HikingService();

    expect(
        () => hikingService.addHiking(
            hikingId: 'H001',
            hikingName: '',
            hikingDate: DateTime(2026, 12, 10),
            distance: 8.0,
            destination: Destination(
                name: 'Pnhom Kulen', latitude: 13.6000, longitude: 104.1000),
            checkpoint: Checkpoint(id: 'C001', name: 'start')),
        throwsException);
  });

  test('Delete hiking plan successfully', () {
    final hikingService = HikingService();

    hikingService.addHiking(
        hikingId: 'H001',
        hikingName: 'Kulen Mountain Hiking',
        hikingDate: DateTime(2026, 12, 10),
        distance: 8.0,
        destination: Destination(
            name: 'Pnhom Kulen', latitude: 13.6000, longitude: 104.1000),
        checkpoint: Checkpoint(id: 'C001', name: 'start'));
    hikingService.addCheckpoint(
        hikingId: 'H001', checkPointId: 'C002', checkPointName: 'Waterfall');

    hikingService.deleteHiking('H001');
    expect(hikingService.getAllHiking().isEmpty, true);
  });
}
