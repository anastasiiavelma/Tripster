import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripster/presentation/cubits/landmark_cubit/landmark_cubit.dart';
import 'package:tripster/presentation/cubits/landmark_cubit/landmark_state.dart';
import 'package:tripster/data/repository/landmark_repository.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/widgets/custom_appbar.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class LandmarkRecognition extends StatelessWidget {
  final LandmarkRepository _authRepository = LandmarkRepository();

  LandmarkRecognition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LandmarkCubit(_authRepository),
        child: LandmarkRecognitionView(),
      ),
    );
  }
}

class LandmarkRecognitionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LandmarkCubit, LandmarkState>(
        builder: (context, state) {
          if (state is LandmarkInitial) {
            return buildInitial(context, state);
          } else if (state is LandmarkLoading) {
            return buildLoading(context);
          } else if (state is LandmarkLoaded) {
            return buildSuccess(
                context, state.landmarkName, state.selectedImage);
          } else if (state is LandmarkError) {
            return buildError(state.message, context);
          } else {
            return Text('Something went wrong!');
          }
        },
      ),
    );
  }

  Widget buildInitial(BuildContext context, LandmarkState state) {
    return CustomScrollView(
      slivers: <Widget>[
        CustomAppBarWidget(),
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
                    child: Text(LocaleKeys.open_camera.tr(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  SizedBox(height: 20),
                  TextAccentButton(
                    onTap: () =>
                        context.read<LandmarkCubit>().getImageAndRecognize(
                              ImageSource.gallery,
                            ),
                    child: Text(LocaleKeys.choose_image_from_gallery.tr(),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  SizedBox(height: 20),
                  state is LandmarkLoaded
                      ? buildSuccess(
                          context, state.landmarkName, state.selectedImage)
                      : SizedBox(
                          height: 350,
                          child: Image.asset(
                            'assets/images/upload.gif',
                            width: double.infinity,
                            height: 155,
                            fit: BoxFit.cover,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoading(BuildContext context) {
    return Center(
      child: getCircularProgressIndicator2(context),
    );
  }

  Widget buildSuccess(
      BuildContext context, String landmarkName, File? selectedImage) {
    return CustomScrollView(slivers: <Widget>[
      CustomAppBarWidget(),
      SliverToBoxAdapter(
          child: DetectedImage(
        landmarkName: landmarkName,
        selectedImage: selectedImage,
      )),
    ]);
  }

  Widget buildError(String message, BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}

class DetectedImage extends StatelessWidget {
  final String landmarkName;
  final File? selectedImage;
  const DetectedImage({
    super.key,
    required this.landmarkName,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(19.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 40),
          Text(
            '${LocaleKeys.detected_landmark.tr()}: $landmarkName',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 20),
          if (selectedImage != null)
            Container(
              color: Theme.of(context).colorScheme.onBackground,
              height: 300,
              width: 300,
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.11,
      floating: true,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      surfaceTintColor: Theme.of(context).colorScheme.background,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.only(
            left: 0,
            top: constraints.maxHeight - 70,
            bottom: 20,
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.landmark_recog.tr(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold),
              ),
              smallSizedBoxHeight,
            ],
          ),
          background: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0),
            ),
            child: Container(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        );
      }),
    );
  }
}
