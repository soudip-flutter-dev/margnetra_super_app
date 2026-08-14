
import 'package:flutter/material.dart';
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
      title: 'Green Yatra, Har Bharatiye  ke Liye',
      description: 'Join the movement towards a greener, sustainable future!',
      image: 'assets/img/onboardpage_01.png',
      backgroundColor: const Color(0xFF2C3E50),
    ),
    SlideItem(
      title: 'Flexible Options, Tailored for You',
      description: 'Book electric vehicles effortlessly for daily commutes and rentals',
      image: 'assets/img/onboardpage_02.png',
      backgroundColor: const Color(0xFF34495E),
    ),
     SlideItem(
      title: 'Flexible Options, Tailored for You',
      description: 'Book electric vehicles effortlessly for daily commutes and rentals',
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
      // appBar: CustomAppBar(),
      // backgroundColor: AppColors.primary,
      // appBar: CustomAppBar(
      //   title: "E-Yatri",
      //   preferredHeight: 120,
      //   titleStyle: TextStyle(
      //     color: Colors.white,
      //     fontSize: 32,
      //     fontWeight: FontWeight.bold,
      //   ),
      //   actions: [
      //     SizedBox(
      //       width: 50,
      //       child: InkWell(
      //         onTap: () {
      //           // Navigator.pop(context);
      //           Navigator.pushReplacementNamed(context, AppPageRoute.firstAuth);
      //         },
      //         child: Text(
      //           'Skip',
      //           style: TextStyle(
      //             color: Colors.white.withOpacity(0.7),
      //             fontSize: 16,
      //             fontWeight: FontWeight.w500,
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      //   // centerTitle: true,
      // ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryText,
        
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
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
                left: 0,
                right: 0,
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
                                ? AppColors.accentSaffron
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
                                    //  Navigator.pushReplacementNamed(context, AppPageRoute.loginPage);
                                        
                                          // print("Login Page");
                                        
                                      },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentSaffron,
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
                                  color: Colors.white,
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
        ),
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
    return Container(
      // color: slide.backgroundColor,
      // color: Colors.white,
      color: Colors.amber,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 300,
            margin: const EdgeInsets.all(20),
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
          const SizedBox(height: 20),
          // Title
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.deepBackground,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              slide.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.surface,
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
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
