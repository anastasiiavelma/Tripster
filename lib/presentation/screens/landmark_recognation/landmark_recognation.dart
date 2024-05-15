import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/data/cubits/landmark_cubit/landmark_cubit.dart';
import 'package:tripster/data/cubits/landmark_cubit/landmark_state.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';

class LandmarkRecognition extends StatelessWidget {
  const LandmarkRecognition({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LandmarkCubit(),
        child: LandmarkRecognitionView(),
      ),
    );
  }
}

class LandmarkRecognitionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LandmarkCubit, LandmarkState>(
      builder: (context, state) {
        if (state is LandmarkInitial) {
          return buildInitial(context);
        } else if (state is LandmarkLoading) {
          return buildLoading();
        } else if (state is LandmarkLoaded) {
          return buildSuccess(context, state.landmarkName, state.selectedImage);
        } else if (state is LandmarkError) {
          return buildError();
        } else {
          return Container();
        }
      },
    );
  }

  Widget buildInitial(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            'Landmark recognition',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextAccentButton(
                    onTap: () =>
                        context.read<LandmarkCubit>().getImageAndRecognize(
                              ImageSource.camera,
                            ),
                    child: Text('Open Camera',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  SizedBox(height: 20),
                  TextAccentButton(
                    onTap: () =>
                        context.read<LandmarkCubit>().getImageAndRecognize(
                              ImageSource.gallery,
                            ),
                    child: Text('Choose Image from Gallery',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildSuccess(BuildContext context, landmarkName, File? selectedImage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            'Detected Landmark: $landmarkName',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(
            height: 300,
            width: 300,
            child: selectedImage != null
                ? Image.file(selectedImage)
                : SizedBox.shrink(),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Text('Error occurred! Please, restart application.'),
    );
  }
}
