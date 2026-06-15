import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const BilliardsApp());
}

class BilliardsApp extends StatelessWidget {
  const BilliardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '中式八球',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainMenu(),
    );
  }
}
