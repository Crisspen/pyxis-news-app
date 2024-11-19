import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pyxis_news/article.dart';
import 'package:pyxis_news/article_hive.dart';
import 'package:pyxis_news/article_provider.dart';
import 'package:pyxis_news/pyxis_news_theme.dart';
import 'package:pyxis_news/home.dart';
//import 'package:hive/hive.dart';

final articleHive = ArticleHive();
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await articleHive.openHiveBox();
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
      title: 'Pyxis News',
      theme: PyxisNewsTheme.lightTheme,
      home: const HomePage(),
    );
  }
}
