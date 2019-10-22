import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:museu_vivo/pages/ranking.dart';

import './sign_in_page.dart';
import './missions_page.dart';
import './quizzes_page.dart';

class MainPage extends StatelessWidget {
  static const String routeName = '/main';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Meu Vivo Museu',
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (_) => Navigator.of(context).pushNamedAndRemoveUntil(
                SignInPage.routeName,
                (route) => false,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 1,
                  child: Text(
                    "Sair",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "MISSÕES",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
              ),
              Tab(
                child: Text(
                  "QUIZZES",
                  style: TextStyle(fontFamily: "Poppins"),
                ),
              ),
            ],
          ),
        ),
        drawer: Ranking(),
        body: TabBarView(
          children: <Widget>[
            MissionsPage(),
            QuizzesPage(),
          ],
        ),
      ),
    );
  }
}
