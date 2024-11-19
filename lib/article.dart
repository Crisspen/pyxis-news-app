import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'article.g.dart';

/// Represents a news article.
@HiveType(typeId: 0)
class Article extends HiveObject {
  /// The author of the article.
  @HiveField(0)
  final String author;

  /// The title of the article.
  @HiveField(1)
  final String title;

  /// A brief description of the article.
  @HiveField(2)
  final String description;

  /// The URL of the full article.
  @HiveField(3)
  final String url;

  /// The URL of an image associated with the article.
  @HiveField(4)
  final String urlToImage;

  /// The date and time when the article was published.
  @HiveField(5)
  final String publishedAt;

  /// The source of the article.
  @HiveField(6)
  final Source source;

  /// Constructor for the Article class.
  Article({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
  });

  /// Factory constructor to create an Article object from JSON data.
  factory Article.fromJson(Map<String, dynamic> json) {
    try {
      /// Create an Article object from the JSON data.
      return Article(
        author: json["author"] ?? 'Unknown Author',
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"] ?? '',
        publishedAt: json["publishedAt"],
        source: Source.fromJson(json["source"]),
      );
    } catch (e) {
      /// Handle parsing errors by logging the error and returning a default Article object.
      debugPrint('Error parsing article: $e');
      return Article(
        author: 'Unknown Author',
        title: 'Error loading article',
        description: '',
        url: '',
        urlToImage: '',
        publishedAt: '',
        source: Source(name: 'Unknown Source'),
      );
    }
  }
}

/// Represents the source of a news article.
@HiveType(typeId: 1)
class Source extends HiveObject {
  /// The ID of the source.
  @HiveField(0)
  final String? id;

  /// The name of the source.
  @HiveField(1)
  final String name;

  /// Constructor for the Source class.
  Source({this.id, required this.name});

  /// Factory constructor to create a Source object from JSON data.
  factory Source.fromJson(Map<String, dynamic> json) {
    /// Create a Source object from the JSON data.
    return Source(
      id: json['id'] ?? 'unknown',
      name: json['name'] ?? 'unknown',
    );
  }
}
