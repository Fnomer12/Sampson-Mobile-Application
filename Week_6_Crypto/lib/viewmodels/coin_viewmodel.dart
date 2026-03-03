import 'dart:async';
import 'package:flutter/material.dart';
import '../models/coin.dart';
import '../services/api_service.dart';

class CoinViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();

  // Raw/latest from API
  List<Coin> _apiCoins = [];

  // What UI displays (animated)
  List<Coin> _displayCoins = [];

  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;

  Timer? _apiTimer;
  Timer? _tickTimer;

  List<Coin> get coins => _displayCoins;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;

  // store last displayed prices for smooth movement
  final Map<String, double> _currentPrice = {};
  final Map<String, double> _targetPrice = {};
  final Map<String, double> _currentChange = {};
  final Map<String, double> _targetChange = {};

  Future<void> init() async {
    await loadCoins();

    // Fetch real API updates every 15 seconds (safe)
    _apiTimer?.cancel();
    _apiTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      loadCoins(silent: true);
    });

    // Tick UI every 1 second to visually move prices
    _tickTimer?.cancel();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _animateOneStep();
    });
  }

  Future<void> loadCoins({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final data = await _api.fetchCoins(); // REAL live API
      _apiCoins = data;
      _lastUpdated = DateTime.now();

      // set targets for animation
      for (final c in _apiCoins) {
        final key = c.id;

        _targetPrice[key] = c.price;
        _targetChange[key] = c.change24h;

        // initialize current values if first time
        _currentPrice.putIfAbsent(key, () => c.price);
        _currentChange.putIfAbsent(key, () => c.change24h);
      }

      // initialize display list once
      if (_displayCoins.isEmpty) {
        _displayCoins = _apiCoins;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (!silent) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refresh() async {
    await loadCoins();
  }

  void _animateOneStep() {
    if (_apiCoins.isEmpty) return;

    // Move 25% toward the target each second (smooth)
    const double step = 0.25;

    final List<Coin> updated = _apiCoins.map((c) {
      final id = c.id;

      final curP = _currentPrice[id] ?? c.price;
      final tarP = _targetPrice[id] ?? c.price;
      final newP = curP + ((tarP - curP) * step);

      final curC = _currentChange[id] ?? c.change24h;
      final tarC = _targetChange[id] ?? c.change24h;
      final newC = curC + ((tarC - curC) * step);

      _currentPrice[id] = newP;
      _currentChange[id] = newC;

      return Coin(
        id: c.id,
        name: c.name,
        symbol: c.symbol,
        imageUrl: c.imageUrl,
        price: newP,
        change24h: newC,
      );
    }).toList();

    _displayCoins = updated;
    notifyListeners();
  }

  @override
  void dispose() {
    _apiTimer?.cancel();
    _tickTimer?.cancel();
    super.dispose();
  }
}