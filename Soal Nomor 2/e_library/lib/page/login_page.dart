import 'package:e_library/config/app_asset.dart';
import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/config/database_helper.dart'; 
import 'package:e_library/model/user_model.dart'; 
import 'package:e_library/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Login function
  Future<void> login(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      String email = controllerEmail.text.trim();
      String password = controllerPassword.text.trim();

      DatabaseHelper dbHelper = DatabaseHelper();
      List<User> users = await dbHelper.getUsers();

      final filteredUsers = users.where(
        (user) => user.email == email && user.password == password,
      );

      if (filteredUsers.isNotEmpty) {
        User user = filteredUsers.first;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', user.id!); 

        Navigator.pushReplacementNamed(context, AppRoute.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Form(
                key: formKey, 
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AppAsset.splash1,
                        width: 180,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(height: 80),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login \nTo Your Account',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controllerEmail,
                        validator: (value) => value == '' ? "Don't leave email empty" : null,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: AppColor.secondary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controllerPassword,
                        obscureText: true,
                        validator: (value) => value == '' ? "Don't leave password empty" : null,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: AppColor.secondary),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ButtonCustom(
                        label: 'Login',
                        isExpand: true,
                        onTap: () => login(context), 
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, AppRoute.regis);
                        },
                        child: Text(
                          'Create New Account',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
