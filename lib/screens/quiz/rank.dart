import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/quiz/global_rank.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../customized_app_bar.dart';
import '../../generated/l10n.dart';
import '../../models/player.dart';
import 'local_rank.dart';

class Rank extends StatelessWidget {
  final Player currentUser;

  const Rank({required this.currentUser, super.key});

  @override
  Widget build(BuildContext context) {
    final _appBar = CustomizedAppBar(
      leading: IconButton(
        key: const Key('arrow_back'),

        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).iconTheme.color, size: 30),
        onPressed: () => {
          Navigator.pop(context),
        },
      ),
      title: AutoSizeText(
        S.of(context).GlobalTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30),
      ),
      bottom: TabBar(
          indicatorColor: Theme.of(context).iconTheme.color,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                key: const Key('globalrank_button'),

                FontAwesomeIcons.earthAmericas,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            Tab(
              icon: Icon(
                  key: const Key('localrank_button'),

                  Icons.pin_drop,
                  color: Theme.of(context).iconTheme.color),
            )
          ]),
    );

    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;

    return DefaultTabController(
        key: const Key('rank_page'),

        initialIndex: 0,
        length: 2,
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: _appBar,
          body: TabBarView(
            children: <Widget>[
              GlobalRank(
                currentUser: currentUser,
                height: _height,
                width: _screenWidth,
              ),
              LocalRank(
                currentUser: currentUser,
                height: _height,
                width: _screenWidth,
              ),
            ],
          ),
        ));
  }
}
