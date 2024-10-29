import 'dart:io';
import 'package:e_library/config/app_route.dart';
import 'package:e_library/widget/custom_button.dart';
import 'package:e_library/widget/favorite_icon.dart';
import 'package:flutter/material.dart';
import 'package:e_library/model/book_model.dart';
import 'package:e_library/config/database_helper.dart';
import 'book_edit_page.dart'; // Import the edit page

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite =
        widget.book.isFavorite; 
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
      _updateFavoriteStatus();
    });
  }

  Future<void> _updateFavoriteStatus() async {
    widget.book.isFavorite = _isFavorite;
    await DatabaseHelper().updateBook(widget.book); 
  }

  void _editBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookEditPage(
          book: widget.book,
          onBookUpdated: (updatedBook) {
            setState(() {
              widget.book.title = updatedBook.title;
              widget.book.author = updatedBook.author;
              widget.book.year = updatedBook.year;
              widget.book.description = updatedBook.description;
              widget.book.coverUrl = updatedBook.coverUrl;
            });
          },
        ),
      ),
    );
  }

  Future<void> _deleteBook() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              DatabaseHelper().deleteBook(widget.book.id!);
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pop(context); 
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
          "Katalog Detail",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.book.coverUrl != null)
              ClipRRect(
                child: Center(
                  child: Image.file(
                    File(widget.book.coverUrl!),
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                ),
              )
            else
              const Icon(Icons.book, size: 100),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.book.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                  ),
                ),
                FavoriteIcon(book: widget.book),
              ],
            ),
            Text(
              'Author: ${widget.book.author}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Year: ${widget.book.year}',
                style: const TextStyle(
                  fontSize: 20,
                )),
            const SizedBox(height: 8),
            Text('Description: ${widget.book.description}'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonCustom(
                  label: 'Edit',
                  onTap: _editBook,
                ),
                ButtonCustom(
                  label: 'Delete',
                  color: Colors.red,
                  onTap: _deleteBook,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
