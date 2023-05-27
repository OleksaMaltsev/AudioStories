import 'package:audio_stories/constants/colors.dart';
import 'package:audio_stories/constants/icons.dart';
import 'package:audio_stories/providers/change_choose_provider.dart';
import 'package:audio_stories/screens/profile/profile.dart';
import 'package:audio_stories/thems/main_thame.dart';
import 'package:audio_stories/widgets/background/background_purple_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});
  static const String routeName = '/subscription';

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: PurplePainter(),
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
          child: Column(
            children: [
              const CustomAppBar(
                title: 'Підписка',
                subTitle: 'Розширюй можливості',
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorsApp.colorWhite,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(25, 0, 0, 0),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 20,
                      ),
                      child: Text(
                        'Обери підписку',
                        style: mainTheme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Expanded(
                          child: CustomBoxSubscription(
                            price: '300 грн',
                            time: 'в місяць',
                            choose: Provider.of<ChangeChooseProvider>(context),
                            index: 0,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomBoxSubscription(
                            price: '1800 грн',
                            time: 'на рік',
                            choose: Provider.of<ChangeChooseProvider>(context),
                            index: 1,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
