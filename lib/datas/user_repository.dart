import 'dart:convert';

import 'package:esme2526/datas/bet_repository_hive.dart';
import 'package:esme2526/datas/user_repository_interface.dart';
import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/user.dart';
import 'package:esme2526/models/wallet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository implements UserRepositoryInterface {
  @override
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if user data exists
    final userId = prefs.getString('user');

    if (userId == null) {
      // No user data exists, create and save initial user
      final initialUser = User(
        id: "1",
        imgProfilUrl: "https://assets.codepen.io/1477099/internal/avatars/users/default.png",
        name: "John Doe",
        wallet: Wallet(id: "1", tokens: 100),
        inProgressBets: [],
        completedBets: [],
        canceledBets: [],
        wishlistedBets: [],
      );
      await saveUser(initialUser);
      return initialUser;
    }

    // User data exists, load from SharedPreferences
    final imgProfilUrl = prefs.getString('imgProfilUrl') ?? "";
    final name = prefs.getString('name') ?? "";
    final walletJson = prefs.getString('wallet');
    final inProgressBetIds = prefs.getStringList('inProgressBets') ?? [];
    final completedBetIds = prefs.getStringList('completedBets') ?? [];
    final canceledBetIds = prefs.getStringList('canceledBets') ?? [];
    final wishlistedBetIds = prefs.getStringList('wishlistedBets') ?? [];

    // Parse wallet
    Wallet wallet;
    if (walletJson != null) {
      final walletMap = jsonDecode(walletJson) as Map<String, dynamic>;
      wallet = Wallet.fromJson(walletMap);
    } else {
      wallet = Wallet(id: "1", tokens: 100);
    }

    // Get bet objects from repository
    final allBets = await BetRepositoryHive().getBets();
    final betsById = {for (var bet in allBets) bet.id: bet};

    final inProgressBets = inProgressBetIds.map((id) => betsById[id]).whereType<Bet>().toList();
    final completedBets = completedBetIds.map((id) => betsById[id]).whereType<Bet>().toList();
    final canceledBets = canceledBetIds.map((id) => betsById[id]).whereType<Bet>().toList();
    final wishlistedBets = wishlistedBetIds.map((id) => betsById[id]).whereType<Bet>().toList();

    return User(
      id: userId,
      imgProfilUrl: imgProfilUrl,
      name: name,
      wallet: wallet,
      inProgressBets: inProgressBets,
      completedBets: completedBets,
      canceledBets: canceledBets,
      wishlistedBets: wishlistedBets,
    );
  }

  @override
  Future<void> saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.id);
    prefs.setString('imgProfilUrl', user.imgProfilUrl);
    prefs.setString('name', user.name);
    prefs.setString('wallet', jsonEncode(user.wallet.toJson()));
    prefs.setStringList('inProgressBets', user.inProgressBets.map((bet) => bet.id).toList());
    prefs.setStringList('completedBets', user.completedBets.map((bet) => bet.id).toList());
    prefs.setStringList('canceledBets', user.canceledBets.map((bet) => bet.id).toList());
    prefs.setStringList('wishlistedBets', user.wishlistedBets.map((bet) => bet.id).toList());
  }
}
