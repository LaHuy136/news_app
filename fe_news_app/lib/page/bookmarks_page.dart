// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:fe_news_app/components/bottom_navbar.dart';
import 'package:fe_news_app/components/custom_snackbar.dart';
import 'package:fe_news_app/helpers/app_helper.dart';
import 'package:fe_news_app/screen/web_view_screen.dart';
import 'package:fe_news_app/services/bookmarks_service.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage> {
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  String? selectedSource;

  List<dynamic> bookmarks = [];
  List<dynamic> filteredBookmarks = [];
  Set<String> bookmarkedLinks = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookmarks();
    searchFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> loadBookmarks() async {
    try {
      final data = await BookmarkService.getBookmarks();
      final links = data.map<String>((e) => e['link'] as String).toSet();
      if (!mounted) return;
      setState(() {
        bookmarks = data;
        filteredBookmarks = data;
        bookmarkedLinks = links;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading bookmarks: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterBySource(String? source) {
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      selectedSource = source;
      filteredBookmarks =
          bookmarks.where((item) {
            final title = (item['title'] ?? '').toLowerCase();
            final sourceVal = (item['source'] ?? '').toLowerCase();

            final matchesSource =
                source == null || sourceVal == source.toLowerCase();
            final matchesQuery =
                title.contains(query) || sourceVal.contains(query);

            return matchesSource && matchesQuery;
          }).toList();
    });
  }

  void showSourceFilterDialog() {
    final query = searchController.text.toLowerCase().trim();
    final sources =
        getSourcesFromBookmarks(
          bookmarks,
        ).where((s) => s.toLowerCase().contains(query)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chọn nguồn tin'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('Tất cả nguồn'),
                  leading: const Icon(Icons.clear_all),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      selectedSource = null;
                      filteredBookmarks = bookmarks;
                    });
                  },
                ),
                const Divider(),
                ...sources.map(
                  (source) => ListTile(
                    title: Text(source),
                    onTap: () {
                      Navigator.pop(context);
                      filterBySource(source);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Set<String> getSourcesFromBookmarks(List<dynamic> items) {
    return items
        .map((e) => (e['source'] ?? '').toString().trim())
        .where((source) => source.isNotEmpty)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.bgPrimaryColor,
      appBar: AppBar(
        backgroundColor: ColorTheme.bgPrimaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Mục yêu thích',
          style: TextStyles.textLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
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
              : bookmarks.isEmpty
              ? Center(
                child: Text(
                  'Không có bài viết nào được lưu',
                  style: TextStyles.textMedium,
                ),
              )
              : Column(
                children: [
                  // Search
                  buildSearchTextField(context),

                  const SizedBox(height: 20),
                  // ListView
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredBookmarks.length,
                      itemBuilder: (context, index) {
                        final item = filteredBookmarks[index];
                        final url = item['link'];
                        final isBookmarked = bookmarkedLinks.contains(url);
                        return GestureDetector(
                          onTap: () {
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
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 16,
                              left: 16,
                              bottom: 16,
                            ),
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
                                          (context, error, stackTrace) => Icon(
                                            Icons.image_not_supported_outlined,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  style: TextStyles.textXSmall
                                                      .copyWith(
                                                        color:
                                                            ColorTheme.bodyText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                                const SizedBox(width: 8),
                                                Icon(
                                                  Icons.access_time,
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  formatTimeAgo(
                                                    item['pubDate'],
                                                  ),
                                                  style: TextStyles.textXSmall
                                                      .copyWith(
                                                        color:
                                                            ColorTheme.bodyText,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                isBookmarked
                                                    ? Icons.bookmark
                                                    : Icons
                                                        .bookmark_outline_outlined,
                                                size: 24,
                                                color:
                                                    isBookmarked
                                                        ? ColorTheme
                                                            .primaryColor
                                                        : ColorTheme
                                                            .disableInput,
                                              ),
                                              onPressed: () async {
                                                final url = item['link'];

                                                if (isBookmarked) {
                                                  final success =
                                                      await BookmarkService.deleteBookmark(
                                                        url,
                                                      );
                                                  if (success) {
                                                    setState(() {
                                                      bookmarkedLinks.remove(
                                                        url,
                                                      );
                                                      bookmarks.removeWhere(
                                                        (b) => b['link'] == url,
                                                      );
                                                      filteredBookmarks
                                                          .removeWhere(
                                                            (b) =>
                                                                b['link'] ==
                                                                url,
                                                          );
                                                    });
                                                    showCustomSnackBar(
                                                      context: context,
                                                      message:
                                                          'Đã xóa bài viết khỏi mục yêu thích',
                                                      type:
                                                          SnackBarType.success,
                                                    );
                                                  }
                                                } else {
                                                  final success =
                                                      await BookmarkService.createBookmark(
                                                        {
                                                          'title':
                                                              item['title'],
                                                          'link': url,
                                                          'thumbnail':
                                                              item['thumbnail'],
                                                          'source':
                                                              item['source'],
                                                          'pubDate':
                                                              item['pubDate'],
                                                        },
                                                      );

                                                  if (success) {
                                                    setState(
                                                      () => bookmarkedLinks.add(
                                                        url,
                                                      ),
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
                      },
                    ),
                  ),
                ],
              ),
      bottomNavigationBar: MyBottomNavbar(),
    );
  }

  Widget buildSearchTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Tìm kiếm theo tiêu đề hoặc nguồn',
          hintStyle: TextStyles.textSmall.copyWith(fontWeight: FontWeight.w500),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon:
              searchFocusNode.hasFocus
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      filterBySource(selectedSource);
                      setState(() {
                        filteredBookmarks = bookmarks;
                      });
                    },
                  )
                  : IconButton(
                    icon: const Icon(Icons.tune_outlined),
                    onPressed: () {
                      showSourceFilterDialog();
                    },
                  ),
        ),
        onChanged: (query) {
          query = query.toLowerCase().trim();

          setState(() {
            filteredBookmarks =
                bookmarks.where((item) {
                  final title = (item['title'] ?? '').toLowerCase();
                  final source = (item['source'] ?? '').toLowerCase();

                  final matchesSource =
                      selectedSource == null ||
                      source == selectedSource!.toLowerCase();
                  final matchesQuery =
                      title.contains(query) || source.contains(query);

                  return matchesSource && matchesQuery;
                }).toList();
          });
        },
      ),
    );
  }
}
