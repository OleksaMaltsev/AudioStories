import 'dart:io';

import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/sellection_create_provider.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/choies_selection.dart';
import 'package:audio_stories/screens/selections/selection.dart';
import 'package:audio_stories/screens/selections/widgets/custom_app_bar_selections.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddSelectionScreen extends StatefulWidget {
  const AddSelectionScreen({super.key});
  static const String routeName = '/add-selections';

  @override
  State<AddSelectionScreen> createState() => _AddSelectionScreenState();
}

class _AddSelectionScreenState extends State<AddSelectionScreen> {
  TextEditingController selectionController = TextEditingController();
  final _validationKey = GlobalKey<FormState>();
  FocusNode trackFocus = FocusNode();
  TextEditingController descriptionSelectionController =
      TextEditingController();
  final _validationKey2 = GlobalKey<FormState>();
  FocusNode trackFocusDes = FocusNode();
  bool readyValues = false;

  String? imagePath;

  void saveSellection(bool ready) {
    if (descriptionSelectionController.text.isNotEmpty &&
        selectionController.text.isNotEmpty &&
        imagePath != null) {
      final String sellection = selectionController.text;

      final String description = descriptionSelectionController.text;

      Provider.of<SellesticonCreateProvider>(context, listen: false)
          .setValues(sellection, description, imagePath!);
      readyValues = true;
      if (ready) {
        final sellectionProvider =
            Provider.of<SellesticonCreateProvider>(context, listen: false);
        FirebaseRepository().saveSellection(
            sellectionProvider.sellectionModel.photo!,
            sellectionProvider.sellectionModel.name!,
            sellectionProvider.sellectionModel.description!,
            null);
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, SelectionsScreen.routeName, (route) => false);
        }
      } else {
        final snackBar = SnackBar(
          content: Text(
            'Додайте аудіозаписи',
            style: mainTheme.textTheme.labelLarge?.copyWith(
              color: ColorsApp.colorWhite,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: (ColorsApp.colorLightOpacityDark),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: Text(
          'Введіть назву добірки та опис, а також додайте фото',
          style: mainTheme.textTheme.labelLarge?.copyWith(
            color: ColorsApp.colorWhite,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: (ColorsApp.colorLightOpacityDark),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 10),
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                        (route) => false,
                      );
                    },
                    child: SvgPicture.asset(AppIcons.back),
                  ),
                  Text(
                    'Створення',
                    style: mainTheme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      saveSellection(true);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'Готово',
                        style: mainTheme.textTheme.labelMedium?.copyWith(
                          color: ColorsApp.colorWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Form(
                    key: _validationKey,
                    child: Column(
                      children: [
                        TextField(
                          cursorHeight: 25,
                          cursorColor: ColorsApp.colorLightOpacityDark,
                          controller: selectionController,
                          textAlign: TextAlign.left,
                          focusNode: trackFocus,
                          style: mainTheme.textTheme.labelLarge
                              ?.copyWith(color: ColorsApp.colorWhite),
                          decoration: InputDecoration(
                            hintText: 'Введіть назву добірки',
                            hintStyle: mainTheme.textTheme.labelLarge
                                ?.copyWith(color: ColorsApp.colorWhite),
                            focusColor: ColorsApp.colorWhite,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: ColorsApp.colorLightOpacityDark),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: ColorsApp.colorLightDark),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (await Permission.photosAddOnly.request().isGranted) {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.any);

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          print('path:${file.path}');
                          imagePath = await FirebaseRepository()
                              .saveImageInStorage(file);
                        }
                      }
                      setState(() {});
                    },
                    child: imagePath == null
                        ? Container(
                            margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            width: double.infinity,
                            height: 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromARGB(190, 255, 255, 255),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorsApp.colorLightOpacityDark,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    AppIcons.camera,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(imagePath!),
                            ),
                          ),
                  ),
                  Form(
                    key: _validationKey2,
                    child: Column(
                      children: [
                        TextField(
                          cursorHeight: 25,
                          cursorColor: ColorsApp.colorLightOpacityDark,
                          controller: descriptionSelectionController,
                          textAlign: TextAlign.left,
                          focusNode: trackFocusDes,
                          decoration: InputDecoration(
                            hintText: 'Введіть опис...',
                            hintStyle: mainTheme.textTheme.labelLarge,
                            focusColor: ColorsApp.colorLightDark,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: ColorsApp.colorLightOpacityDark),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: ColorsApp.colorLightDark),
                            ),
                            counter: InkWell(
                              onTap: () {
                                saveSellection(false);
                              },
                              child: Text(
                                'Зберегти',
                                style:
                                    mainTheme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                  InkWell(
                    onTap: () {
                      if (readyValues) {
                        Navigator.pushNamed(
                          context,
                          ChoiceSelectionScreen.routeName,
                        );
                      } else {
                        final snackBar = SnackBar(
                          content: Text(
                            'Нажміть "Зберегти"',
                            style: mainTheme.textTheme.labelLarge?.copyWith(
                              color: ColorsApp.colorWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: (ColorsApp.colorLightOpacityDark),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Додати аудіозапис',
                        style: mainTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
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
