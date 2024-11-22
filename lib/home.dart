import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:pyxis_news/bookmarks.dart';
//import 'package:pyxis_news/search.dart';
//import 'package:pyxis_news/search.dart';
import 'package:shimmer/shimmer.dart';

import 'package:pyxis_news/article_provider.dart';
import 'package:pyxis_news/bottom_nav_bar.dart';
import 'package:pyxis_news/news_article_card.dart';
//import 'package:pyxis_news/search_page.dart';
//import 'package:pyxis_news/bookmarks_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  NewsCategories _selectedCategory = NewsCategories.general;
  int _currentPage = 1; // Track the current page for pagination
  bool _isLoadingMore = false; // Flag to prevent concurrent requests

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchArticles(); // Fetch initial articles on startup
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Fetch articles based on category and page
  Future<void> _fetchArticles({bool reset = false}) async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final articleProvider =
          Provider.of<ArticleProvider>(context, listen: false);
      await articleProvider.fetchLatestArticles(
          page: _currentPage, reset: reset); // Pass reset flag
      _currentPage++;
    } catch (e) {
      debugPrint('Error fetching articles: $e');
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

  // Load more articles when scrolling to the bottom
  void _onScroll() {
    if (!_isLoadingMore &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _fetchArticles();
    }
  }

  // Update the selected category and fetch articles
  void _updateSelectedCategory(NewsCategories category) {
    final articleProvider =
        Provider.of<ArticleProvider>(context, listen: false);
    articleProvider.fetchNewsCategory(category); // Call the correct function
    setState(() {
      _selectedCategory =
          category; //Update UI selection only after fetching is done
    });
  }

  @override
  Widget build(BuildContext context) {
    final articleProvider = context.watch<ArticleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pyxis News'),
      ),
      body: Column(
        children: [
          // Category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: NewsCategories.values.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(category.name.toUpperCase()),
                    onSelected: (selected) {
                      if (selected) {
                        _updateSelectedCategory(category);
                      }
                    },
                    selected: _selectedCategory == category,
                  ),
                );
              }).toList(),
            ),
          ),
          // Article list view
          Expanded(
            child: articleProvider.topHeadlines.isEmpty
                ? Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: 10, // Show 10 shimmer placeholders
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ) // Show shimmer while loading
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: articleProvider.topHeadlines.length +
                        (_isLoadingMore ? 1 : 0), // Show loading indicator
                    itemBuilder: (context, index) {
                      if (index < articleProvider.topHeadlines.length) {
                        final article = articleProvider.topHeadlines[index];
                        return NewsArticleCard(article: article);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        onTap: (index) {
          // Handle navigation based on the tapped index
          switch (index) {
            case 0:
              // Do nothing, already on the home page
              break;
            case 1:
              // Navigate to the search page
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              // Navigate to the bookmarks page
              Navigator.pushNamed(context, '/bookmarks');
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
