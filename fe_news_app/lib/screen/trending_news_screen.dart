import 'package:fe_news_app/helpers/app_helper.dart';
import 'package:fe_news_app/screen/web_view_screen.dart';
import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

class TrendingNewsScreen extends StatelessWidget {
  final List<dynamic> items;
  final String title;

  const TrendingNewsScreen({
    super.key,
    required this.items,
    required this.title,
  });

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
          title,
          style: TextStyles.textMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

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

                // Thời gian
                Text(
                  formatTimeAgo(item['pubDate']),
                  style: TextStyles.textXSmall.copyWith(
                    color: ColorTheme.bodyText,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
