import 'dart:io';
import 'dart:ui';

import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/repository/firebase_repository.dart';
import 'package:audio_stories/screens/selections/widgets/big_stories_box_selections.dart';
import 'package:audio_stories/screens/selections/widgets/custom_app_bar_selections.dart';
import 'package:audio_stories/screens/selections/widgets/dropdown_button_one_selection.dart';
import 'package:audio_stories/screens/selections/widgets/one_track.dart';
import 'package:audio_stories/screens/selections/widgets/track_container_widget.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_green_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class EditSelectionScreen extends StatefulWidget {
  const EditSelectionScreen({super.key});
  static const String routeName = '/edit-selections';

  @override
  State<EditSelectionScreen> createState() => _EditSelectionScreenState();
}

class _EditSelectionScreenState extends State<EditSelectionScreen> {
  String name = '';

  String? imagePath;
  String description = '';

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  void descriptionInit(String value) {
    _descriptionController.value = TextEditingValue(
      text: value,
      selection: TextSelection.fromPosition(
        TextPosition(offset: value.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic> ??
            {};
    description = arg['description'];
    descriptionInit(description);
    imagePath ??= arg['photo'];

    return Scaffold(
      body: CustomPaint(
        painter: GreenPainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 50, 15, 0),
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBarSelections(
                  name: '',
                  actions: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Зберегти',
                      style: mainTheme.textTheme.labelSmall?.copyWith(
                        fontSize: 12,
                        color: ColorsApp.colorWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  // DropdownButtonOneSellection(
                  //   fileDocId: '',
                  //   data: arg,
                  // ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: _nameController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: description,
                          border: InputBorder.none,
                        ),
                        style: mainTheme.textTheme.labelSmall,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        arg['name'],
                        style: mainTheme.textTheme.labelLarge?.copyWith(
                          color: ColorsApp.colorWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (await Permission.photosAddOnly
                            .request()
                            .isGranted) {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.any);

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            imagePath = await FirebaseRepository()
                                .saveImageInStorage(file);
                          }
                        }

                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: double.infinity,
                        //height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(190, 255, 255, 255),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(imagePath!),
                            ),
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 80),
                                width: 80,
                                height: 80,
                                //padding: const EdgeInsets.only(top: 50),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorsApp.colorWhite,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: SvgPicture.asset(
                                    AppIcons.camera,
                                    color: ColorsApp.colorWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: _descriptionController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          hintText: description,
                          border: InputBorder.none,
                        ),
                        style: mainTheme.textTheme.labelSmall,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => print(_descriptionController.text),
                      child: const Text('ff'),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.312,
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseRepository()
                            .dbConnectSellection
                            .doc(arg['docId'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data?.data()?['tracks'] != null) {
                            final List list = snapshot.data?.data()?['tracks'];

                            return ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final file = list[index];
                                return Opacity(
                                  opacity: 0.5,
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TrackGreenContainer(
                                      data: file,
                                      fileDocId: arg['docId'],
                                      choiceAction: null,
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          if (snapshot.hasError) {
                            return const Text("Something went wrong");
                          }

                          return const CircularProgressIndicator.adaptive();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
