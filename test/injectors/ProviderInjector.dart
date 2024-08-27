import 'package:cave_manager/providers/bottles_provider.dart';
import 'package:cave_manager/providers/clusters_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProviderInjector extends StatelessWidget {
  final Widget child;

  const ProviderInjector({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => BottlesProvider()),
      ChangeNotifierProvider(create: (context) => ClustersProvider()),
    ], child: child);
  }
}
