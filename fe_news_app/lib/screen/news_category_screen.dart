// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:fe_news_app/helpers/app_helper.dart';
import 'package:fe_news_app/screen/web_view_screen.dart';
import 'package:fe_news_app/services/bookmarks_service.dart';
import 'package:fe_news_app/services/news_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class NewsCategoryScreen extends StatefulWidget {
  final int? limit;
  const NewsCategoryScreen({super.key, this.limit});

  @override
  _NewsCategoryScreenState createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends State<NewsCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Set<String> bookmarkedLinks = {}; 

  final Map<String, String> categories = {
    'the-gioi-vnexpress': 'Thế giới',
    'cong-nghe-vnexpress': 'Công nghệ',
    'the-thao-vnexpress': 'Thể thao',
    'doi-song-vnexpress': 'Đời sống',
    'giai-tri-vnexpress': 'Giải trí',
    'xe-vnexpress': 'Xe',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildNewsItem(dynamic item) {
    final articleLink = item['link'];
    final isBookmarked = bookmarkedLinks.contains(articleLink);
    return GestureDetector(
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
                        (item['channelTitle']?.split(' - ')?.first ??
                            'No title'),
                  ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  item['thumbnail'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      item['title'] ?? '',
                      style: TextStyles.textMedium.copyWith(
                        fontWeight: FontWeight.w500,
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
                              item['source'] ?? 'VNExpress',
                              style: TextStyles.textXSmall.copyWith(
                                color: ColorTheme.bodyText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.access_time, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              formatTimeAgo(item['pubDate']),
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
                              final success =
                                  await BookmarkService.deleteBookmark(
                                    articleLink,
                                  );
                              if (success) {
                                setState(
                                  () => bookmarkedLinks.remove(articleLink),
                                );
                              }
                            } else {
                              final success =
                                  await BookmarkService.createBookmark({
                                    'title': item['title'],
                                    'link': articleLink,
                                    'thumbnail': item['thumbnail'],
                                    'source': item['source'],
                                    'pubDate': item['pubDate'],
                                  });

                              if (success) {
                                setState(
                                  () => bookmarkedLinks.add(articleLink),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabContent(String category, {int? limit}) {
    return FutureBuilder<List<dynamic>>(
      future: NewsService.getNewsByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                color: ColorTheme.primaryColor,
                strokeWidth: 2.5,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi khi tải dữ liệu'));
        }

        final newsList = snapshot.data ?? [];

        final displayList =
            (limit != null) ? newsList.take(limit).toList() : newsList;

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: displayList.length,
          itemBuilder: (context, index) => buildNewsItem(displayList[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          alignment: Alignment.centerLeft,
          constraints: BoxConstraints.expand(height: kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: ColorTheme.titleActive,
            unselectedLabelColor: ColorTheme.dividerColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            indicatorColor: ColorTheme.primaryColor,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.symmetric(horizontal: 12),
            tabs: categories.values.map((label) => Tab(text: label)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            categories.keys
                .map(
                  (category) => buildTabContent(category, limit: widget.limit),
                )
                .toList(),
      ),
    );
  }
}
