import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBarSelections extends StatelessWidget {
  final Widget? actions;
  final String name;
  const CustomAppBarSelections({
    super.key,
    this.actions,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              Navigator.pop(
                context,
                (route) => false,
              );
            },
            child: SvgPicture.asset(AppIcons.back),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            name,
            style: mainTheme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: actions == null
              ? InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text(
                      'Готово',
                      style: mainTheme.textTheme.labelMedium?.copyWith(
                        color: ColorsApp.colorWhite,
                      ),
                    ),
                  ),
                )
              : actions!,
        ),
      ],
    );
  }
}
