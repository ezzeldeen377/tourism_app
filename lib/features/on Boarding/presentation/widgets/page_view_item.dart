import 'package:flutter/material.dart';
import 'package:new_flutter/core/utils/size_config.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/core/widgets/space_widget.dart';


class PageViewItems extends StatelessWidget {
  const PageViewItems( {super.key, this.title, this.subTitle, this.image});
  final String? title;
  final String? subTitle;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const Verticalspace(20),
        ClipRRect(borderRadius: BorderRadius.circular(40),
        child: Image.asset(fit:BoxFit.cover,image!,
        height: Sizeconfig.defaultSize!*30,
        width: Sizeconfig.defaultSize!*40,),
         ),

          const Verticalspace(2.5),
          Text(title!,
         style:const TextStyle(fontSize: 30,
         fontWeight: FontWeight.bold,
         color: kMainColor1),
         textAlign: TextAlign.left,),
         
       const Verticalspace(2.5),
         Text(subTitle!,
         style:const TextStyle(fontSize: 25,
         fontWeight: FontWeight.bold,
         color: kMainColor1))
         ]
   ); 
  }
}
