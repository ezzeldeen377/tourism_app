// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/core/widgets/custom_buttons.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login.dart';
import 'package:new_flutter/features/Auth/presentation/pages/login/widgets/login_view.dart';
import 'package:new_flutter/features/on%20Boarding/presentation/widgets/custome_indicator.dart';
import 'package:new_flutter/features/on%20Boarding/presentation/widgets/custome_page_view.dart';

import '../../../../core/utils/size_config.dart';

class OnboardingviewBody extends StatefulWidget {
  const OnboardingviewBody({super.key});
  static int pageNum = 0;

  @override
  _OnboardingviewBodyState createState() => _OnboardingviewBodyState();
}

///////////////////////
class _OnboardingviewBodyState extends State<OnboardingviewBody> {
  static PageController pageController = PageController();

  @override
  void initState() {
    pageController = PageController(initialPage: OnboardingviewBody.pageNum)
      ..addListener(() {
        setState(() {
          // Update pageNum when sliding
          if (pageController.hasClients) {
            OnboardingviewBody.pageNum = pageController.page?.round() ?? 0;
          }
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Customepageview(
          pageController: pageController,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: Sizeconfig.defaultSize! * 20,
          child: CustomeIndicator(
            dotIndex: pageController.hasClients
                ? pageController.page?.toDouble() ?? 0
                : 0,
          ),
        ),
        Visibility(
          visible: OnboardingviewBody.pageNum == 2 ? false : true,
          child: Positioned(
            top: Sizeconfig.defaultSize! * 10,
            right: 32,
            child: InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Login()),
                    (Route<dynamic> route) => false);
              },
              child: const Text('Skip',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kMainColor1),
                  textAlign: TextAlign.left),
            ),
          ),
        ),
        Positioned(
            left: Sizeconfig.defaultSize! * 10,
            right: Sizeconfig.defaultSize! * 10,
            bottom: Sizeconfig.defaultSize! * 10,
            child: CustomGeneralButton(
              onTap: () {
                if (OnboardingviewBody.pageNum < 2) {
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                  OnboardingviewBody.pageNum++;
                } else {
                  // Replace current screen with LoginView and prevent going back
                  Get.offAll(() => const LoginView(),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 500));
                }
              },
              text: OnboardingviewBody.pageNum == 2 ? 'Get started' : 'Next',
              color: kMainColor,
            ))
      ],
    );
  }
}
