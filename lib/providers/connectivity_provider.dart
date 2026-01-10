import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

  // هذا ملفات لي يتعامل مع حالات اتصال النت لي يخليك اتعامل مع الباكند حتى لو مفش نت
  // الملف هذا يحدد فيه نت او لا ويدير ابديت لما يقعد في نت


class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;

  ConnectivityProvider() {
    _init();
  }

  bool get isOffline => _isOffline;

  Future<void> _init() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    // If none of the results are cross-platform indicators of internet
    // (e.g. mobile, wifi, ethernet, vpn), we consider it offline.
    final bool offline = results.isEmpty || results.contains(ConnectivityResult.none);
    
    if (_isOffline != offline) {
      _isOffline = offline;
      notifyListeners();
    }
  }


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
