import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tripster/data/repository/gallery_repository.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_cubit.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_state.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/screens/gallery/detail_collection_widget.dart';
import 'package:tripster/presentation/screens/gallery/gallery_photo_screen.dart';
import 'package:tripster/presentation/screens/gallery/add_collection_dialog.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class ListOfCollectionPhotosWidget extends StatefulWidget {
  final String? token;

  final List<Vacation>? vacations;
  ListOfCollectionPhotosWidget({
    super.key,
    this.vacations,
    required this.token,
  });

  @override
  State<ListOfCollectionPhotosWidget> createState() =>
      _ListOfCollectionPhotosWidgetState();
}

class _ListOfCollectionPhotosWidgetState
    extends State<ListOfCollectionPhotosWidget> {
  bool sortByNewest = true;
  List<Vacation> sortedVacations = [];

  final GalleryRepository _galleryRepository = GalleryRepository();

  @override
  Widget build(BuildContext context) {
    final galleryCubit = GalleryCubit(_galleryRepository);
    print(widget.token);
    initializeDateFormatting();
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => galleryCubit..getUserGallery(widget.token),
          ),
          BlocProvider(
            create: (context) => VacationCubit(VacationRepository())
              ..fetchUserVacations(widget.token),
          ),
        ],
        child: BlocBuilder<VacationCubit, VacationState>(
          builder: (context, state) {
            if (state is VacationLoading) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: getCircularProgressIndicator(context),
                ),
              );
            } else if (state is VacationsLoaded) {
              final vacations = state.vacations;
              if (sortByNewest) {
                vacations.sort((a, b) => b.startDate.compareTo(a.startDate));
              } else {
                vacations.sort((a, b) => a.startDate.compareTo(b.startDate));
              }
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocaleKeys.my_collection.tr(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      )),
                  smallSizedBoxHeight,
                  CreateCollectionWidget(
                      widget: widget,
                      vacations: vacations,
                      galleryCubit: galleryCubit),
                  Expanded(
                    child: BlocBuilder<GalleryCubit, GalleryState>(
                      builder: (context, state) {
                        if (state is GalleryLoaded) {
                          final galleries = state.galleries;
                          final vacationMap =
                              Map<String, Vacation>.fromIterable(
                            vacations,
                            key: (vacation) => vacation.vacationId,
                            value: (vacation) => vacation,
                          );
                          return galleries.isEmpty
                              ? Center(
                                  child: Text(
                                      LocaleKeys.collection_photo_create_gallery
                                          .tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: galleries.length,
                                  itemBuilder: (context, index) {
                                    final gallery = galleries[index];

                                    final vacation =
                                        vacationMap[gallery.vacationId];
                                    if (vacation == null) {
                                      print(
                                          'Warning: No matching vacation found for gallery ${gallery.galleryId}');
                                      return Container();
                                    }
                                    return Padding(
                                      padding: smallPadding,
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PhotoGallery(
                                                      galleryCubit:
                                                          galleryCubit,
                                                      gallery: gallery,
                                                      token: widget.token,
                                                      vacation: vacation)),
                                        ),
                                        child: Slidable(
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            dismissible: DismissiblePane(
                                              onDismissed: () => deleteGallery(
                                                  context,
                                                  gallery,
                                                  vacation,
                                                  galleryCubit),
                                            ),
                                            children: [
                                              Builder(builder: (sContext) {
                                                return Expanded(
                                                    child: GestureDetector(
                                                  onTap: () => deleteGallery(
                                                      context,
                                                      gallery,
                                                      vacation,
                                                      galleryCubit),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        4.0, 4.0, 0.0, 1),
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20 * 4,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onError,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        child: Icon(
                                                          Icons.delete,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        )),
                                                  ),
                                                ));
                                              }),
                                              Builder(builder: (sContext) {
                                                return Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          4.0, 4.0, 0.0, 1),
                                                  child: GestureDetector(
                                                    onTap: () => {
                                                      updateGallery(
                                                          context,
                                                          gallery,
                                                          vacations,
                                                          vacation,
                                                          galleryCubit),
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 20 * 4,
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16)),
                                                        child: Icon(
                                                          Icons.edit,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                        )),
                                                  ),
                                                ));
                                              }),
                                            ],
                                          ),
                                          key: UniqueKey(),
                                          direction: Axis.horizontal,
                                          child: DetailCollectionWidget(
                                              vacation: vacation,
                                              yearFormat: yearFormat,
                                              dayMonthFormat: dayMonthFormat,
                                              gallery: gallery),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        } else if (state is GalleryError) {
                          return Center(
                              child: Text(LocaleKeys
                                  .collection_photo_galleries_empty
                                  .tr()));
                        } else {
                          return Center(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 90),
                                child: getCircularProgressIndicator2(context)),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            } else if (state is VacationError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No vacations found.'));
            }
          },
        ),
      ),
    );
  }

  deleteGallery(BuildContext context, Gallery gallery, Vacation vacation,
      GalleryCubit galleryCubit) {
    print(gallery.galleryId);
    galleryCubit.deleteGallery(
      galleryId: gallery.galleryId,
      vacationId: vacation.vacationId,
      token: widget.token,
    );
  }

  updateGallery(BuildContext context, Gallery gallery, List<Vacation> vacations,
      Vacation vacation, GalleryCubit galleryCubit) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      isScrollControlled: true,
      builder: (context) => CollectionDialog(
        token: widget.token,
        vacations: vacations,
        vacation: vacation,
        gallery: gallery,
        isEdit: true,
        galleryCubit: galleryCubit,
      ),
    );
  }
}

class CreateCollectionWidget extends StatelessWidget {
  const CreateCollectionWidget({
    super.key,
    required this.widget,
    required this.vacations,
    required this.galleryCubit,
  });

  final ListOfCollectionPhotosWidget widget;
  final List<Vacation> vacations;
  final GalleryCubit galleryCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextAccentButton(
        height: 40,
        color: Theme.of(context).colorScheme.background,
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.background,
            isScrollControlled: true,
            builder: (context) => CollectionDialog(
              token: widget.token,
              isEdit: false,
              vacations: vacations,
              galleryCubit: galleryCubit,
            ),
          );
        },
        child: Text(LocaleKeys.create_photo_collection.tr(),
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}
