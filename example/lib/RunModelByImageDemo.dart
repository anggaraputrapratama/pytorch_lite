import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

class RunModelByImageDemo extends StatefulWidget {
  const RunModelByImageDemo({Key? key}) : super(key: key);

  @override
  _RunModelByImageDemoState createState() => _RunModelByImageDemoState();
}

class _RunModelByImageDemoState extends State<RunModelByImageDemo> {
  ClassificationModel? _imageModel;
  //CustomModel? _customModel;
  late ModelObjectDetection _objectModel;
  late ModelObjectDetection _objectModelYolov8;

  String? _imagePrediction;
  List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  //load your model
  Future loadModel() async {
    String pathImageModel = "assets/models/model_classification.pt";
    //String pathCustomModel = "assets/models/custom_model.ptl";
    String pathObjectDetectionModel = "assets/models/yolov5s.torchscript";
    String pathObjectDetectionModelYolov8 = "assets/models/yolov8s.torchscript";
    try {
      _imageModel = await PytorchLite.loadClassificationModel(
          pathImageModel, 224, 224,
          labelPath: "assets/labels/label_classification_imageNet.txt");
      //_customModel = await PytorchLite.loadCustomModel(pathCustomModel);
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModel, 80, 640, 640,
          labelPath: "assets/labels/labels_objectDetection_Coco.txt");
      _objectModelYolov8 = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModelYolov8, 80, 640, 640,
          labelPath: "assets/labels/labels_objectDetection_Coco.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov8);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  //run an image model
  Future runObjectDetectionWithoutLabels() async {
    //pick a random image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    objDetect = await _objectModel
        .getImagePredictionList(await File(image!.path).readAsBytes());
    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }
    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  Future runObjectDetection() async {
    //pick a random image
    Stopwatch stopwatch = Stopwatch()..start();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    objDetect = await _objectModel.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.3);
    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }
    print('object executed in ${stopwatch.elapsed.inMilliseconds}');
    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  Future runObjectDetectionYolov8() async {
    //pick a random image
    Stopwatch stopwatch = Stopwatch()..start();

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    objDetect = await _objectModelYolov8.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.1,
        IOUThershold: 0.3);
    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
        "class": element?.classIndex,
        "rect": {
          "left": element?.rect.left,
          "top": element?.rect.top,
          "width": element?.rect.width,
          "height": element?.rect.height,
          "right": element?.rect.right,
          "bottom": element?.rect.bottom,
        },
      });
    }
    print('object executed in ${stopwatch.elapsed.inMilliseconds}');
    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

  Future runClassification() async {
    objDetect = [];
    //pick a random image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //get prediction
    //labels are 1000 random english words for show purposes
    print(image!.path);
    _imagePrediction = await _imageModel!
        .getImagePrediction(await File(image.path).readAsBytes());

    List<double?>? predictionList = await _imageModel!.getImagePredictionList(
      await File(image.path).readAsBytes(),
    );

    print(predictionList);
    List<double?>? predictionListProbabilites =
        await _imageModel!.getImagePredictionListProbabilities(
      await File(image.path).readAsBytes(),
    );
    //Gettting the highest Probability
    double maxScoreProbability = double.negativeInfinity;
    double sumOfProbabilites = 0;
    int index = 0;
    for (int i = 0; i < predictionListProbabilites!.length; i++) {
      if (predictionListProbabilites[i]! > maxScoreProbability) {
        maxScoreProbability = predictionListProbabilites[i]!;
        sumOfProbabilites = sumOfProbabilites + predictionListProbabilites[i]!;
        index = i;
      }
    }
    print(predictionListProbabilites);
    print(index);
    print(sumOfProbabilites);
    print(maxScoreProbability);

    setState(() {
      //this.objDetect = objDetect;
      _image = File(image.path);
    });
  }

/*
  //run a custom model with number inputs
  Future runCustomModel() async {
    _prediction = await _customModel!
        .getPrediction([1, 2, 3, 4], [1, 2, 2], DType.float32);

    setState(() {});
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Run model with Image'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: objDetect.isNotEmpty
                  ? _image == null
                      ? const Text('No image selected.')
                      : _objectModel.renderBoxesOnImage(_image!, objDetect)
                  : _image == null
                      ? const Text('No image selected.')
                      : Image.file(_image!),
            ),
            Center(
              child: Visibility(
                visible: _imagePrediction != null,
                child: Text("$_imagePrediction"),
              ),
            ),
            /*
            Center(
              child: TextButton(
                onPressed: runImageModel,
                child: Row(
                  children: [

                    Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
            */

            TextButton(
              onPressed: runClassification,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run Classification",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: runObjectDetection,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection with labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: runObjectDetectionYolov8,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection yolov8 with labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: runObjectDetectionWithoutLabels,
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Run object detection without labels",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Visibility(
                visible: _prediction != null,
                child: Text(_prediction != null ? "${_prediction![0]}" : ""),
              ),
            )
          ],
        ),
      ),
    );
  }
}
