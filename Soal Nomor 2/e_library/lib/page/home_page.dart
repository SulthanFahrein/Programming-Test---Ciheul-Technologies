import 'package:e_library/config/app_asset.dart';
import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/c_home.dart';
import 'package:e_library/page/add_katalog_page.dart';
import 'package:e_library/page/favorite_page.dart';
import 'package:e_library/page/katalog_page.dart';
import 'package:e_library/page/profile_page.dart';
import 'package:e_library/page/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final cHome = Get.put(CHome());
  final List<Map> listNav = [
    {'icon': AppAsset.iconKatalog, 'label': 'Katalog'},
    {'icon': AppAsset.iconSearch, 'label': 'Search'},
    {'icon': AppAsset.iconAdd, 'label': 'Add Katalog'},
    {'icon': AppAsset.iconFavorite, 'label': 'Favorite'},
    {'icon': AppAsset.iconProfile, 'label': 'Profile'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (cHome.indexPage == 0) {
          return const KatalogPage();
        }
        if (cHome.indexPage == 1) {
          return  const SearchPage();
        }
        if (cHome.indexPage == 2) {
          return  const AddKatalogPage();
        }
        if (cHome.indexPage == 3) {
          return  FavoritePage();
        }
        return ProfilePage();
      }),
      bottomNavigationBar: Obx(() {
        return Material(
          elevation: 5,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: BottomNavigationBar(
                currentIndex: cHome.indexPage,
                onTap: (value) => cHome.indexPage = value,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.black,
                selectedIconTheme: const IconThemeData(
                  color: AppColor.primary,
                ),
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.bold),
                selectedFontSize: 10,
                items: listNav.map((e) {
                  return BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage(e['icon'])),
                    label: e['label'],
                  );
                }).toList()),
          ),
        );
      }),
    );
  }
}
