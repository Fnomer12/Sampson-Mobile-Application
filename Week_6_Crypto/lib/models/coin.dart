class Coin {
  final String id;
  final String name;
  final String symbol;
  final String imageUrl;
  final double price;
  final double change24h;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imageUrl,
    required this.price,
    required this.change24h,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      symbol: (json['symbol'] ?? '').toString().toUpperCase(),
      imageUrl: json['image'] ?? '',
      price: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      change24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
    );
  }
}