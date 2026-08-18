
import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_page_route/app_page_route.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';

class IntroSliderPage extends StatefulWidget {
  const IntroSliderPage({super.key});

  @override
  State<IntroSliderPage> createState() => _IntroSliderPageState();
}

class _IntroSliderPageState extends State<IntroSliderPage> {
  late PageController _pageController;
  int _currentPage = 0;

  // Sample slides data - customize with your content
  final List<SlideItem> slides = [
    SlideItem(
      title: 'Smart Driving Smarter Rewards',
      description: 'Connect your vehicle. drive safely and earn MGC tokens.',
      image: 'assets/img/onboardpage_01.png',
      backgroundColor: const Color(0xFF2C3E50),
    ),
    SlideItem(
      title: 'Legal Protection You Can Trust',
      description: 'Verified evidence for accidents and unfair challans.',
      image: 'assets/img/onboardpage_02.png',
      backgroundColor: const Color(0xFF34495E),
    ),
     SlideItem(
      title: 'All Your Vehicle Docs in One Place',
      description: 'Store, manage and get alerts for all important documents.',
      image: 'assets/img/onboardpage_03.png',
      backgroundColor: const Color(0xFF34495E),
    ),
    
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // Navigator.pushReplacementNamed(context, AppPageRoute.firstAuth);
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Stack(
        children: [
          // PageView for sliding
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() => _currentPage = page);
            },
            itemCount: slides.length,
            itemBuilder: (context, index) {
              return SlideWidget(slide: slides[index]);
            },
          ),
          // Bottom navigation and indicators
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicator dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? AppColors.primaryHudCyan
                            : AppColors.surface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Navigation buttons
                SizedBox(
                  height:50,
                  width: double.infinity,
                  // color: Colors.red,
                  child: ElevatedButton(
                          onPressed:
                              _currentPage < slides.length - 1
                                  ? _goToNextPage
                                  : () {
                                 Navigator.pushReplacementNamed(context, AppPageRoute.loginPage);
                                    
                                      // print("Login Page");
                                    
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryHudCyan,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            _currentPage < slides.length - 1 ? 'Next' : 'Finish',
                            style: const TextStyle(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       // ElevatedButton(
                //       //   onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                //       //   style: ElevatedButton.styleFrom(
                //       //     backgroundColor: Colors.white.withOpacity(0.3),
                //       //     disabledBackgroundColor:
                //       //         Colors.white.withOpacity(0.1),
                //       //     shape: RoundedRectangleBorder(
                //       //       borderRadius: BorderRadius.circular(8),
                //       //     ),
                //       //     padding: const EdgeInsets.symmetric(
                //       //       horizontal: 30,
                //       //       vertical: 12,
                //       //     ),
                //       //   ),
                //       //   child: const Text(
                //       //     'Previous',
                //       //     style: TextStyle(
                //       //       color: Colors.white,
                //       //       fontWeight: FontWeight.w600,
                //       //     ),
                //       //   ),
                //       // ),
                      
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SlideWidget extends StatelessWidget {
  final SlideItem slide;

  const SlideWidget({
    super.key,
    required this.slide,
  });

  @override
  Widget build(BuildContext context) {
    return 
      
     Stack(
        
        children: [
          // Image
          Container(
            // height: double.infinity,
            // width: double.infinity,
            // height: 300,
            width: double.infinity,
            // color: Colors.red,
            // margin: const EdgeInsets.all(20),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(12),
            //   image: DecorationImage(
            //     image: AssetImage(slide.image),
            //     fit: BoxFit.cover,
            //   ),
            // ),
            child: Image.asset(
              slide.image,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
              top: 55,
            // bottom: 0,
            left: 30,
            right: 30,
            child: Container(
              padding: const EdgeInsets.all(20),
              // color: slide.backgroundColor.withOpacity(0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      );
    
  }
}

class SlideItem {
  final String title;
  final String description;
  final String image;
  final Color backgroundColor;

  SlideItem({
    required this.title,
    required this.description,
    required this.image,
    required this.backgroundColor,
  });
}
