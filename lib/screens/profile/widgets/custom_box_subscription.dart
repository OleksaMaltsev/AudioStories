import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_choose_provider.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBoxSubscription extends StatefulWidget {
  final String price;
  final String time;
  final ChangeChooseProvider choose;
  final int index;
  const CustomBoxSubscription({
    super.key,
    required this.price,
    required this.time,
    required this.choose,
    required this.index,
  });

  @override
  State<CustomBoxSubscription> createState() => _CustomBoxSubscriptionState();
}

class _CustomBoxSubscriptionState extends State<CustomBoxSubscription> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: ColorsApp.colorWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(25, 0, 0, 0),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text(
            widget.price,
            style: mainTheme.textTheme.labelLarge?.copyWith(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.time,
            style: mainTheme.textTheme.labelMedium,
          ),
          const SizedBox(height: 25),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                width: 2,
              ),
            ),
            child: InkWell(
              onTap: () {
                widget.choose.changeChoose(widget.index);
                setState(() {});
              },
              child: widget.choose.chooses[widget.index]
                  ? SvgPicture.asset(AppIcons.tickSquare)
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }
}
