import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CustomAppBar extends StatefulWidget {
  final BuildContext contextScreen;
  final Widget? leading;
  final String? title;
  final String? subTitle;
  final Widget? actions;

  const CustomAppBar({
    required this.contextScreen,
    required this.leading,
    required this.title,
    required this.subTitle,
    required this.actions,
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsApp.colorPurple,
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            // child: IconButton(
            //   onPressed: () => Scaffold.of(context).openEndDrawer(),
            //   icon: const Icon(
            //     Icons.menu_rounded,
            //     color: ColorsApp.colorLightRed,
            //     size: 35,
            //   ),
            // )

            child: widget.leading == null
                ? IconButton(
                    onPressed: () =>
                        Scaffold.of(widget.contextScreen).openDrawer(),
                    icon: const Icon(
                      Icons.menu_rounded,
                      color: ColorsApp.colorWhite,
                      size: 35,
                    ),
                  )
                : widget.leading!,
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                AutoSizeText(
                  widget.title != null ? widget.title! : '',
                  style: mainTheme.textTheme.titleMedium,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                AutoSizeText(
                  widget.subTitle != null ? widget.subTitle! : '',
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
            child: widget.actions == null
                ? IconButton(
                    icon: SvgPicture.asset(AppIcons.dots),
                    onPressed: () {},
                  )
                : widget.actions!,
          ),
        ],
      ),
    );
  }
}
