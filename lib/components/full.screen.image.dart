import 'dart:typed_data';

import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final Future<Uint8List> imageData;

  FullScreenImage(this.imageData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Uint8List>(
        future: imageData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Pop the full-screen image
              },
              child: Center(
                child: Image.memory(snapshot.data!),
              ),
            );
          }
        },
      ),
    );
  }
}
