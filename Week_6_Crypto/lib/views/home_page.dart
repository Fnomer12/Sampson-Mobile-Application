import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/coin_viewmodel.dart';
import '../models/coin.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CoinViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Prices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CoinViewModel>().refresh(),
          )
        ],
      ),
      body: _body(context, vm),
    );
  }

  Widget _body(BuildContext context, CoinViewModel vm) {
    // First-load spinner
    if (vm.isLoading && vm.coins.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error UI
    if (vm.errorMessage != null && vm.coins.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off, size: 56),
              const SizedBox(height: 12),
              const Text(
                'Failed to load data',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(vm.errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.read<CoinViewModel>().loadCoins(),
                child: const Text('Try again'),
              )
            ],
          ),
        ),
      );
    }

    // ✅ Last Updated + List + Pull-to-refresh
    return Column(
      children: [
        if (vm.lastUpdated != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Last updated: ${_formatTime(vm.lastUpdated!)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<CoinViewModel>().refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: vm.coins.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _coinTile(vm.coins[i]),
            ),
          ),
        ),
      ],
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Widget _coinTile(Coin c) {
    final isUp = c.change24h >= 0;

    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(c.imageUrl)),
        title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(c.symbol),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ✅ Animated price (fade) + more decimals so motion is visible
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                '\$${c.price.toStringAsFixed(4)}',
                key: ValueKey(c.price),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),

            // ✅ Animated percent change
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: Text(
                '${c.change24h.toStringAsFixed(3)}%',
                key: ValueKey(c.change24h),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isUp ? Colors.green : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}