import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripster/utils/shared_pref.dart';

class PhotoGallery extends StatefulWidget {
  final String collectionName;

  const PhotoGallery({Key? key, required this.collectionName});
  @override
  PhotoGalleryState createState() => PhotoGalleryState();
}

class PhotoGalleryState extends State<PhotoGallery> {
  final List<File> _images = [];

  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      ImageSharedPrefs.saveImagesToPrefs(
          _images.map((image) => image.readAsBytesSync()).toList());
    }
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      ImageSharedPrefs.saveImagesToPrefs(
          _images.map((image) => image.readAsBytesSync()).toList());
    }
  }

  @override
  void initState() {
    super.initState();
    loadImageFromPrefs();
  }

  loadImageFromPrefs() async {
    final List<Uint8List>? imageBytesList =
        await ImageSharedPrefs.loadImagesFromPrefs();
    if (imageBytesList != null) {
      setState(() {
        _images.addAll(imageBytesList.map((bytes) => File.fromRawPath(bytes)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: UniqueKey(),
        title: Text(widget.collectionName),
      ),
      body: GridView.builder(
        itemCount: _images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemBuilder: (context, index) {
          return Image.file(_images[index]);
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "camera_fab",
            onPressed: getImageFromCamera,
            tooltip: 'Take a photo',
            child: Icon(Icons.camera_alt, color: kAccentColor),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'gallery_fab',
            onPressed: getImageFromGallery,
            tooltip: 'Select from gallery',
            child: Icon(Icons.photo_library, color: kAccentColor),
          ),
        ],
      ),
    );
  }
}
