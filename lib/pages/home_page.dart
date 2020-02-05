import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:museu_vivo/pages/minigames_page.dart';
import 'package:museu_vivo/pages/user_page.dart';

import '../config.dart';
import 'bloc/home_bloc.dart';
import 'coins_page.dart';
import 'games_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;

  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentScreen = GamesPage(); // A view inicial
  int _currentIndex = 0;

  final tabs = [
    // DashboardPage(),
    CoinsPage(),
    GamesPage(),
    MiniGames(),
    UserPage(),
  ];

  @override
  void didChangeDependencies() {
    HomeBloc homeBloc = BlocProvider.getBloc<HomeBloc>();
    homeBloc.fetchMissions();
    homeBloc.fetchQuizzes();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: tabs[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        backgroundColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.dashboard),
          //   title: Text('Timeline'),
          //   backgroundColor: Colors.red,
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            title: Text(config.coinName),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark),
            title: Text('Atividades'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.games),
            title: Text('Minijogos'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Perfil'),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
