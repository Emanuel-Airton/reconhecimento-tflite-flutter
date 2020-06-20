import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:img_clasificacao/pages/home_page.dart';

void main() => runApp(Myapp()
  );

class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown

   ]);
   return MaterialApp(
     theme: _buildTheme(),
     home: HomePage(),
     debugShowCheckedModeBanner: false,
   );
  }
  _buildTheme() {
    return ThemeData(
      brightness: Brightness.light,
      backgroundColor: Colors.green,
      primaryColor: Colors.green[300],
      accentColor: Colors.green[300],
      primarySwatch: Colors.lightGreen,
    );
  }
}
