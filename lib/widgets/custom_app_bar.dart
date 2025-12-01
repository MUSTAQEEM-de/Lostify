import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  primary,
  transparent,
  search,
  profile,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.primary,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.onSearchTap,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _getTitleColor(colorScheme),
              ),
            )
          : null,
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getForegroundColor(colorScheme),
      elevation: _getElevation(),
      shadowColor: _getShadowColor(colorScheme),
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? _buildLeading(context),
      actions: actions ?? _buildActions(context),
      flexibleSpace: variant == CustomAppBarVariant.transparent
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (!automaticallyImplyLeading) return null;

    final canPop = Navigator.of(context).canPop();
    if (!canPop) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.primary:
        return [
          if (onSearchTap != null)
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: onSearchTap,
              tooltip: 'Search',
            ),
          if (onNotificationTap != null)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: onNotificationTap,
                  tooltip: 'Notifications',
                ),
                if (notificationCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colorScheme.error,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        notificationCount > 99
                            ? '99+'
                            : notificationCount.toString(),
                        style: GoogleFonts.inter(
                          color: colorScheme.onError,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          if (onProfileTap != null)
            IconButton(
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () => Navigator.pushNamed(context, '/user-profile'),
              tooltip: 'Profile',
            ),
          const SizedBox(width: 8),
        ];

      case CustomAppBarVariant.search:
        return [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              // Handle filter action
            },
            tooltip: 'Filter',
          ),
          const SizedBox(width: 8),
        ];

      case CustomAppBarVariant.profile:
        return [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Handle settings action
            },
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              // Handle more options
            },
            tooltip: 'More options',
          ),
          const SizedBox(width: 8),
        ];

      case CustomAppBarVariant.transparent:
        return [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.close_rounded),
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Close',
            ),
          ),
        ];
    }
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomAppBarVariant.primary:
        return colorScheme.surface;
      case CustomAppBarVariant.transparent:
        return Colors.transparent;
      case CustomAppBarVariant.search:
        return colorScheme.surface;
      case CustomAppBarVariant.profile:
        return colorScheme.surface;
    }
  }

  Color _getForegroundColor(ColorScheme colorScheme) {
    switch (variant) {
      case CustomAppBarVariant.primary:
        return colorScheme.onSurface;
      case CustomAppBarVariant.transparent:
        return colorScheme.onSurface;
      case CustomAppBarVariant.search:
        return colorScheme.onSurface;
      case CustomAppBarVariant.profile:
        return colorScheme.onSurface;
    }
  }

  Color _getTitleColor(ColorScheme colorScheme) {
    return _getForegroundColor(colorScheme);
  }

  double _getElevation() {
    switch (variant) {
      case CustomAppBarVariant.primary:
        return 0;
      case CustomAppBarVariant.transparent:
        return 0;
      case CustomAppBarVariant.search:
        return 2;
      case CustomAppBarVariant.profile:
        return 0;
    }
  }

  Color _getShadowColor(ColorScheme colorScheme) {
    return colorScheme.shadow;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
