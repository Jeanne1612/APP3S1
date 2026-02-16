import 'package:esme2526/datas/user_bet_repository_hive.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:flutter/material.dart';

class UserBetsPage extends StatelessWidget {
  const UserBetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userBetRepository = UserBetRepositoryHive();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bets'), backgroundColor: Colors.white),
      body: StreamBuilder<List<UserBet>>(
        stream: userBetRepository.getUserBetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final userBets = snapshot.data ?? [];

          if (userBets.isEmpty) {
            return const Center(
              child: Text('No bets yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: userBets.length,
            itemBuilder: (context, index) {
              final userBet = userBets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text('Bet ID: ${userBet.betId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Amount: ${userBet.amount}'),
                      Text('Odds: ${userBet.odds}'),
                      Text('Potential Payout: ${userBet.payout.toStringAsFixed(2)}'),
                      const SizedBox(height: 4),
                      Text('Created: ${_formatDateTime(userBet.createdAt)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}
