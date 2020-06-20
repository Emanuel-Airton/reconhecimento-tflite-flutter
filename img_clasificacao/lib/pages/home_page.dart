import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
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
     
      body: SafeArea(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildResult(),
            _buildImage(),
             
            Padding(padding: EdgeInsets.fromLTRB(70, 0, 70, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              GFButton(
                onPressed: (){
                  _imgCamera();
                  return Center(
                   child: CircularProgressIndicator(),
                  ); 
                },
                text: "camera",
                icon: Icon(Icons.camera_alt, color: Colors.white,),
                color: Colors.green[500],
                size: 60,
                type: GFButtonType.solid,
              ),
              Padding(padding: EdgeInsets.only(right: 30)),

              GFButton(
                onPressed: ()async{
                   await _imgGaleria();
                   
                },
                text: "Galeria",
                icon: Icon(Icons.photo, color: Colors.white,),
                color: Colors.green[500],
                size: 60,
                type: GFButtonType.solid,
              ),
            ],   
            ),
            
            
            
            )
             
            
          


          
            
            
          ],
        ),
      ),
    );
  }

  
  _imgGaleria() async {
    final img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img == null) {
      return null;
    }
    final saida = await TFLiteHelper.classifyImage(img);
    setState(() {
      _image = img;
      _outputs = saida;
    });
  }


  _imgCamera() async {
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
          borderRadius: BorderRadius.circular(20),
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
      child: 
        ListView.builder(
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
  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green[500],
              width: 3,
            ),
            borderRadius: BorderRadius.circular(20),
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
}