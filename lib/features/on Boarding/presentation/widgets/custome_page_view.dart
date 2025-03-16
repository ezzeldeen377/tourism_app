import 'package:flutter/material.dart';
import 'package:new_flutter/features/on%20Boarding/presentation/widgets/page_view_item.dart';

class Customepageview extends StatelessWidget {
  const Customepageview({super.key,@required this.pageController,});
  final PageController? pageController;
   @override
  Widget build(BuildContext context) {
    return  PageView(
      controller: pageController,
         children: const [ 
          PageViewItems (
          image:'images/صور-لمصر-2.jpg',
          title: 'Find the best',
          subTitle: 'Discovering Egyptian antiquities',  
        ),
        PageViewItems (
          image:'images/Time.jpeg',
          title: 'Easy to save your Time',
          subTitle: 'And Enjoy with it',  
        ),
        PageViewItems (
          image:'images/أهرامات الجيزة.jpg',
          title: 'Welcome in Egypt',
          subTitle: '',  
        ),
         ],
    );
  }
}
