import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pyxis_news/article_provider.dart';
import 'package:pyxis_news/bookmarks.dart';
import 'package:pyxis_news/bottom_nav_bar.dart';
import 'package:pyxis_news/news_article_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search News'),
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
                  // Display search results
                  return ListView.builder(
                    itemCount: articleProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      final article = articleProvider.searchResults[index];
                      return NewsArticleCard(article: article);
                    },
                  );
                } else if (articleProvider.recentSearches.isNotEmpty) {
                  // Display recent searches when there are no search results
                  return ListView.builder(
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
                  // Display "No search results" when there are no results or recent searches
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No search results'),
                    ),
                  );
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
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false);
              break;

            case 1:
              // Do nothing, already on the search page
              break;
            case 2:
              // Navigate to the bookmarks page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookmarksPage(),
                ),
              );
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}
