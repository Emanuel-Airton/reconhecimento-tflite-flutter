import 'dart:io';
import 'package:flutter/material.dart';
import 'package:img_clasificacao/helpers/galeria_helper.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
//import 'package:img_clasificacao/helpers/camera_helper.dart';
import 'package:img_clasificacao/helpers/tflite_helper.dart';
import 'package:img_clasificacao/models/tflite_result.dart';
import 'package:getflutter/getflutter.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
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
        title: Text('Identificação'),
      ),
     /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: _pickImage,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      */
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildResult(),
            _buildImage(),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Padding(padding: EdgeInsets.only(left: 30, right: 45, bottom: 30, top: 30)),
              GFButton(
                onPressed: (){
                  ImagePicker.pickImage(source: ImageSource.camera);
                },
                text: "camera",
                icon: Icon(Icons.camera_alt, color: Colors.white,),
                color: Colors.green[500],
                size: 50,
                type: GFButtonType.solid,
              // shape: GFButtonShape.pills,
                
              ),Padding(padding: EdgeInsets.only(right: 30)),
              GFButton(
                onPressed: (_imgGaleria),
                text: "Galeria",
                icon: Icon(Icons.photo, color: Colors.white,),
                color: Colors.green[500],
                size: 50,
                type: GFButtonType.solid,
              
              ),
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
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
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
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }
//
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
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
              ),Divider(color: Colors.transparent,),
              Text(
                ' ${(_outputs[index].confidence * 100.0).toStringAsFixed(2)} % ',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              ),
              SizedBox(
                height: 10.0,
              ),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: _outputs[index].confidence,
              ),
            ],
          );
        },
      ),
    );
  }
}