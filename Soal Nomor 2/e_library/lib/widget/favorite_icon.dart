// lib/widget/favorite_icon.dart

import 'package:flutter/material.dart';
import 'package:e_library/model/book_model.dart';
import 'package:e_library/config/database_helper.dart';

class FavoriteIcon extends StatefulWidget {
  final Book book;

  const FavoriteIcon({Key? key, required this.book}) : super(key: key);

  @override
  _FavoriteIconState createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<FavoriteIcon> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.book.isFavorite; // Initialize favorite status
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await _updateFavoriteStatus();
  }

  Future<void> _updateFavoriteStatus() async {
    widget.book.isFavorite = _isFavorite;
    await DatabaseHelper().updateBook(widget.book); // Update book in DB
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _toggleFavorite,
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        size: 30,
        color: Colors.red,
      ),
    );
  }
}
