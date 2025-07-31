// ignore_for_file: avoid_print

import 'package:fe_news_app/components/bottom_navbar.dart';
import 'package:fe_news_app/helpers/app_helper.dart';
import 'package:fe_news_app/screen/latest_news_screen.dart';
import 'package:fe_news_app/screen/news_category_screen.dart';
import 'package:fe_news_app/screen/trending_news_screen.dart';
import 'package:fe_news_app/screen/web_view_screen.dart';
import 'package:fe_news_app/services/bookmarks_service.dart';
import 'package:fe_news_app/services/news_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> trendingNews = [];
  bool isLoading = true;
  Set<String> bookmarkedLinks = {};

  @override
  void initState() {
    super.initState();
    fetchBookmarks();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final result = await NewsService.getNewsByCategory('noi-bat-vnexpress');
      setState(() {
        trendingNews = result;
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi gọi API: $e');
      setState(() {
        isLoading = false;
      });
    }
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
    final trendingItem = trendingNews.isNotEmpty ? trendingNews[0] : null;
    final itemLink = trendingItem?['link']?.trim() ?? '';
    final isBookmarked = bookmarkedLinks.any((link) => link.trim() == itemLink);

    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: ColorTheme.bgPrimaryColor,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Image.asset('assets/images/logo.png', width: 48, height: 48),
        ),
        actionsPadding: EdgeInsets.only(right: 16),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, size: 24),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: ColorTheme.primaryColor,
                    strokeWidth: 2.5,
                  ),
                ),
              )
              : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trending section + image + info
                          buildTrendingSection(trendingItem, isBookmarked),
                          const SizedBox(height: 24),

                          // Latest section
                          buildLatestSection(context),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: NewsCategoryScreen(limit: 12),
                  ),
                ],
              ),
      bottomNavigationBar: MyBottomNavbar(),
    );
  }

  Widget buildTrendingSection(dynamic trendingItem, bool isBookmarked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              (trendingItem?['channelTitle']?.split(' - ')?.first ??
                  'No title'),
              style: TextStyles.textMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TrendingNewsScreen(
                          items: trendingNews,
                          title:
                              (trendingItem?['channelTitle']
                                      ?.split(' - ')
                                      ?.first ??
                                  'Tin nổi bật'),
                        ),
                  ),
                );
              },
              child: Text('Xem tất cả', style: TextStyles.textSmall),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Image
        GestureDetector(
          onTap: () {
            final url = trendingItem?['link'];
            if (url != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => WebViewScreen(
                        url: url,
                        title:
                            (trendingItem?['channelTitle']
                                    ?.split(' - ')
                                    ?.first ??
                                'No title'),
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
            child:
                trendingItem?['thumbnail'] != null
                    ? Image.network(
                      trendingItem!['thumbnail'],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.image_not_supported_outlined),
                    )
                    : const Icon(Icons.image),
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          trendingItem?['title'] ?? '',
          style: TextStyles.textMedium.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),

        // Info row
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
                  trendingItem?['source'] ?? 'VNExpress',
                  style: TextStyles.textXSmall.copyWith(
                    color: ColorTheme.bodyText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.schedule, size: 14),
                const SizedBox(width: 4),
                Text(
                  formatTimeAgo(trendingItem?['pubDate']),
                  style: TextStyles.textXSmall.copyWith(
                    color: ColorTheme.bodyText,
                  ),
                ),
              ],
            ),

            // Bookmark
            IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_outline_outlined,
                size: 24,
                color:
                    isBookmarked
                        ? ColorTheme.primaryColor
                        : ColorTheme.disableInput,
              ),
              onPressed: () async {
                final articleLink = trendingItem['link'];

                if (isBookmarked) {
                  final success = await BookmarkService.deleteBookmark(
                    articleLink,
                  );
                  if (success) {
                    setState(() => bookmarkedLinks.remove(articleLink));
                  }
                } else {
                  final success = await BookmarkService.createBookmark({
                    'title': trendingItem['title'],
                    'link': articleLink,
                    'thumbnail': trendingItem['thumbnail'],
                    'source': trendingItem['source'],
                    'pubDate': trendingItem['pubDate'],
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
    );
  }

  Widget buildLatestSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mới nhất',
              style: TextStyles.textMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LatestNewsScreen()),
                );
              },
              child: Text('Xem tất cả', style: TextStyles.textSmall),
            ),
          ],
        ),
      ],
    );
  }
}
