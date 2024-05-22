import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/domain/models/user_model.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/widgets/custom_textfield.dart';
import 'package:tripster/utils/constants.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileCubit profileCubit;
  final ProfileUser userInfo;
  const EditProfileScreen(
      {super.key, required this.profileCubit, required this.userInfo});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  File? _image;
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Update information',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                      smallSizedBoxHeight,
                      smallSizedBoxHeight,
                      Text('Change name',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 15)),
                    ],
                  ),
                ),
                CustomTextField(
                  controller: _nameController,
                  text: 'Name',
                ),
                smallSizedBoxHeight,
                smallSizedBoxHeight,
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text('Change photo',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 15)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _selectPhoto(),
                ),
                smallSizedBoxHeight,
                smallSizedBoxHeight,
                TextAccentButton(
                  height: 50,
                  onTap: () {},
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 34, vertical: 1),
                    child: Text("Update information",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
              ],
            ),
          ),
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
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: IconButton(
                onPressed: () async {
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _image = File(image.path);
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
                child: _image == null
                    ? Text('No image selected')
                    : SizedBox(height: 50, child: Image.file(_image!)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
