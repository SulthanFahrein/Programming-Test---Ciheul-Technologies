// lib/screens/splash_screen.dart
import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_library/config/app_asset.dart'; 

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _currentIndex = 0; 

  final List<String> splashImages = [
    AppAsset.splash1, 
    AppAsset.splash2, 
  ];

  @override
Widget build(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;

  return Scaffold(
    body: SafeArea(
      child: SingleChildScrollView( 
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight, 
                child: Column(
                  children: [
                    Expanded(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: constraints.maxHeight * 0.7,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: splashImages.map((image) {
                          int index = splashImages.indexOf(image);
                          return Builder(
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      image,
                                      width: screenWidth * 0.9,
                                      height: screenHeight * 0.35,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(height: screenHeight * 0.05),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        index == 0
                                            ? 'Now reading books will be easier'
                                            : 'Find Your Next Favorite Book',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.06,
                                            ),
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.03),
                                    Text(
                                      index == 0
                                          ? 'Discover new worlds, join a vibrant reading community. Start your reading adventure effortlessly with us.'
                                          : 'Choose from thousands of titles and authors, and dive into your reading journey now.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                    if (index == 1) SizedBox(height: screenHeight * 0.03),
                                    if (index == 1)
                                      ButtonCustom(
                                        label: 'Get Started',
                                        isExpand: true,
                                        onTap: () {
                                          Navigator.pushReplacementNamed(
                                              context, AppRoute.login);
                                        },
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(splashImages.length, (index) {
                        return Container(
                          width: screenWidth * 0.02,
                          height: screenWidth * 0.02,
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.01),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? AppColor.primary
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          );
        }),
      ),
    ),
  );
}

}
