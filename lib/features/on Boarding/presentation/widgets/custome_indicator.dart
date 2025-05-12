
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/on%20Boarding/presentation/widgets/on_Boarding_body.dart';


/////////////
class CustomeIndicator extends StatelessWidget {
 const CustomeIndicator({super.key,required this.dotIndex});
 final double? dotIndex;
/////////////
  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
            decorator: DotsDecorator(
            color: Colors.transparent,
            activeColor: kMainColor,
             activeSize: const Size(18.0, 9.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0),),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side:  const BorderSide(color:kMainColor),
       )),
      dotsCount: 3,
      position : OnboardingviewBody.pageNum ///////فيه مشلكة هناا//////
       );
  }
}
