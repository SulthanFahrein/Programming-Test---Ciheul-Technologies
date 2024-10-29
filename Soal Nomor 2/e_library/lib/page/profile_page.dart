import 'package:e_library/config/app_route.dart';
import 'package:e_library/config/database_helper.dart';
import 'package:e_library/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; 
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile; 
  String? _message; 

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');

    if (userId != null) {
      List<User> users = await dbHelper.getUsers();
      _user = users.firstWhere(
        (user) => user.id == userId,
        orElse: () => User(name: 'Unknown', email: 'unknown@example.com', password: ''),
      );

      if (_user!.photoUrl != null) {
        setState(() {
          _imageFile = File(_user!.photoUrl!); 
        });
      }

      setState(() {});
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    Navigator.pushReplacementNamed(context, AppRoute.login);
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); 
      });
      if (_user != null) {
        DatabaseHelper dbHelper = DatabaseHelper();
        await dbHelper.updateUserPhoto(_user!.id!, _imageFile!.path);

        setState(() {
          _user = _user!.copyWith(newPhotoUrl: _imageFile!.path);
        });

        setState(() {
          _message = 'Photo berhasil disimpan!';
        });
      }
    }
  }

  void _showEditProfileDialog() {

  }

  void _showChangePasswordDialog() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Center( 
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: [
                    Stack(
                      alignment: Alignment.center, 
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : (_user!.photoUrl != null && _user!.photoUrl!.isNotEmpty)
                                  ? FileImage(File(_user!.photoUrl!)) 
                                  : const AssetImage('assets/images/default_user.png') as ImageProvider, 
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white, 
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), 
                                  blurRadius: 4, 
                                  spreadRadius: 2, 
                                  offset: const Offset(0, 2), 
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_message != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          _message!,
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                    Text('Name: ${_user!.name}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 10),
                    Text('Email: ${_user!.email}', style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _showEditProfileDialog,
                      child: const Text('Edit Profile'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _showChangePasswordDialog,
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
