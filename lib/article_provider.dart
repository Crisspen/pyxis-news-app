//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pyxis_news/article.dart';
import 'package:pyxis_news/article_request.dart';
import 'package:pyxis_news/article_hive.dart';
import 'package:share_plus/share_plus.dart';

/// Enum representing different news categories.
enum NewsCategories {
  general,
  business,
  entertainment,
  health,
  science,
  sports,
  technology
}

/// Provides news articles and manages related state.
class ArticleProvider with ChangeNotifier {
  /// List of latest news articles.
  List<Article> topHeadlines = [];

  /// List of bookmarked articles.
  List<Article> bookmarked = [];

  ///List of recent searches
  List<String> recentSearches = [];

  ///List of search results
  List<Article> searchResults = [];

  /// Currently selected news category.
  NewsCategories selectedCategory = NewsCategories.general;

  /// Instance of ArticleHive for local storage of bookmarks.
  final ArticleHive articleHive = ArticleHive();

  /// Bookmarks an article.
  Future<void> bookmarkArticle(Article article) async {
    if (bookmarked.contains(article)) {
      // If article is already bookmarked, remove it
      bookmarked.remove(article);
      await articleHive.removeArticle(article);
    } else {
      // If article is not bookmarked, add it
      bookmarked.add(article);
      await articleHive.saveArticle(article);
    }
    notifyListeners();
  }

  /// Removes a bookmark for an article.
  /*Future<void> removeBookmark(Article article) async {
    bookmarked.remove(article);
    await articleHive.removeArticle(article);
    notifyListeners();
  }*/

  /// Shares an article using the device's share functionality.
  Future<void> shareArticle(Article article) async {
    await Share.share(article.url);
    notifyListeners();
  }

  /// Fetches latest articles directly from NewsRequest.
  Future<void> fetchLatestArticles({required int page}) async {
    try {
      final headlines = await NewsRequest().fetchLatestArticles(page: page);
      topHeadlines = headlines;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching latest articles: $e');
      notifyListeners();
    }
  }

  /// Fetches articles for a specific category directly from NewsRequest.
  Future<void> fetchNewsCategory(NewsCategories category) async {
    try {
      final articles = await NewsRequest().fetchNewsCategory(category);
      topHeadlines = articles;
      selectedCategory = category;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching articles for this category: $e');
      notifyListeners();
    }
  }

  /// Searches for articles directly from NewsRequest.
  Future<void> searchArticles(String query) async {
    try {
      final searchResultsList = await NewsRequest().searchArticles(query);
      searchResults = searchResultsList;
      if (!recentSearches.contains(query)) {
        recentSearches.add(query);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching articles for this search: $e');
      notifyListeners();
    }
  }
}
