import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MachineLearning {
  Interpreter? interpreter;
  List<String> labels = [];

  Future<void> loadModel() async {
    interpreter = await Interpreter.fromAsset('assets/best_model.tflite');
    final labelData = await rootBundle.loadString('assets/labels.txt');
    labels = labelData.split(',');
  }

  Future<Map<String, dynamic>> predictDisease(File image) async {
    final bytes = await image.readAsBytes();
    img.Image updatedImage = img.decodeImage(bytes)!;
    updatedImage = img.copyResize(updatedImage, width: 300, height: 300);

    List<List<List<double>>> input = List.generate(
        300,
        (i) => List.generate(300, (j) {
              var pixelValue = updatedImage.getPixel(j, i);
              double r = pixelValue.r.toDouble();
              double g = pixelValue.g.toDouble();
              double b = pixelValue.b.toDouble();
              return [r, g, b];
            }));

    var batchInput = [input];
    var output = List.generate(1, (_) => List.filled(labels.length, 0.0));

    interpreter!.run(batchInput, output);

    int predictedIndex = output[0].indexOf(output[0].reduce(max));
    return {
      "prediction": labels[predictedIndex],
      "confidence": output[0][predictedIndex] * 100,
    };
  }
}
