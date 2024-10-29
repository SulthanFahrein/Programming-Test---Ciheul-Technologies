import 'package:e_library/config/app_asset.dart';
import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/config/database_helper.dart'; 
import 'package:e_library/model/user_model.dart'; 
import 'package:e_library/widget/custom_button.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword = TextEditingController();
  final TextEditingController controllerName = TextEditingController(); 
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false; 
  bool isConfirmPasswordVisible = false; 

  // Function to register a new user
  Future<void> register(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      String email = controllerEmail.text.trim();
      String password = controllerPassword.text.trim();
      String name = controllerName.text.trim();
      String confirmPassword = controllerConfirmPassword.text.trim();

      
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password and Confirm Password do not match')),
        );
        return;
      }

   
      User newUser = User(
        name: name,
        email: email,
        password: password,
        photoUrl: '', 
      );

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertUser(newUser);

     
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );


      Navigator.pushReplacementNamed(context, AppRoute.login);
    }
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])').hasMatch(value)) {
      return 'Password must include upper, lower case letters, \nand a number';
    }
    return null;
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
                      const SizedBox(height: 50),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Create a New Account',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: controllerEmail,
                        validator: (value) =>
                            value == '' ? "Email cannot be empty" : null,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
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
                        controller: controllerName,
                        validator: (value) =>
                            value == '' ? "Don't leave name empty" : null,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: 'Name',
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
                        obscureText: !isPasswordVisible, // Toggle visibility
                        validator: passwordValidator,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
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
                        controller: controllerConfirmPassword,
                        obscureText: !isConfirmPasswordVisible, // Toggle visibility
                        validator: (value) => value == ''
                            ? "Confirm Password cannot be empty"
                            : null,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          hintText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible = !isConfirmPasswordVisible;
                              });
                            },
                          ),
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
                        label: 'Register',
                        isExpand: true,
                        onTap: () => register(context),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, AppRoute.login);
                        },
                        child: Text(
                          'Already have an account? Login',
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
