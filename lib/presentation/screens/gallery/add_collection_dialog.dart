import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/widgets/custom_text_widget.dart';
import 'package:tripster/presentation/widgets/snack_bar_widget.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class CollectionDialog extends StatefulWidget {
  final String? token;
  final bool isEdit;
  final List<Vacation> vacations;
  final Vacation? vacation;
  final Gallery? gallery;
  final GalleryCubit galleryCubit;
  const CollectionDialog({
    Key? key,
    this.token,
    required this.vacations,
    required this.galleryCubit,
    required this.isEdit,
    this.vacation,
    this.gallery,
  }) : super(key: key);

  @override
  _CollectionDialogState createState() => _CollectionDialogState();
}

class _CollectionDialogState extends State<CollectionDialog> {
  List<File>? _selectedImages;
  String? _selectedVacationId;

  void initState() {
    super.initState();

    _selectedVacationId =
        widget.vacations.isNotEmpty ? widget.vacations[0].vacationId : null;
  }

  @override
  Widget build(BuildContext context) {
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
                widget.isEdit
                    ? LocaleKeys.dialog_gallery_update_gallery.tr()
                    : LocaleKeys.dialog_gallery_add_new_gallery.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            smallSizedBoxHeight,
            Padding(
              padding: smallPadding,
              child: Text(
                widget.isEdit
                    ? LocaleKeys.dialog_gallery_name_gallery.tr()
                    : LocaleKeys.dialog_gallery_select_vacation.tr(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(
              height: 60,
              child: widget.isEdit
                  ? CircularTextWithBorder(
                      text: widget.vacation!.name,
                      fontSize: 20.0,
                      borderColor: Theme.of(context).colorScheme.onBackground,
                    )
                  : DropdownButtonFormField(
                      key: UniqueKey(),
                      value: _selectedVacationId,
                      onChanged: (value) {
                        setState(() {
                          _selectedVacationId = value;
                        });
                      },
                      items: widget.vacations.map((vacation) {
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
                        labelText:
                            LocaleKeys.dialog_gallery_select_vacations.tr(),
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
                widget.isEdit
                    ? LocaleKeys.dialog_gallery_add_new_photos.tr()
                    : LocaleKeys.dialog_gallery_select_photos.tr(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            _selectPhoto(),
            smallSizedBoxHeight,
            smallSizedBoxHeight,
            TextAccentButton(
              color: Theme.of(context).colorScheme.onBackground,
              onTap: () async {
                if (widget.isEdit) {
                  await widget.galleryCubit.addImageToGallery(
                    image: _selectedImages!,
                    vacationId: widget.vacation!.vacationId,
                    token: widget.token,
                    galleryId: widget.gallery!.galleryId,
                  );
                  CustomSnackBar.show(
                    context,
                    message:
                        LocaleKeys.dialog_gallery_gallery_updated_success.tr(),
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                  );
                  Navigator.of(context).pop();
                } else {
                  if (_selectedVacationId!.isNotEmpty &&
                      _selectedImages != null) {
                    widget.galleryCubit.createGallery(
                      image: _selectedImages!,
                      vacationId: _selectedVacationId!,
                      token: widget.token,
                    );
                    CustomSnackBar.show(
                      context,
                      message: LocaleKeys.dialog_gallery_gallery_created_success
                          .tr(),
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                    Navigator.of(context).pop();
                  } else {
                    CustomSnackBar.show(
                      context,
                      message: LocaleKeys.dialog_gallery_please_add_photo.tr(),
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                }
              },
              child: Text(widget.isEdit ? 'Update' : 'Add',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
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
                      await ImagePicker().pickMultiImage(imageQuality: 10);
                  if (images != null && images.length < 11) {
                    setState(() {
                      _selectedImages =
                          images.map((image) => File(image.path)).toList();
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You can select up to 10 photos.'),
                      ),
                    );
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
                    : Text(LocaleKeys.no_image_selected.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
