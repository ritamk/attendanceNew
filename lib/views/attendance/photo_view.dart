import 'package:AnandaAttendance/shared/loading/loading.dart';
import 'package:flutter/material.dart';

class PhotoViewingPage extends StatefulWidget {
  const PhotoViewingPage({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<PhotoViewingPage> createState() => _PhotoViewingPageState();
}

class _PhotoViewingPageState extends State<PhotoViewingPage> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Picture")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(widget.url,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                    frame != null
                        ? child
                        : const Loading(white: false, rad: 14.0),
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress != null
                        ? const Loading(white: false, rad: 14.0)
                        : child),
          ),
        ),
      ),
    );
  }
}
