import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/shared_pref.dart';

class PhotoGallery extends StatefulWidget {
  final Gallery gallery;
  final Vacation vacation;
  const PhotoGallery({Key? key, required this.gallery, required this.vacation});
  @override
  PhotoGalleryState createState() => PhotoGalleryState();
}

class PhotoGalleryState extends State<PhotoGallery> {
  final picker = ImagePicker();
  final List<File> _images = [];
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
  Widget build(BuildContext context) {
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    final List<String> _imageGallery = widget.gallery.imageUrls!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
          child: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.vacation.name,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Theme.of(context).colorScheme.background),
                ),
                smallerSizedBoxHeight,
                Text(
                  '${yearFormat.format(widget.vacation.endDate)}, '
                  '${dayMonthFormat.format(widget.vacation.startDate)} - ${dayMonthFormat.format(widget.vacation.endDate)}',
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Theme.of(context).colorScheme.background),
                ),
                smallerSizedBoxHeight,
                Text(
                  widget.vacation.countryName,
                  style: TextStyle(
                      fontSize: 10.0,
                      color: Theme.of(context).colorScheme.background),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
      body: Padding(
        padding: smallPadding,
        child: _imageGallery.isNotEmpty
            ? GridView.builder(
                itemCount: _imageGallery.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  final image = _imageGallery[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 200,
                    ),
                  );
                },
              )
            : Center(
                child: Text('Please, add some photos to your gallery!',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
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
