import 'package:flutter/material.dart';
import 'package:e_library/model/book_model.dart';
import 'package:e_library/config/database_helper.dart';
import 'dart:io'; // Import this for handling file images

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];

  void _searchBooks(String query) async {
    final books = await DatabaseHelper().getBooks();
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = books.where((book) {
          return book.title.toLowerCase().contains(query.toLowerCase()) ||
                 book.year.toString().contains(query) ||
                 book.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
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
          "Search Page",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by title, year, or description',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _searchBooks,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _searchResults.isNotEmpty 
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final book = _searchResults[index];
                      return ListTile(
                        leading: book.coverUrl != null 
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                File(book.coverUrl!), 
                                fit: BoxFit.cover,
                                width: 50,
                                height: 50,
                              ),
                            )
                          : const Icon(Icons.book, size: 50),
                        title: Text(book.title),
                        subtitle: Text('Author: ${book.author} - Year: ${book.year}'),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'There is No Book',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
