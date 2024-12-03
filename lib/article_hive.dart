import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pyxis_news/article.dart';

class ArticleHive {
  static const String boxName = 'bookmarked';
  late Box<Article> _box;

  ArticleHive() {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<Article>(boxName);
  }

  Future<void> saveArticle(Article article) async {
    try {
      // Use the article's URL as the key (assuming it's unique)
      await _box.put(article.url, article); 
    } catch (e) {
      debugPrint("Error saving article: $e");
      debugPrint("Saving article: ${article.title}");
    }
  }

  Future<void> removeArticle(String url) async { // Takes URL as key
    try {
      await _box.delete(url);
    } catch (e) {
      debugPrint("Error removing article: $e");
      debugPrint("Deleting article: ,$url");
    }
  }

  List<Article> getBookmarkedArticles() {
    return _box.values.toList();
  }

  void closeHiveBox() {
    _box.close();
  }
}
