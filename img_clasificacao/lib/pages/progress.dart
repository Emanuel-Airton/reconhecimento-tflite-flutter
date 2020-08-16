import 'package:flutter/material.dart';
import 'package:img_clasificacao/pages/home_page.dart';
import 'package:progress_dialog/progress_dialog.dart';

class circular extends StatefulWidget {
  @override
  _circularState createState() => _circularState();
}

class _circularState extends State<circular> {
  bool valor = true;
  void initState() {
    super.initState();
    _carregando().then((value) => setState(() {
          valor = value;
        }));
  }

  Future _carregando() async {
    await Future.delayed(Duration(seconds: 4));
    return false;
  }

   _proximaTela()async{
    
     
     Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
     body: Center(
        child: valor == true
            ? CircularProgressIndicator(
              strokeWidth: 5.0,
              backgroundColor: Colors.white,
              
            )
            : _proximaTela() 
            

                )
    );
    
  }
}
