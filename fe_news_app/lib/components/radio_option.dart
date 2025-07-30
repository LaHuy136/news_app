// ignore_for_file: library_private_types_in_public_api

import 'package:fe_news_app/theme/color_theme.dart';
import 'package:fe_news_app/theme/text_styles.dart';
import 'package:flutter/material.dart';

enum ContactOption { email, phone }

class RadioOptionSelector extends StatefulWidget {
  final ContactOption selectedOption;
  final ValueChanged<ContactOption> onChanged;

  const RadioOptionSelector({
    super.key,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  State<RadioOptionSelector> createState() => _RadioOptionSelectorState();
}

class _RadioOptionSelectorState extends State<RadioOptionSelector> {
  late ContactOption localSelected;

  @override
  void initState() {
    super.initState();
    localSelected = widget.selectedOption;
  }

  void select(ContactOption option) {
    setState(() {
      localSelected = option;
    });
    widget.onChanged(option);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Option: Email
        GestureDetector(
          onTap: () {
            select(ContactOption.email);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  localSelected == ContactOption.email
                      ? Colors.blue.shade100
                      : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    localSelected == ContactOption.email
                        ? ColorTheme.primaryColor
                        : ColorTheme.disableInput,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Container
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorTheme.primaryColor,
                  ),
                  child: Icon(
                    Icons.email_outlined,
                    color: ColorTheme.bgPrimaryColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),
                // Icon + Sample
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'qua Email:',
                      style: TextStyles.textSmall.copyWith(
                        color: ColorTheme.bodyText,
                      ),
                    ),

                    Text(
                      'example@youremail.com',
                      style: TextStyles.textMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Option: Phone
        GestureDetector(
          onTap: () {
            select(ContactOption.phone);
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  localSelected == ContactOption.phone
                      ? Colors.blue.shade100
                      : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    localSelected == ContactOption.phone
                        ? ColorTheme.primaryColor
                        : ColorTheme.disableInput,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                // Container
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorTheme.primaryColor,
                  ),
                  child: Icon(
                    Icons.sms_outlined,
                    color: ColorTheme.bgPrimaryColor,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),
                // Icon + Sample
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'qua SMS:',
                      style: TextStyles.textSmall.copyWith(
                        color: ColorTheme.bodyText,
                      ),
                    ),

                    Text(
                      '+62-8421-4512-2531',
                      style: TextStyles.textMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
