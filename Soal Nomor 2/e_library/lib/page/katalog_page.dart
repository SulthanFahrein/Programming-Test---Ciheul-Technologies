import 'dart:io';
import 'package:e_library/config/app_color.dart';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/config/database_helper.dart';
import 'package:e_library/model/book_model.dart';
import 'package:e_library/page/all_book_page.dart';
import 'package:e_library/widget/custom_button.dart';
import 'package:e_library/widget/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'book_detail_page.dart'; 

class KatalogPage extends StatefulWidget {
  const KatalogPage({super.key});

  @override
  State<KatalogPage> createState() => _KatalogPageState();
}

class _KatalogPageState extends State<KatalogPage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = DatabaseHelper().getBooks(); 
  }

  Future<void> _refreshBooks() async {
    setState(() {
      _booksFuture = DatabaseHelper().getBooks(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Katalogs",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined, size: 30),
              onPressed: () {
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBooks,
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No books available.'));
            }

            final books = snapshot.data!;
            final latestBook =
                books.isNotEmpty ? books.last : null;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (latestBook != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Book details on the left
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Latest Book !!!!",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    latestBook.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Author: ${latestBook.author}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Year: ${latestBook.year}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      ButtonCustom(
                                        label: 'Get Started',
                                        hasShadow: false,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetailPage(
                                                      book: latestBook),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            latestBook.coverUrl != null
                                ? Image.file(
                                    File(latestBook.coverUrl!),
                                    width: 80,
                                    height: 120,
                                    fit: BoxFit.cover,
                                  )
                                : const Placeholder(
                                    fallbackHeight: 120,
                                    fallbackWidth: 80,
                                  ),
                          ],
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Books Available",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AllBooksPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Show All",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: books.length < 3 ? books.length : 3,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BookDetailPage(book: book),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  book.coverUrl != null
                                      ? Image.file(
                                          File(book.coverUrl!),
                                          width: 80,
                                          height: 120,
                                          fit: BoxFit.cover,
                                        )
                                      : const Placeholder(
                                          fallbackHeight: 120,
                                          fallbackWidth: 80,
                                        ),
                                  const SizedBox(width: 10),
                                  // Book details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FavoriteIcon(book: book),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
