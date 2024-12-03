import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pyxis_news/article.dart';
import 'package:pyxis_news/article_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsArticleCard extends StatelessWidget {
  final Article article;

  const NewsArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);
    final theme = Theme.of(context);

    return ValueListenableBuilder<Box<Article>>(
      valueListenable: Hive.box<Article>('bookmarked').listenable(),
      builder: (context, box, child) {
        final isBookmarked = box.containsKey(article.url);
        return InkWell(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: Text(article.title)),
                  body: WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(article.url)),
                  ),
                ),
              ),
            );
          },
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: article.urlToImage.isNotEmpty
                      ? Image.network(
                          article.urlToImage,
                          fit: BoxFit.fill,
                          height: 200,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                        )
                      : const Icon(Icons.image_not_supported),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.title,
                        style: theme.textTheme.headlineSmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            article.source!.name,
                            style: theme.textTheme.bodySmall,
                          ),
                          Text(
                            timeago.format(
                                DateTime.parse(article.publishedAt)),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              articleProvider.bookmarkArticle(article);
                            },
                            icon: Icon(
                              isBookmarked
                                  ? Icons.bookmark_outlined
                                  : Icons.bookmark_border_sharp,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                articleProvider.shareArticle(article),
                            icon: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
