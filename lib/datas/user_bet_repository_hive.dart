import 'package:esme2526/datas/user_bet_repository_interface.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:hive_ce/hive.dart';

class UserBetRepositoryHive implements UserBetRepositoryInterface {
  final Future<Box<UserBet>> _userBetsBoxFuture;

  static UserBetRepositoryHive? _instance;

  UserBetRepositoryHive._internal() : _userBetsBoxFuture = Hive.openBox<UserBet>('userBets');

  factory UserBetRepositoryHive() {
    _instance ??= UserBetRepositoryHive._internal();
    return _instance!;
  }

  @override
  Future<List<UserBet>> getUserBets() async {
    final box = await _userBetsBoxFuture;
    return box.values.toList();
  }

  @override
  Stream<List<UserBet>> getUserBetsStream() async* {
    final box = await _userBetsBoxFuture;
    // Emit initial list of user bets
    final initialUserBets = box.values.toList();
    yield initialUserBets;

    // Watch for changes and emit updated list
    yield* box
        .watch()
        .asyncMap((event) async {
          await Future.microtask(() {});
          return box.values.toList();
        })
        .distinct((prev, next) {
          if (prev.length != next.length) return false;
          final prevIds = prev.map((b) => b.id).toSet();
          final nextIds = next.map((b) => b.id).toSet();
          return prevIds.length == nextIds.length && prevIds.every((id) => nextIds.contains(id));
        });
  }

  @override
  Future<void> saveUserBet(UserBet userBet) async {
    final box = await _userBetsBoxFuture;
    await box.add(userBet);
  }
}
