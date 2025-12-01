import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../providers/theme_provider.dart';

class SettingsCardWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsCardWidget({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),

          // Theme Toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return _buildSettingTile(
                context: context,
                iconName: themeProvider.isDarkMode ? 'dark_mode' : 'light_mode',
                title: 'Theme',
                subtitle: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
              );
            },
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 3.h,
          ),

          // Notifications
          _buildSettingTile(
            context: context,
            iconName: 'notifications',
            title: 'Notifications',
            subtitle: 'Push notifications and alerts',
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
            onTap: () => _showNotificationSettings(context),
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 3.h,
          ),

          // Privacy
          _buildSettingTile(
            context: context,
            iconName: 'privacy_tip',
            title: 'Privacy',
            subtitle: 'Privacy settings and data control',
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
            onTap: () => _showPrivacySettings(context),
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 3.h,
          ),

          // Help & Support
          _buildSettingTile(
            context: context,
            iconName: 'help',
            title: 'Help & Support',
            subtitle: 'FAQ, contact support',
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
            onTap: () => _showHelpSupport(context),
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 3.h,
          ),

          // About
          _buildSettingTile(
            context: context,
            iconName: 'info',
            title: 'About',
            subtitle: 'App version, terms of service',
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.onSurfaceVariant,
              size: 16,
            ),
            onTap: () => _showAbout(context),
          ),

          Divider(
            color: colorScheme.outline.withValues(alpha: 0.2),
            height: 3.h,
          ),

          // Logout
          _buildSettingTile(
            context: context,
            iconName: 'logout',
            title: 'Logout',
            subtitle: 'Sign out of your account',
            trailing: CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: colorScheme.error,
              size: 16,
            ),
            onTap: () => _showLogoutDialog(context),
            titleColor: colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required String iconName,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: iconName,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings coming soon'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings coming soon'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & Support coming soon'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text(
            'About Lostify',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Version: 1.0.0',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'Lostify helps you report and find lost items in your community.',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                'Terms of Service',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Privacy Policy',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text(
            'Logout',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.error,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
