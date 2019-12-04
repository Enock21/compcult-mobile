import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:museu_vivo/shared/models/mission.dart';
import 'package:museu_vivo/shared/repositories/user_repository.dart';
import 'package:museu_vivo/shared/services/mission_service.dart';
import 'package:rxdart/rxdart.dart';

class MissionRepository extends BlocBase {
  final MissionService missionService;
  final UserRepository userRepository;

  BehaviorSubject<List<Mission>> _missionController =
      BehaviorSubject<List<Mission>>();

  Observable<List<Mission>> get missions => _missionController.stream;

  MissionRepository(this.missionService, this.userRepository);

  fetchMissions() {
    userRepository.user.listen((user) async {
      final Response missionsResponse =
          await missionService.fetchMissions(user.id);

      _missionController.sink.add(List<Mission>.from(
        missionsResponse.data.map((mission) => Mission.fromJson(mission)),
      ));
    });
  }

  Future<Mission> fetchSecretMission(String missionId) async {
    final Response missionsResponse =
        await missionService.fetchSecretMission(missionId);

    return Mission.fromJson(missionsResponse.data[0]);
  }

  @override
  void dispose() {
    _missionController.close();
    super.dispose();
  }
}
