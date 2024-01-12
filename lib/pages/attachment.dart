import 'package:flutter/material.dart';

class AttachmentPage extends StatefulWidget {
  const AttachmentPage({super.key});

  @override
  State<AttachmentPage> createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Attachment'),
      ),
    );
  }
}
