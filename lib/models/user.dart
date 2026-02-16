import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/wallet.dart';

class User {
  final String id; // shared preferences
  final String imgProfilUrl; // shared preferences
  final String name; // shared preferences
  final Wallet wallet; // Shared preferences
  final List<Bet> inProgressBets; // DB
  final List<Bet> completedBets; // DB
  final List<Bet> canceledBets; // DB
  final List<Bet> wishlistedBets; // DB

  User({
    required this.id,
    required this.imgProfilUrl,
    required this.name,
    required this.wallet,
    required this.inProgressBets,
    required this.completedBets,
    required this.canceledBets,
    required this.wishlistedBets,
  });

  User copyWith({
    String? imgProfilUrl,
    String? name,
    Wallet? wallet,
    List<Bet>? inProgressBets,
    List<Bet>? completedBets,
    List<Bet>? canceledBets,
    List<Bet>? wishlistedBets,
  }) {
    return User(
      id: id,
      imgProfilUrl: imgProfilUrl ?? this.imgProfilUrl,
      name: name ?? this.name,
      wallet: wallet ?? this.wallet,
      inProgressBets: inProgressBets ?? this.inProgressBets,
      completedBets: completedBets ?? this.completedBets,
      canceledBets: canceledBets ?? this.canceledBets,
      wishlistedBets: wishlistedBets ?? this.wishlistedBets,
    );
  }
}
