import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyBatteryInfo(),
    );
  }
}

class MyBatteryInfo extends StatefulWidget {
  const MyBatteryInfo({super.key});

  @override
  State<MyBatteryInfo> createState() => _MyBatteryInfoState();
}

class _MyBatteryInfoState extends State<MyBatteryInfo> {
  final Battery _battery = Battery();

  BatteryState? _batteryState;
  StreamSubscription<BatteryState>? _batteryStateSubscription;
  int _batteryLevel = 0;
  late Timer timer;
  bool? _isInPowerSaveMode;

  @override
  void initState() {
    super.initState();
    getBatteryState();
    checkBatterSaveMode();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      getBatteryLevel();
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
  }

  void getBatteryState() {
    _batteryStateSubscription =
        _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });
  }

  getBatteryLevel() async {
    final level = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = level;
    });
  }

  Future<void> checkBatterSaveMode() async {
    final isInPowerSaveMode = await _battery.isInBatterySaveMode;
    setState(() {
      _isInPowerSaveMode = isInPowerSaveMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Plus'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Battery State: $_batteryState',
              style: const TextStyle(fontSize: 18),
            ),
            Text('Battery Level: $_batteryLevel %',
                style: const TextStyle(fontSize: 18)),
            Text("Is on low power mode: $_isInPowerSaveMode",
                style: const TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}
