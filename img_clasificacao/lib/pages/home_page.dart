import 'dart:io';
import 'package:flutter/material.dart';
import 'package:img_clasificacao/helpers/galeria_helper.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:img_clasificacao/helpers/camera_helper.dart';
import 'package:img_clasificacao/helpers/tflite_helper.dart';
import 'package:img_clasificacao/models/tflite_result.dart';
//import 'package:getflutter/getflutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];
  
  bool valor = true;
  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();

    _aguardar().then((value) => setState(() {
          valor = value;
        }));
    }
  
  
  Future _aguardar()async{
    await Future.delayed(Duration(seconds:3));
    return valor = false;
  }

  @override
  void dispose() {
    TFLiteHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Identificação', style: TextStyle(color: Colors.green[900], fontWeight: FontWeight.w500),),
      ),

      body: valor == true ?
      Center(
        child: CircularProgressIndicator(
          strokeWidth: 7, 
        ),
      ):
      SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildResult(),
            _buildImage(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Padding(padding: EdgeInsets.only(top: 10),),

              IconButton(icon: Icon(Icons.camera_alt),
                color: Colors.green[800],
                iconSize: 60,
               onPressed: _pickImage),
              IconButton(icon: Icon(Icons.photo),
               color: Colors.green[800],
               iconSize: 60, 
               onPressed: _imgGaleria),
            
            ],
            
            ),
          ],
        ),



      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green[500],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _image == null
                ? Text('Sem imagem',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.green[700]),)
                : Image.file(
                    _image,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
  _imgGaleria() async {
    final img = await GaleriaHelper.opengalery();
    if (img == null) {
      return null;
    }

    final saida = await TFLiteHelper.classifyImage(img);

    setState(() {
      _image = img;
      _outputs = saida;
    });
  }

  _pickImage() async {
    final image = await CameraHelper.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.green[500],
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return Center(
        child: Text('Sem resultados', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.green[700]),),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Text(
                '${_outputs[index].label}',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.green[800]),
              ),Divider(color: Colors.transparent,),
            
              Padding(padding: EdgeInsets.only(bottom: 10),
              
               child: new CircularPercentIndicator(
                 radius: 80,
                 lineWidth: 5.0,
                 animation: true,
                 center: Text('${(_outputs[index].confidence * 100).toStringAsFixed(1)} %', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.green[800]),),
                 percent: _outputs[index].confidence,
                 footer: new Text(
                  "Porcentagem",
                  style:
                      new TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.green[800],

                 ),
              )
             
            ],
          );
        },
      ),
    );
  }
}