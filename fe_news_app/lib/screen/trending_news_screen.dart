// ignore_for_file: avoid_print

import 'package:fe_news_app/helpers/app_helper.dart';
import 'package:fe_news_app/screen/web_view_screen.dart';
import 'package:fe_news_app/services/bookmarks_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TrendingNewsScreen extends StatefulWidget {
  final List<dynamic> items;
  final String title;

  const TrendingNewsScreen({
    super.key,
    required this.items,
    required this.title,
  });

  @override
  State<TrendingNewsScreen> createState() => _TrendingNewsScreenState();
}

class _TrendingNewsScreenState extends State<TrendingNewsScreen> {
  Set<String> bookmarkedLinks = {};

  @override
  void initState() {
    super.initState();
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    try {
      final bookmarks = await BookmarkService.getBookmarks();
      final links = bookmarks.map<String>((e) => e['link'] as String).toSet();

      setState(() {
        bookmarkedLinks = links;
      });
    } catch (e) {
      print('Lỗi khi lấy danh sách bookmark: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorTheme.bgPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_outlined, size: 18),
        ),
        title: Text(
          widget.title,
          style: TextStyles.textMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          final itemLink = item?['link']?.trim() ?? '';
          final isBookmarked = bookmarkedLinks.any(
            (link) => link.trim() == itemLink,
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh
                GestureDetector(
                  onTap: () {
                    final url = item['link'];
                    if (url != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => WebViewScreen(
                                url: url,
                                title:
                                    (item['channelTitle']
                                            ?.split(' - ')
                                            ?.first ??
                                        ''),
                              ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: ColorTheme.titleActive,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child:
                          item['thumbnail'] != null
                              ? Image.network(
                                item['thumbnail'],
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.image_not_supported_outlined,
                                    ),
                              )
                              : const Icon(Icons.image),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tiêu đề
                Text(
                  item['title'] ?? '',
                  style: TextStyles.textMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/vnexpress.png',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item?['source'] ?? 'VNExpress',
                          style: TextStyles.textXSmall.copyWith(
                            color: ColorTheme.bodyText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.schedule, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          formatTimeAgo(item?['pubDate']),
                          style: TextStyles.textXSmall.copyWith(
                            color: ColorTheme.bodyText,
                          ),
                        ),
                      ],
                    ),

                    // Bookmark
                    IconButton(
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline_outlined,
                        size: 24,
                        color:
                            isBookmarked
                                ? ColorTheme.primaryColor
                                : ColorTheme.disableInput,
                      ),
                      onPressed: () async {
                        final articleLink = item['link'];

                        if (isBookmarked) {
                          final success = await BookmarkService.deleteBookmark(
                            articleLink,
                          );
                          if (success) {
                            setState(() => bookmarkedLinks.remove(articleLink));
                          }
                        } else {
                          final success = await BookmarkService.createBookmark({
                            'title': item['title'],
                            'link': articleLink,
                            'thumbnail': item['thumbnail'],
                            'source': item['source'],
                            'pubDate': item['pubDate'],
                          });

                          if (success) {
                            setState(() => bookmarkedLinks.add(articleLink));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
