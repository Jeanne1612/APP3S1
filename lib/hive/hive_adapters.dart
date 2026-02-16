import 'package:esme2526/models/bet.dart';
import 'package:esme2526/models/data_bet.dart';
import 'package:esme2526/models/user_bet.dart';
import 'package:hive_ce/hive.dart';

@GenerateAdapters([AdapterSpec<Bet>(), AdapterSpec<DataBet>(), AdapterSpec<UserBet>()])
part 'hive_adapters.g.dart';
