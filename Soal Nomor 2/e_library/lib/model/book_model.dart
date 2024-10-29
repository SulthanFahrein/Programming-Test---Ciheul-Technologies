class Book {
  final int? id;
   String title;
   String description;
   String author;
   int year;
   String? coverUrl; 
   bool isFavorite;
   int? userId;

  Book({
    this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.year,
    this.coverUrl,
    this.isFavorite = false,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'year': year,
      'cover_url': coverUrl,
      'is_favorite': isFavorite ? 1 : 0,
      'user_id': userId,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      year: map['year'],
      coverUrl: map['cover_url'], 
      isFavorite: map['is_favorite'] == 1,
      userId: map['user_id'],
    );
  }
}
