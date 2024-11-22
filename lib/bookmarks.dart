import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyxis_news/article_provider.dart';
import 'package:pyxis_news/bottom_nav_bar.dart';
import 'package:pyxis_news/news_article_card.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved'),
      ),
      body: articleProvider.bookmarked.isEmpty
          ? const Center(
              child: Text('No saved articles yet.'),
            )
          : ListView.builder(
              itemCount: articleProvider.bookmarked.length,
              itemBuilder: (context, index) {
                final article = articleProvider.bookmarked[index];
                return NewsArticleCard(article: article);
              },
            ),
      bottomNavigationBar: BottomNavBar(
        initialIndex: 2, // Set initial index to 2 for Bookmarks
        onTap: (index) {
          // Handle navigation based on the tapped index
          switch (index) {
            case 0:
              // Navigate to the home page
              Navigator.pushReplacementNamed(context, '/');
              break;

            case 1:
              // Navigate to the search page
              Navigator.pushNamed(context, '/search');
              break;

            case 2:
              // Do nothing, already on the bookmarks page
              break;

            default:
              break;
          }
        },
      ),
    );
  }
}
