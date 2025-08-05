// ignore_for_file: library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:fe_news_app/components/custom_snackbar.dart';
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

  final Map<String, List<String>> mixedCategoryGroups = {
    'Thế giới': [
      'the-gioi-vnexpress',
      'the-gioi-tuoitre',
      // 'the-gioi-thanhnien',
    ],
    'Thời sự': ['thoi-su-vnexpress', 'thoi-su-tuoitre',
    //  'thoi-su-thanhnien'
     ],
    'Giải trí': [
      'giai-tri-vnexpress',
      'giai-tri-tuoitre',
      // 'giai-tri-thanhnien',
    ],
    'Thể thao': [
      'the-thao-vnexpress',
      'the-thao-tuoitre',
      // 'the-thao-thanhnien',
    ],
    'Giáo dục': [
      'giao-duc-vnexpress',
      'giao-duc-tuoitre',
      // 'giao-duc-thanhnien',
    ],
    'Sức khỏe': [
      'suc-khoe-vnexpress',
      'suc-khoe-tuoitre',
      // 'suc-khoe-thanhnien',
    ],
    'Đời sống': [
      'doi-song-vnexpress',
      'doi-song-tuoitre',
      // 'doi-song-thanhnien',
    ],
    'Công nghệ': [
      'cong-nghe-vnexpress',
      'cong-nghe-tuoitre',
      // 'cong-nghe-thanhnien',
    ],
    'Xe': ['xe-vnexpress', 'xe-tuoitre',
    //  'xe-thanhnien'
     ],
    'Cười': ['cuoi-vnexpress', 'cuoi-tuoitre'],
  };

  late List<String> tabLabels;

  @override
  void initState() {
    super.initState();
    tabLabels = mixedCategoryGroups.keys.toList();
    _tabController = TabController(length: tabLabels.length, vsync: this);
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

  String extractSource(String? channelTitle) {
    if (channelTitle == null || channelTitle.isEmpty) return 'No source';

    // Loại bỏ từ "RSS", "RSS Feed" nếu có
    String cleaned =
        channelTitle
            .replaceAll(RegExp(r'RSS( Feed)?', caseSensitive: false), '')
            .trim();

    // Trường hợp: "Thế giới | Báo Thanh Niên"
    if (cleaned.contains('|')) {
      return cleaned.split('|').last.trim();
    }

    // Trường hợp: "Tuổi Trẻ Online - Thế giới - RSS Feed"
    List<String> parts = cleaned.split(' - ').map((e) => e.trim()).toList();

    if (parts.length >= 2) {
      // Nếu phần đầu chứa "Tuổi Trẻ", chọn phần đầu
      if (parts.first.toLowerCase().contains('tuổi trẻ')) {
        return parts.first;
      }
      // Nếu phần cuối chứa "VnExpress", chọn phần cuối
      if (parts.last.toLowerCase().contains('vnexpress')) {
        return parts.last;
      }
    }

    return cleaned;
  }

  String getSourceKey(String? channelTitle) {
    if (channelTitle == null || channelTitle.isEmpty) return 'unknown';

    final cleaned =
        channelTitle
            .replaceAll(RegExp(r'RSS( Feed)?', caseSensitive: false), '')
            .trim();

    if (cleaned.contains('|')) {
      final source = cleaned.split('|').last.trim().toLowerCase();
      if (source.contains('thanh niên')) return 'thanhnien';
    } else if (cleaned.contains(' - ')) {
      final parts =
          cleaned.split(' - ').map((e) => e.trim().toLowerCase()).toList();
      for (final part in parts) {
        if (part.contains('vnexpress')) return 'vnexpress';
        if (part.contains('tuổi trẻ')) return 'tuoitre';
      }
    }

    return 'unknown';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildNewsItem(dynamic item) {
    final articleLink = item['link'];
    final isBookmarked = bookmarkedLinks.contains(articleLink);
    final sourceKey = getSourceKey(item['channelTitle']);
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
        padding: const EdgeInsets.only(bottom: 24),
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
                  // const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/$sourceKey.png',
                            width: 18,
                            height: 18,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox(
                                width: 18,
                                height: 18,
                              ); 
                            },
                          ),
                          const SizedBox(width: 4),
                          Text(
                            extractSource(item['channelTitle']),
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
                              showCustomSnackBar(
                                context: context,
                                message:
                                    'Đã xóa bài viết khỏi mục yêu thích',
                                type: SnackBarType.success,
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
                              showCustomSnackBar(
                                context: context,
                                message:
                                    'Đã thêm bài viết vào mục yêu thích',
                                type: SnackBarType.success,
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
          ],
        ),
      ),
    );
  }

  Widget buildTabContent(List<String> categories, {int? limit}) {
    return FutureBuilder<List<dynamic>>(
      future: NewsService.getMixedNews(categories),
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
            tabs: tabLabels.map((label) => Tab(text: label)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children:
            tabLabels.map((label) {
              final categories = mixedCategoryGroups[label] ?? [];
              return buildTabContent(categories);
            }).toList(),
      ),
    );
  }
}
