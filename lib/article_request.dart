import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pyxis_news/article.dart';
import 'package:pyxis_news/article_provider.dart';

/// Handles making API requests to fetch news articles.
class NewsRequest {
  /// Your API key for the News API.
  var apiKey = '2d58f2eb0aad4c9b963cc3aac1d0ff5a';

  // Function to fetch latest articles
  Future<List<Article>> fetchLatestArticles({required int page}) async {
    /// Construct the API URL for fetching latest articles.
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?category=general&apiKey=$apiKey&page=$page'));

    /// Check if the API request was successful.
    if (response.statusCode == 200) {
      /// Decode the JSON response from the API.
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      /// Extract the list of articles from the JSON data.
      if (data['status'] == 'ok') {
        final articlesData = data['articles'] as List<dynamic>;

        /// Convert the list of JSON articles into a list of Article objects.
        return articlesData
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();
      } else {
        /// Throw an exception if the API request failed.
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } else {
      /// Throw an exception if the API request failed.
      throw Exception('Failed to load articles: ${response.statusCode}');
    }
  }

  //Function to fetch news by category
  Future<List<Article>> fetchNewsCategory(NewsCategories category) async {
    /// Construct the API URL for fetching articles by category.
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?category=${category.name}&apiKey=$apiKey'));

    /// Check if the API request was successful.
    if (response.statusCode == 200) {
      /// Decode the JSON response from the API.
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      /// Extract the list of articles from the JSON data.
      final articlesData = data['articles'] as List<dynamic>;

      /// Convert the list of JSON articles into a list of Article objects.
      return articlesData
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
    } else {
      /// Throw an exception if the API request failed.
      throw Exception(
          'Failed to load articles for category: ${category.name}: ${response.statusCode}');
    }
  }

  //Function to fetch news using search query
  Future<List<Article>> searchArticles(String query) async {
    /// Construct the API URL for searching articles.
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/everything?q=$query&apiKey=$apiKey'));

    /// Check if the API request was successful.
    if (response.statusCode == 200) {
      /// Decode the JSON response from the API.
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      /// Extract the list of articles from the JSON data.
      final articlesData = data['articles'] as List<dynamic>;

      /// Convert the list of JSON articles into a list of Article objects.
      return articlesData
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
    } else {
      /// Throw an exception if the API request failed.
      throw Exception(
          'Failed to load articles for query: $query: ${response.statusCode}');
    }
  }
}
