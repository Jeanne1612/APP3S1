import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/domain/bet_use_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/screens/home_page/widgets/bet_widget.dart';
import 'package:flutter/material.dart';
import 'package:esme2526/screens/chatbot_page.dart'; 


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bets"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Bet>>(
        stream: BetRepositoryHive().getBetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            List<Bet> bets = snapshot.data ?? [];
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: bets.length,
              itemBuilder: (context, index) {
                return BetWidget(bet: bets[index]);
              },
            );
          }
          return const Center(child: Text('No Data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ChatBotPage()),
          );
        },
        backgroundColor: Colors.blue,
        elevation: 6,
        shape: const CircleBorder(),
        child: const Text(
          '🤖',
          style: TextStyle(fontSize: 26),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
} // <--- Vérifie que cette dernière accolade est bien là !