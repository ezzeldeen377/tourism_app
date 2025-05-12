import 'package:flutter/material.dart';
import 'package:new_flutter/features/on%20Boarding/presentation/widgets/page_view_item.dart';

class Customepageview extends StatelessWidget {
  final PageController pageController;
  const Customepageview({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
         children: const [ 
          PageViewItems (
          image:'images/صور-لمصر-2.jpg',
          title: 'Uncover the Magic of Egypt',
          subTitle: 'Ancient wonders, timeless experiences', 
        ),
        PageViewItems (
          image:'images/egypt-1.jpg',
          title: 'Plan Less, Explore More',
          subTitle: 'Everything you need in one travel companion',  
        ),
        PageViewItems (
          image:'images/أهرامات الجيزة.jpg',
          title: 'Welcome to Egypt',
          subTitle: '',  
        ),
         ],
    );
  }
}
