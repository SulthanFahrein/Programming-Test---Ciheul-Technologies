import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/page/all_book_page.dart';
import 'package:e_library/page/edit_password_page.dart';
import 'package:e_library/page/edit_profile_page.dart';
import 'package:e_library/page/home_page.dart';
import 'package:e_library/page/katalog_page.dart';
import 'package:e_library/page/login_page.dart';
import 'package:e_library/page/register_page.dart';
import 'package:e_library/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: AppColor.backGroundScaffold,
          primaryColor: AppColor.primary,
          colorScheme: const ColorScheme.light(
            primary: AppColor.primary,
            secondary: AppColor.secondary,
          ),),
      routes: {
        '/': (context) =>  SplashPage(),
        AppRoute.login: (context) =>  LoginPage(),
        AppRoute.regis: (context) =>   RegisterPage(),
        AppRoute.home: (context) =>  HomePage(),
        AppRoute.katalog: (context) =>  const KatalogPage(),
        AppRoute.allBooksPage: (context) =>  const AllBooksPage(),
        AppRoute.editpassword: (context) =>  const EditPasswordPage(),
      },
    );
  }
}

