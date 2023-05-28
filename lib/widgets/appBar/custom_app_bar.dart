import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomAppBar extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String subTitle;
  final Widget? actions;
  const CustomAppBar({
    required this.leading,
    required this.title,
    required this.subTitle,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Builder(
            builder: (context) => leading == null
                ? IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: ColorsApp.colorWhite,
                      size: 35,
                    ),
                  )
                : leading!,
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              AutoSizeText(
                title,
                style: mainTheme.textTheme.titleMedium,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              AutoSizeText(
                subTitle,
                style: mainTheme.textTheme.labelMedium?.copyWith(
                  color: ColorsApp.colorWhite,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: actions == null
              ? IconButton(
                  icon: SvgPicture.asset(AppIcons.dots),
                  onPressed: () {},
                )
              : actions!,
        ),
      ],
    );
  }
}
