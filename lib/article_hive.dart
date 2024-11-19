import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pyxis_news/article.dart';

/// Handles local storage of articles using Hive.
class ArticleHive {
  /// The name of the Hive box for storing bookmarked articles.
  static const String boxName = 'bookmarked'; // Made static for easy access

  late Box<Article> _box; // Declare a private box variable

  /// Opens the Hive box.  Should be called once before using other methods.
  Future<void> openHiveBox() async {
    _box = await Hive.openBox<Article>(boxName);
  }

  /// Saves an article to the Hive box.
  Future<void> saveArticle(Article article) async {
    try {
      await _box.put(article.title, article);
    } catch (e) {
      // Handle exceptions appropriately, e.g., logging or displaying an error message.
      debugPrint("Error saving article: $e");
    }
  }


  /// Removes an article from the Hive box.
  Future<void> removeArticle(Article article) async {
    try {
      await _box.delete(article.title);
    } catch (e) {
      // Handle exceptions appropriately
      debugPrint("Error removing article: $e");
    }
  }

  /// Closes the Hive box. Call this when you're finished with the box.
  void closeHiveBox() {
      _box.close();
  }
}
