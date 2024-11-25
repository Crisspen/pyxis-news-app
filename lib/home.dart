import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:pyxis_news/article_provider.dart';
import 'package:pyxis_news/bottom_nav_bar.dart';
import 'package:pyxis_news/news_article_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  NewsCategories _selectedCategory = NewsCategories.general;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      final articleProvider =
          // ignore: use_build_context_synchronously
          Provider.of<ArticleProvider>(context, listen: false);
      articleProvider.fetchArticles(
          category: _selectedCategory, page: 1, reset: true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Load more articles when scrolling to the bottom
  void _onScroll() {
  final articleProvider = Provider.of<ArticleProvider>(context, listen: false);
  if (!articleProvider.isLoadingMore &&
      _scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
    articleProvider.loadMoreArticles(_selectedCategory); // Pass the current category
  }
}

  // Update the selected category and fetch articles
 void _updateSelectedCategory(NewsCategories category) {
   setState(() {
     _selectedCategory = category;
   });
   final articleProvider = Provider.of<ArticleProvider>(context, listen: false);
   articleProvider.fetchArticles(category: category, page: 1, reset: true); 
 }
 

  @override
  Widget build(BuildContext context) {
    final articleProvider = context.watch<ArticleProvider>();
    bool isLoadingMore =
        articleProvider.isLoadingMore; //Access public getter here

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
                        (isLoadingMore ? 1 : 0), // Show loading indicator
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
