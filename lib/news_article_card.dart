import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:pyxis_news/article.dart';
import 'package:pyxis_news/article_provider.dart';
//import 'package:pyxis_news/pyxis_news_theme.dart'; // Import the theme file

class NewsArticleCard extends StatefulWidget {
  final Article article;

  const NewsArticleCard({
    super.key,
    required this.article,
  });

  @override
  State<NewsArticleCard> createState() => _NewsArticleCardState();
}

class _NewsArticleCardState extends State<NewsArticleCard> {
  bool isRead = false;

  @override
  Widget build(BuildContext context) {
    final articleProvider = Provider.of<ArticleProvider>(context);
    final theme = Theme.of(context); // Get the current theme

    return InkWell(
      onTap: () async {
        setState(() {
          isRead = true;
        });

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(widget.article.title),
              ),
              body: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(widget.article.url)),
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: widget.article.urlToImage.isNotEmpty
                  ? Image.network(
                      widget.article.urlToImage,
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error),
                    )
                  : const Icon(Icons.image_not_supported),
            ),
            //Add a row with an image of article source and time lapsed since article has been publishedRow(
    
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.article.source.name,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  widget.article.publishedAt.toString(),
                  style: theme.textTheme.bodySmall,
                ),
              
            

            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: theme.textTheme.headlineSmall, // Use theme's headlineSmall style
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.article.author,
                    style: theme.textTheme.bodyMedium, // Use theme's bodyMedium style
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () =>
                            articleProvider.bookmarkArticle(widget.article),
                        icon: Icon(
                          articleProvider.bookmarked.contains(widget.article)
                              ? Icons.bookmark_outlined
                              : Icons.bookmark_border_sharp,
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            articleProvider.shareArticle(widget.article),
                        icon: const Icon(Icons.share),
                      ),
                      Icon(
                        isRead ? Icons.visibility_outlined : Icons.visibility_rounded,
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
  }
}
