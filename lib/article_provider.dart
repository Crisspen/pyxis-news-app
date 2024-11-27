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
  int _currentPage = 1;
  bool _isLoadingMore = false;
  final bool _isSearching = false;

  int get currentPage => _currentPage;
  bool get isLoadingMore => _isLoadingMore;
  bool get isSearching => _isSearching;

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

  /// Shares an article using the device's share functionality.
  Future<void> shareArticle(Article article) async {
    await Share.share(article.url);
    notifyListeners();
  }

  /// Fetches latest articles directly from NewsRequest.
  Future<void> fetchLatestArticles(
      {required int page, required bool reset}) async {
    try {
      final headlines = await NewsRequest().fetchLatestArticles(page: page);
      if (reset) {
        topHeadlines =
            headlines; // Reset the list if it's a new category or initial load
      } else {
        topHeadlines
            .addAll(headlines); // Append new articles to the existing list
      }
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
    }
  }
//Clear list of search results
void clearSearchResults() {
    searchResults.clear();
    //notifyListeners();
  } 

  Future<void> fetchArticles(
      {required NewsCategories category, required int page, required bool reset}) async {
    _isLoadingMore = true;

    try {
      if (reset) {
        _currentPage = 1;
        topHeadlines.clear();
      }

      if (category == NewsCategories.general) {
        final articles = await NewsRequest().fetchLatestArticles(page: page);
        if (reset) {
          topHeadlines = articles;
        } else {
          topHeadlines.addAll(articles);
        }
      } else {
        final articles = await NewsRequest().fetchNewsCategory(category);
        topHeadlines = articles; //Replace the list for specific categories
      }
       _currentPage = page; //Keep track of page number for future pagination 
    } catch (e) {
      debugPrint('Error fetching articles: $e');
      // Add appropriate error handling (e.g., show a snackbar to the user)
    } finally {
      _isLoadingMore = false;
    }
    notifyListeners();
  }

  //Expose a method to request more articles
  Future<void> loadMoreArticles(NewsCategories category) async {
    if (isLoadingMore) return; // Prevent concurrent calls

    _isLoadingMore = true;

    try {
      _currentPage++; // Increment page for next set of results
      await fetchArticles(
          category: category,
          page: _currentPage,
          reset: false); // Fetch and append
    } catch (e) {
      _currentPage--; // Decrement page if there's an error
      // Handle error
    } finally {
      _isLoadingMore = false;
    }
      notifyListeners();
  }

}
