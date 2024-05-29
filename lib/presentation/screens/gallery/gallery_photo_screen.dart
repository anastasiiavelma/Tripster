import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/data/repository/gallery_repository.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_cubit.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_state.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';

class PhotoGallery extends StatefulWidget {
  final Gallery gallery;
  final Vacation vacation;
  final GalleryCubit galleryCubit;
  final String? token;
  const PhotoGallery(
      {Key? key,
      required this.gallery,
      required this.vacation,
      required this.galleryCubit,
      this.token});
  @override
  PhotoGalleryState createState() => PhotoGalleryState();
}

class PhotoGalleryState extends State<PhotoGallery> {
  final picker = ImagePicker();
  final List<File> _images = [];

  @override
  void initState() {
    super.initState();
    widget.galleryCubit.loadGallery(galleryId: widget.gallery.galleryId);
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      try {
        await widget.galleryCubit.addImageToGallery(
          image: [imageFile],
          vacationId: widget.vacation.vacationId,
          token: widget.token,
          galleryId: widget.gallery.galleryId,
        );

        setState(() {
          _images.add(imageFile);
        });
      } catch (e) {
        print('Error adding image to gallery: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    final GalleryCubit galleryCubit = GalleryCubit(GalleryRepository());
    final List<String> imageGallery = widget.gallery.imageUrls!;
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
      body: BlocProvider(
        create: (context) =>
            galleryCubit..loadGallery(galleryId: widget.gallery.galleryId),
        child: BlocBuilder<GalleryCubit, GalleryState>(
          builder: (context, state) {
            if (state is GalleryLoading) {
              getCircularProgressIndicator2(context);
            }
            if (state is GalleryPhotosLoaded) {
              final gallery = state.gallery;
              final _imageGallery = gallery.imageUrls!;
              return Padding(
                padding: smallPadding,
                child: _imageGallery.isNotEmpty
                    ? GridView.builder(
                        itemCount: _imageGallery.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder: (context, index) {
                          final image = _imageGallery[index];
                          return GestureDetector(
                            onLongPress: () => showDialog(
                              context: context,
                              builder: (context) => DeleteDialog(
                                  gallery: gallery,
                                  token: widget.token,
                                  imageUrl: image,
                                  galleryCubit: galleryCubit),
                            ),
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) =>
                                  FullScreenImageDialog(imageUrl: image),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                                height: 150,
                                width: 200,
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('Please, add some photos to your gallery!',
                            style: Theme.of(context).textTheme.headlineMedium),
                      ),
              );
            } else {
              return Center(child: getCircularProgressIndicator2(context));
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
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

class DeleteDialog extends StatelessWidget {
  final String imageUrl;
  final GalleryCubit galleryCubit;
  final Gallery gallery;
  final String? token;
  const DeleteDialog({
    required this.imageUrl,
    required this.galleryCubit,
    required this.gallery,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to delete this image?',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(width: 16.0),
                  TextAccentButton(
                    height: 40,
                    onTap: () {
                      galleryCubit.deleteImageFromGallery(
                          image: imageUrl,
                          token: token,
                          galleryId: gallery.galleryId);
                      Navigator.pop(context, true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Delete',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImageDialog extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageDialog({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 300,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: 'full_image',
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
