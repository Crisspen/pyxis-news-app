import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:pyxis_news/article.dart';

import 'package:pyxis_news/article_provider.dart';
//import 'package:pyxis_news/bookmarks.dart';
import 'package:pyxis_news/bottom_nav_bar.dart';
import 'package:pyxis_news/news_article_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late ArticleProvider articleProvider;

  @override
  void initState() {
    super.initState();
    articleProvider = Provider.of<ArticleProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    articleProvider.clearSearchResults();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    articleProvider.clearSearchResults();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), 
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Back Button
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                // Text Field
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search for news...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        // Hide the keyboard
                        FocusScope.of(context).unfocus();

                        // Fetch search results
                        articleProvider.searchArticles(query);
                      }
                    },
                  ),
                ),
                // Search Icon
                IconButton(
                  onPressed: () {
                    final query = _searchController.text;
                    if (query.isNotEmpty) {
                      // Hide the keyboard
                      FocusScope.of(context).unfocus();

                      // Fetch search results
                      articleProvider.searchArticles(query);
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          // Display search results OR No results message
          Expanded(
            child: Consumer<ArticleProvider>(
              builder: (context, articleProvider, child) {
                if (articleProvider.searchResults.isNotEmpty) {
                  return ListView.builder(
                    itemCount: articleProvider.searchResults.length,
                    itemBuilder: (context, index) => NewsArticleCard(
                        article: articleProvider.searchResults[index]),
                  );
                } else if (articleProvider.recentSearches.isNotEmpty &&
                    _searchController.text.isEmpty) {
                  return ListView.builder(
                    // Display recent searches when searchResults is empty
                    itemCount: articleProvider.recentSearches.length,
                    itemBuilder: (context, index) {
                      final query = articleProvider.recentSearches[index];
                      return ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(query),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Update the search field and fetch results
                          _searchController.text = query;
                          articleProvider.searchArticles(query);
                        },
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text('No search results')); // Default message
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
              // Navigate to the home page
              Navigator.pushReplacementNamed(context, '/');
              break;

            case 1:
              // Do nothing, already on the search page
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
