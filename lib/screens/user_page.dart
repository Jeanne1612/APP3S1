import 'dart:math';
import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/domain/bet_use_case.dart';
import 'package:esme2526/domain/user_use_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user.dart';
import 'package:esme2526/screens/home_page/home_page.dart';
import 'package:esme2526/screens/profile_widget.dart';
import 'package:esme2526/screens/user_bets_page.dart';
import 'package:esme2526/screens/chatbot_page.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _selectedIndex = 0;
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    UserUseCase userUseCase = UserUseCase();
    _userFuture = userUseCase.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...'), backgroundColor: Colors.white),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.white),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(user.name), backgroundColor: Colors.white),
          body: _getBody(_selectedIndex, user),
          
          floatingActionButton: Stack(
            children: [
              // TON BOUTON "+" POUR LES PARIS (Bord droit)
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "add_bet_btn",
                  onPressed: () async {
                    List<Bet> bets = await BetUseCase().getBets();
                    Bet randomBet = bets[Random().nextInt(bets.length)];
                    BetRepositoryHive().saveBets([randomBet]);
                  },
                  child: const Icon(Icons.add),
                ),
              ),

              // LE BOUTON ROBOT (Bord gauche)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: FloatingActionButton(
                    heroTag: "chatbot_btn",
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ChatBotPage()),
                      );
                    },
                    child: const Text('🤖', style: TextStyle(fontSize: 26)),
                  ),
                ),
              ),
            ],
          ),
          
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.deepPurple,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(.60),
            currentIndex: _selectedIndex,
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            items: const [
              BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
              BottomNavigationBarItem(label: 'Bets', icon: Icon(Icons.sports_esports)),
              BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
            ],
          ),
        );
      },
    );
  }

  Widget _getBody(int index, User user) {
    switch (index) {
      case 0:
        return const HomePage();
      case 1:
        return const UserBetsPage();
      case 2:
        return ProfileWidget(user: user);
      default:
        return const HomePage();
    }
  }
}