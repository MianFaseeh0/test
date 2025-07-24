import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class InputPic extends StatefulWidget {
  InputPic({required this.takePic, this.selectedImage, super.key});
  final void Function() takePic;
  File? selectedImage;

  @override
  State<InputPic> createState() => _InputPicState();
}

class _InputPicState extends State<InputPic> {
  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      icon: Icon(Icons.camera_sharp, color: Colors.black),
      onPressed: widget.takePic,
      label: Text('Add Image', style: TextStyle(color: Colors.black)),
    );
    if (widget.selectedImage != null) {
      content = GestureDetector(
        onTap: widget.takePic,
        child: Image.file(widget.selectedImage!, fit: BoxFit.cover),
      );
    }
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromARGB(72, 255, 255, 255),
      ),
      clipBehavior: Clip.hardEdge,
      child: content,
    );
  }
}
