import 'package:esme2526/models/user_bet.dart';

abstract class UserBetRepositoryInterface {
  // static final UserBetRepositoryInterface _instance = UserBetRepository();
  // static UserBetRepositoryInterface get instance => _instance;

  Future<void> saveUserBet(UserBet userBet);
  Stream<List<UserBet>> getUserBetsStream();
  Future<List<UserBet>> getUserBets();
}
