// lib/katalog_page.dart
import 'dart:io';
import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/config/database_helper.dart';
import 'package:e_library/model/book_model.dart';
import 'package:e_library/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddKatalogPage extends StatefulWidget {
  const AddKatalogPage({super.key});

  @override
  State<AddKatalogPage> createState() => _AddKatalogPageState();
}

class _AddKatalogPageState extends State<AddKatalogPage> {
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerAuthor = TextEditingController();
  int? selectedYear; 
  File? coverImage;

  final ImagePicker _picker = ImagePicker();
  final List<int> years = List.generate(100, (index) => 2023 - index); 

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        coverImage = File(pickedFile.path);
      });
    }
  }

  void _addBook() async {
    if (controllerTitle.text.isNotEmpty &&
        controllerDescription.text.isNotEmpty &&
        controllerAuthor.text.isNotEmpty &&
        selectedYear != null) {
      final book = Book(
        title: controllerTitle.text,
        description: controllerDescription.text,
        author: controllerAuthor.text,
        year: selectedYear!, 
        coverUrl: coverImage?.path,
      );

      await DatabaseHelper().insertBook(book);

      // Clear the fields
      controllerTitle.clear();
      controllerDescription.clear();
      controllerAuthor.clear();
      setState(() {
        coverImage = null; 
        selectedYear = null; 
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Add Katalog",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColor.secondary),
                  borderRadius: BorderRadius.circular(10),
                  image: coverImage != null
                      ? DecorationImage(
                          image: FileImage(coverImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: coverImage == null
                    ? const Center(child: Text('Tap to select cover image'))
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controllerTitle,
              validator: (value) =>
                  value == '' ? "Don't leave title empty" : null,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Title',
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
            const SizedBox(height: 16),
           
            TextFormField(
              controller: controllerDescription,
              validator: (value) =>
                  value == '' ? "Don't leave description empty" : null,
              maxLines: 5, // Allows for multiline input
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Description',
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
            const SizedBox(height: 16),
            TextFormField(
              controller: controllerAuthor,
              validator: (value) =>
                  value == '' ? "Don't leave author empty" : null,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Author',
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
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: selectedYear,
              items: years.map((int year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedYear = newValue;
                });
              },
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintText: 'Year of Publication',
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
            const SizedBox(height: 50),
            ButtonCustom(
              label: 'Add Book',
              isExpand: true,
              onTap: _addBook,
            ),
          ],
        ),
      ),
    );
  }
}
