import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import 'mail_content_maker.dart';

//import 'package:generation/FrontEnd/MenuScreen/Support/mail_content_maker.dart';

class SupportMenuMaker extends StatefulWidget {
  const SupportMenuMaker({Key? key}) : super(key: key);

  @override
  _SupportMenuMakerState createState() => _SupportMenuMakerState();
}

class _SupportMenuMakerState extends State<SupportMenuMaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(34, 48, 60, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 39, 52, 1),
        elevation: 10.0,
        shadowColor: Colors.white70,
        title: const Text(
          'Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            _getListOption(
                icon: const Icon(
                  Icons.report_gmailerrorred_outlined,
                  size: 30.0,
                  color: Colors.red,
                ),
                title: 'Report a Problem',
                extraText: 'About App Crashing, Bugs Report'),
            _getListOption(
              icon: const Icon(
                Icons.request_page_outlined,
                size: 30.0,
                color: Colors.green,
              ),
              title: 'Request a Feature',
              extraText: 'Any New Feature in your Mind',
            ),
            _getListOption(
              icon: const Icon(
                Icons.featured_play_list_outlined,
                size: 30.0,
                color: Colors.amber,
              ),
              title: 'Send Feedback',
              extraText: 'Your Experience of that App',
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListOption(
      {required Icon icon, required String title, required String extraText}) {
    return OpenContainer(
      closedColor: const Color.fromRGBO(34, 48, 60, 1),
      middleColor: const Color.fromRGBO(34, 48, 60, 1),
      openColor: const Color.fromRGBO(34, 48, 60, 1),
      closedElevation: 0.0,
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      openBuilder: (_, __) {
        log(title);
        if (title == 'Report a Problem') {
          return const SupportInputTaker(
            subject: 'Problem',
            appbarTitle: 'Describe Your Problem',
          );
        } else if (title == 'Request a Feature') {
          return const SupportInputTaker(
            subject: 'Feature',
            appbarTitle: 'Describe the Feature',
          );
        } else if (title == 'Send Feedback') {
          return const SupportInputTaker(
            subject: 'Feedback',
            appbarTitle: 'Write Your Feedback',
          );
        }
        return const Center();
      },
      closedBuilder: (_, __) {
        return Container(
          height: 80.0,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: icon,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 18.0,
                        ),
                      ),
                      Text(
                        extraText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
