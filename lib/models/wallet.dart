class Wallet {
  final String id;
  final int tokens;

  Wallet({required this.id, required this.tokens});

  Wallet copyWith({int? tokens}) {
    return Wallet(id: id, tokens: tokens ?? this.tokens);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'tokens': tokens};
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(id: json['id'] as String, tokens: json['tokens'] as int);
  }
}
