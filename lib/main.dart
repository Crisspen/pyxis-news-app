import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pyxis_news/article.dart';
import 'package:pyxis_news/article_hive.dart';
import 'package:pyxis_news/article_provider.dart';
import 'package:pyxis_news/bookmarks.dart';
import 'package:pyxis_news/pyxis_news_theme.dart';
import 'package:pyxis_news/home.dart';
import 'package:pyxis_news/search.dart';
//import 'package:hive/hive.dart';

final articleHive = ArticleHive();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Ensure initialization
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(SourceAdapter()); // Register Source adapter
  await Hive.openBox<Article>(ArticleHive.boxName); // Open the box *before* the app starts.
  //await Hive.deleteBoxFromDisk('bookmarked');
  runApp(
    ChangeNotifierProvider(
      create: (context) => ArticleProvider(),
      child: const NewsApp(),
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pyxis News',
      theme: PyxisNewsTheme.lightTheme,
      //home: const HomePage(),
      routes: {
        '/': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/bookmarks': (context) => const BookmarksPage(),
      },
    );
  }
}
