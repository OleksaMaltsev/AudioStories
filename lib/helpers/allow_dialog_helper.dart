import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/providers/allow_to_delete_provider.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';

class AllowDialogHelper {
  AllowToDeleteProvider allowDeleteProvider = AllowToDeleteProvider();
  AllowDialogHelper();
  allowDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
          contentPadding: const EdgeInsets.fromLTRB(18, 24, 18, 22),
          title: const Text('Точно видалити аудіофайл?'),
          content: const Text(
              'Аудіофайл буде видалено з підбірки, але він залишається в "Аудіоказках"'),
          actionsPadding: const EdgeInsets.only(bottom: 24),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    allowDeleteProvider.setChoice(true);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsApp.colorPurple,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      'Так',
                      style: mainTheme.textTheme.labelMedium
                          ?.copyWith(color: ColorsApp.colorWhite),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: ColorsApp.colorWhite,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 1,
                        color: ColorsApp.colorPurple,
                      ),
                    ),
                    child: Text(
                      'Ні',
                      style: mainTheme.textTheme.labelMedium
                          ?.copyWith(color: ColorsApp.colorPurple),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
