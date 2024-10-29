import 'dart:io'; // Importing dart:io to use File
import 'package:flutter/material.dart';
import 'package:e_library/model/book_model.dart';
import 'package:e_library/config/database_helper.dart';
import 'package:e_library/widget/favorite_icon.dart';
import 'package:e_library/page/book_detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Book>> _favoriteBooksFuture;

  @override
  void initState() {
    super.initState();
    _favoriteBooksFuture = _fetchFavoriteBooks(); 
  }

  Future<List<Book>> _fetchFavoriteBooks() async {
    final allBooks = await DatabaseHelper().getBooks();
    return allBooks.where((book) => book.isFavorite).toList();
  }

  Future<void> _refreshFavorites() async {
    setState(() {
      _favoriteBooksFuture = _fetchFavoriteBooks(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _favoriteBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite books found.'));
          }

          final favoriteBooks = snapshot.data!;

          return RefreshIndicator(
            onRefresh: _refreshFavorites, 
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(), 
              shrinkWrap: true,
              itemCount: favoriteBooks.length < 3 ? favoriteBooks.length : 3,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
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
                            builder: (context) => BookDetailPage(book: book),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(book.author), 
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
          );
        },
      ),
    );
  }
}
