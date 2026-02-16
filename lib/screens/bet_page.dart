import 'package:esme2526/domain/user_bet_case.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esme2526/screens/chatbot_page.dart';



class BetPage extends StatelessWidget {
  final Bet bet;
  TextEditingController textEditingController;

  BetPage({super.key, required this.bet, required this.textEditingController}) {
    textEditingController.text = "100";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bet.title)),

      body: Column(
        children: [
          Text(bet.description),
          Text("Odds: ${bet.odds}"),
          const SizedBox(height: 10),

          TextField(
            controller: textEditingController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter your bet",
            ),
          ),

          const SizedBox(height: 10),

          FilledButton(
            onPressed: () async {
              bool? result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Place Bet"),
                  content: Text(
                    "Gain potential: ${bet.odds * int.parse(textEditingController.text)}",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        await UserBetCase().createUserBet(
                          UserBet(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            userId: "1",
                            betId: bet.id,
                            amount: int.parse(textEditingController.text),
                            odds: bet.odds,
                            payout: bet.odds * int.parse(textEditingController.text),
                            createdAt: DateTime.now(),
                          ),
                        );
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("Confirm"),
                    ),
                  ],
                ),
              );

              if (result == true) {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Place Bet"),
          ),
        ],
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
