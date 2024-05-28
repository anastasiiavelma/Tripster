import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/gallery_repository.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';

class CollectionDialog extends StatefulWidget {
  final String? token;
  final List<Vacation> vacations1;
  final GalleryCubit galleryCubit;
  const CollectionDialog(
      {Key? key,
      this.token,
      required this.vacations1,
      required this.galleryCubit})
      : super(key: key);

  @override
  _CollectionDialogState createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<CollectionDialog> {
  List<File>? _selectedImages;
  String? _selectedVacationId;

  @override
  void initState() {
    super.initState();
    _selectedVacationId =
        widget.vacations1.isNotEmpty ? widget.vacations1[0].vacationId : '';
  }

  @override
  Widget build(BuildContext context) {
    print(widget.vacations1.length);
    print(_selectedVacationId);
    return Container(
      constraints: const BoxConstraints(minHeight: 500),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: SingleChildScrollView(
        padding: midPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                'Add New Gallery',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            smallSizedBoxHeight,
            Padding(
              padding: smallPadding,
              child: Text(
                'Select vacation',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            smallSizedBoxHeight,
            SizedBox(
              height: 60,
              child: DropdownButtonFormField(
                key: UniqueKey(),
                value: _selectedVacationId,
                onChanged: (value) {
                  setState(() {
                    _selectedVacationId = value;
                  });
                },
                items: widget.vacations1.map((vacation) {
                  return DropdownMenuItem(
                    value: vacation.vacationId.isNotEmpty
                        ? vacation.vacationId
                        : '',
                    child: Text(
                      vacation.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelStyle: Theme.of(context).textTheme.headlineMedium,
                  labelText: 'vacations',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
            smallSizedBoxHeight,
            Padding(
              padding: smallPadding,
              child: Text(
                'Select photos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            _selectPhoto(),
            smallSizedBoxHeight,
            smallSizedBoxHeight,
            TextAccentButton(
              color: Theme.of(context).colorScheme.onBackground,
              onTap: () async {
                if (_selectedVacationId!.isNotEmpty &&
                    _selectedImages != null) {
                  widget.galleryCubit.createGallery(
                    image: _selectedImages!,
                    vacationId: _selectedVacationId!,
                    token: widget.token,
                  );
                  Navigator.of(context).pop();
                } else {
                  print('error');
                }
              },
              child: Text('Add', style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _convertFilesToBase64(List<File> files) async {
    List<String> base64Images = [];
    for (File file in files) {
      final bytes = await file.readAsBytes();
      base64Images.add(base64Encode(bytes));
    }
    return base64Images;
  }

  Widget _selectPhoto() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground,
          width: 1,
        ),
      ),
      child: Padding(
        padding: smallPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 90,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: IconButton(
                onPressed: () async {
                  final List<XFile>? images =
                      await ImagePicker().pickMultiImage();
                  if (images != null) {
                    setState(() {
                      _selectedImages =
                          images.map((image) => File(image.path)).toList();
                    });
                  }
                },
                icon: Icon(
                  size: 25,
                  Icons.add_outlined,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _selectedImages != null
                    ? Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedImages!.map((image) {
                          return Image.file(
                            image,
                            width: 100,
                            height: 100,
                          );
                        }).toList(),
                      )
                    : Text('No images selected'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
