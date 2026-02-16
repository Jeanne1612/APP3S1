import 'package:esme2526/datas/user_bet_repository_hive.dart';
import 'package:esme2526/models/user_bet.dart';

class UserBetCase {
  Future<void> createUserBet(UserBet userBet) async {
    //get userbet from repository
    final List<UserBet> userBets = await UserBetRepositoryHive().getUserBets();

    if (userBets.isNotEmpty) {
      bool isUserBetAlreadyExists = userBets.map((e) => e.id).contains(userBet.id);
      if (isUserBetAlreadyExists) {
        // update user bet
      }
    }

    await UserBetRepositoryHive().saveUserBet(userBet);
  }
}
