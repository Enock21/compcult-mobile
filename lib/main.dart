import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:museu_vivo/minigames/memory-game/memory_game.dart';
import 'package:museu_vivo/minigames/memory-game/minigame_bloc.dart';
import 'package:museu_vivo/pages/coins_bloc.dart';
import 'package:museu_vivo/pages/home_bloc.dart';
import 'package:museu_vivo/pages/mission_submit_bloc.dart';
import 'package:museu_vivo/pages/missions_bloc.dart';
import 'package:museu_vivo/pages/quiz_submit_bloc.dart';
import 'package:museu_vivo/pages/quizzes_bloc.dart';
import 'package:museu_vivo/pages/ranking_bloc.dart';
import 'package:museu_vivo/pages/sign_in_bloc.dart';
import 'package:museu_vivo/pages/sign_up_bloc.dart';
import 'package:museu_vivo/pages/team_details.dart';
import 'package:museu_vivo/pages/quiz_submit.dart';
import 'package:museu_vivo/pages/teams_bloc.dart';
import 'package:museu_vivo/pages/teams_page.dart';
import 'package:museu_vivo/pages/user_bloc.dart';
import 'package:museu_vivo/shared/models/user.dart';
import 'package:museu_vivo/shared/repositories/dio_repository.dart';
import 'package:museu_vivo/shared/repositories/mission_repository.dart';
import 'package:museu_vivo/shared/repositories/quiz_repository.dart';
import 'package:museu_vivo/shared/repositories/user_repository.dart';
import 'package:museu_vivo/shared/services/mission_service.dart';
import 'package:museu_vivo/shared/services/quiz_service.dart';
import 'package:museu_vivo/shared/services/user_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'minigames/memory-game/controller_game.dart';
import 'minigames/memory-game/memory_game_repository.dart';
import 'minigames/memory-game/memory_game_service.dart';
import 'pages/home_page.dart';
import 'pages/games_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/mission_submit.dart';
import 'config.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Dio dio = Dio(
    BaseOptions(baseUrl: config.apiUrl),
  );

  Future<Box> openBox() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    return await Hive.openBox('user');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: openBox(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final lastUser = snapshot.data.get(0);
          User user;
          final DioRepository dioRepository = DioRepository();

          if (lastUser != null) {
            user = User.fromJson(Map<String, dynamic>.from(lastUser));
            dioRepository.addToken(user.token);
          }

          var routeName;
          return BlocProvider(
            blocs: [
              Bloc((i) => HomeBloc(
                    i.get<MissionRepository>(),
                    i.get<QuizRepository>(),
                    i.get<MemoryGameRepository>(),
                  )),
              Bloc((i) => RankingBloc(i.get<UserRepository>())),
              Bloc((i) => SignUpBloc(i.get<UserRepository>())),
              Bloc((i) => UserBloc(i.get<UserRepository>())),
              Bloc((i) => SignInBloc(i.get<UserRepository>())),
              Bloc((i) => CoinsBloc(i.get<UserRepository>())),
              Bloc((i) => QuizzesBloc(i.get<QuizRepository>())),
              Bloc((i) => QuizSubmitBloc(i.get<QuizRepository>())),
              Bloc((i) => MissionsBloc(i.get<MissionRepository>())),
              Bloc((i) => MissionSubmitBloc(
                  i.get<MissionRepository>(), i.get<UserRepository>())),
              Bloc((i) => MemoryGamesBloc(i.get<MemoryGameRepository>())),
              Bloc((i) => TeamsBloc(i.get<UserRepository>())),
              Bloc((i) => ControllerMemoryGame(i.get<MemoryGameRepository>()))
            ],
            dependencies: [
              Dependency((i) => QuizRepository(
                    i.get<QuizService>(),
                    i.get<UserRepository>(),
                  )),
              Dependency((i) => MissionRepository(
                    i.get<MissionService>(),
                    i.get<UserRepository>(),
                  )),
              Dependency((i) => MemoryGameRepository(
                    i.get<MemoryGameService>(),
                    i.get<UserRepository>(),
                  )),
              Dependency((i) => UserRepository(
                    i.get<UserService>(),
                    user,
                    snapshot.data,
                    i.get<DioRepository>(),
                  )),
              Dependency((i) => UserService(i.get<DioRepository>().dio)),
              Dependency((i) => QuizService(i.get<DioRepository>().dio)),
              Dependency((i) => MissionService(i.get<DioRepository>().dio)),
              Dependency((i) => MemoryGameService(i.get<DioRepository>().dio)),
              Dependency((i) => dioRepository),
            ],
            child: MultiProvider(
              providers: [
                Provider<Dio>.value(
                  value: dio,
                ),
              ],
              child: MaterialApp(
                title: config.name,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'Poppins',
                  primaryColor: config.primaryColor,
                  accentColor: config.accentColor,
                  scaffoldBackgroundColor: Colors.white,
                  buttonTheme: ButtonThemeData(minWidth: 10),
                  textTheme: TextTheme(
                    button: TextStyle(fontSize: 10),
                  ),
                ),
                home: user == null ? SignInPage() : HomePage(),
                routes: {
                  SignInPage.routeName: (_) => SignInPage(),
                  GamesPage.routeName: (_) => GamesPage(),
                  HomePage.routeName: (_) => HomePage(),
                  TeamsPage.routeName: (_) => TeamsPage(),
                  MemoryGamePage.routeName: (_) => MemoryGamePage(),
                },
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case MissionSubmit.routeName:
                      return MaterialPageRoute(
                        builder: (_) => MissionSubmit(settings.arguments),
                      );
                      break;
                    case QuizSubmit.routeName:
                      return MaterialPageRoute(
                        builder: (_) => QuizSubmit(settings.arguments),
                      );
                      break;
                    case TeamDetails.routeName:
                      return MaterialPageRoute(
                        builder: (_) => TeamDetails(settings.arguments),
                      );
                      break;
                    default:
                      return null;
                  }
                },
              ),
            ),
          );
        } else {
          return Container(color: Colors.white);
        }
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
