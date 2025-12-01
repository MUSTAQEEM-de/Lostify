import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MyReportsCardWidget extends StatelessWidget {
  final String title;
  final int itemCount;
  final List<String> thumbnailUrls;
  final VoidCallback? onViewAll;
  final Color cardColor;
  final String iconName;

  const MyReportsCardWidget({
    super.key,
    required this.title,
    required this.itemCount,
    required this.thumbnailUrls,
    this.onViewAll,
    required this.cardColor,
    required this.iconName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor.withValues(alpha: 0.1),
              cardColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.5.w),
                    decoration: BoxDecoration(
                      color: cardColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: cardColor,
                      size: 5.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cardColor,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '$itemCount ${itemCount == 1 ? 'item' : 'items'} reported',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              itemCount > 0
                  ? _buildThumbnailPreview()
                  : _buildEmptyState(theme),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onViewAll,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cardColor),
                    foregroundColor: cardColor,
                  ),
                  child: Text(itemCount > 0 ? 'View All' : 'Start Reporting'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailPreview() {
    final displayCount = thumbnailUrls.length > 3 ? 3 : thumbnailUrls.length;

    return Row(
      children: [
        ...List.generate(displayCount, (index) {
          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: CustomImageWidget(
                imageUrl: thumbnailUrls[index],
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
        if (thumbnailUrls.length > 3)
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: cardColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '+${thumbnailUrls.length - 3}',
                style: TextStyle(
                  color: cardColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'inbox',
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 8.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'No items reported yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
