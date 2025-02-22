// Autogenerated from Pigeon (v9.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import, unnecessary_parenthesis, prefer_null_aware_operators, omit_local_variable_types, unused_shown_name, unnecessary_import

import 'dart:async';
import 'dart:typed_data' show Float64List, Int32List, Int64List, Uint8List;

import 'package:flutter/foundation.dart' show ReadBuffer, WriteBuffer;
import 'package:flutter/services.dart';

enum ObjectDetectionModelType {
  yolov5,
  yolov8,
}

class PyTorchRect {
  PyTorchRect({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.width,
    required this.height,
  });

  double left;

  double top;

  double right;

  double bottom;

  double width;

  double height;

  Object encode() {
    return <Object?>[
      left,
      top,
      right,
      bottom,
      width,
      height,
    ];
  }

  static PyTorchRect decode(Object result) {
    result as List<Object?>;
    return PyTorchRect(
      left: result[0]! as double,
      top: result[1]! as double,
      right: result[2]! as double,
      bottom: result[3]! as double,
      width: result[4]! as double,
      height: result[5]! as double,
    );
  }
}

class ResultObjectDetection {
  ResultObjectDetection({
    required this.classIndex,
    this.className,
    required this.score,
    required this.rect,
  });

  int classIndex;

  String? className;

  double score;

  PyTorchRect rect;

  Object encode() {
    return <Object?>[
      classIndex,
      className,
      score,
      rect.encode(),
    ];
  }

  static ResultObjectDetection decode(Object result) {
    result as List<Object?>;
    return ResultObjectDetection(
      classIndex: result[0]! as int,
      className: result[1] as String?,
      score: result[2]! as double,
      rect: PyTorchRect.decode(result[3]! as List<Object?>),
    );
  }
}

class _ModelApiCodec extends StandardMessageCodec {
  const _ModelApiCodec();
  @override
  void writeValue(WriteBuffer buffer, Object? value) {
    if (value is PyTorchRect) {
      buffer.putUint8(128);
      writeValue(buffer, value.encode());
    } else if (value is ResultObjectDetection) {
      buffer.putUint8(129);
      writeValue(buffer, value.encode());
    } else {
      super.writeValue(buffer, value);
    }
  }

  @override
  Object? readValueOfType(int type, ReadBuffer buffer) {
    switch (type) {
      case 128:
        return PyTorchRect.decode(readValue(buffer)!);
      case 129:
        return ResultObjectDetection.decode(readValue(buffer)!);
      default:
        return super.readValueOfType(type, buffer);
    }
  }
}

class ModelApi {
  /// Constructor for [ModelApi].  The [binaryMessenger] named argument is
  /// available for dependency injection.  If it is left null, the default
  /// BinaryMessenger will be used which routes to the host platform.
  ModelApi({BinaryMessenger? binaryMessenger})
      : _binaryMessenger = binaryMessenger;
  final BinaryMessenger? _binaryMessenger;

  static const MessageCodec<Object?> codec = _ModelApiCodec();

  Future<int> loadModel(
      String arg_modelPath,
      int? arg_numberOfClasses,
      int? arg_imageWidth,
      int? arg_imageHeight,
      ObjectDetectionModelType? arg_objectDetectionModelType) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ModelApi.loadModel', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel.send(<Object?>[
      arg_modelPath,
      arg_numberOfClasses,
      arg_imageWidth,
      arg_imageHeight,
      arg_objectDetectionModelType?.index
    ]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as int?)!;
    }
  }

  ///predicts abstract number input
  Future<List<Object?>?> getPredictionCustom(int arg_index,
      List<double?> arg_input, List<int?> arg_shape, String arg_dtype) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ModelApi.getPredictionCustom', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel
            .send(<Object?>[arg_index, arg_input, arg_shape, arg_dtype])
        as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as List<Object?>?);
    }
  }

  ///predicts image but returns the raw net output
  Future<List<double?>?> getImagePredictionList(
      int arg_index,
      Uint8List? arg_imageData,
      List<Uint8List?>? arg_imageBytesList,
      int? arg_imageWidthForBytesList,
      int? arg_imageHeightForBytesList,
      List<double?> arg_mean,
      List<double?> arg_std) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ModelApi.getImagePredictionList', codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel.send(<Object?>[
      arg_index,
      arg_imageData,
      arg_imageBytesList,
      arg_imageWidthForBytesList,
      arg_imageHeightForBytesList,
      arg_mean,
      arg_std
    ]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else {
      return (replyList[0] as List<Object?>?)?.cast<double?>();
    }
  }

  ///predicts image but returns the output detections
  Future<List<ResultObjectDetection?>> getImagePredictionListObjectDetection(
      int arg_index,
      Uint8List? arg_imageData,
      List<Uint8List?>? arg_imageBytesList,
      int? arg_imageWidthForBytesList,
      int? arg_imageHeightForBytesList,
      double arg_minimumScore,
      double arg_IOUThreshold,
      int arg_boxesLimit) async {
    final BasicMessageChannel<Object?> channel = BasicMessageChannel<Object?>(
        'dev.flutter.pigeon.ModelApi.getImagePredictionListObjectDetection',
        codec,
        binaryMessenger: _binaryMessenger);
    final List<Object?>? replyList = await channel.send(<Object?>[
      arg_index,
      arg_imageData,
      arg_imageBytesList,
      arg_imageWidthForBytesList,
      arg_imageHeightForBytesList,
      arg_minimumScore,
      arg_IOUThreshold,
      arg_boxesLimit
    ]) as List<Object?>?;
    if (replyList == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
      );
    } else if (replyList.length > 1) {
      throw PlatformException(
        code: replyList[0]! as String,
        message: replyList[1] as String?,
        details: replyList[2],
      );
    } else if (replyList[0] == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    } else {
      return (replyList[0] as List<Object?>?)!.cast<ResultObjectDetection?>();
    }
  }
}
