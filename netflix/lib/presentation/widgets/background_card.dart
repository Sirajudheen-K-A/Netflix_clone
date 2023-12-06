import 'package:flutter/material.dart';

import '../../core/colors/colors.dart';
import 'custom_button_widget.dart';

class BackgroundCard extends StatelessWidget {
  const BackgroundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 60),
          width: double.infinity,
          height: 616,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/h92U7zCCpF6gcjoOwhDySpSlhX8.jpg"),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CustomButtonWidget(
                  icon: Icons.add,
                  title: "My List",
                ),
                _PlayButton(),
                const CustomButtonWidget(
                    icon: Icons.info_outline, title: "Info")
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextButton _PlayButton() {
    return TextButton.icon(
      onPressed: () {},
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(kWhiteColor),
      ),
      icon: const Icon(
        Icons.play_arrow,
        size: 30,
        color: kBlackColor,
      ),
      label: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(
          "Play",
          style: TextStyle(fontSize: 20, color: kBlackColor),
        ),
      ),
    );
  }
}
