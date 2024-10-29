import 'dart:io';
import 'package:e_library/config/database_helper.dart';
import 'package:e_library/model/book_model.dart';
import 'package:flutter/material.dart';
import 'book_detail_page.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  late Future<List<Book>> _allBooksFuture;

  @override
  void initState() {
    super.initState();
    _allBooksFuture = DatabaseHelper().getBooks(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "All Books",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        
      ),
      body: FutureBuilder<List<Book>>(
        future: _allBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available.'));
          }

          final books = snapshot.data!;

          return ListView.builder(
            itemCount: books.length,
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
                          builder: (context) => BookDetailPage(book: book,),
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
                                const SizedBox(height: 5),
                                Text(
                                  'Author: ${book.author}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Year: ${book.year}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  book.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
