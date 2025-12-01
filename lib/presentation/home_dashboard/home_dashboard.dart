import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../services/database_service.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/action_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/recent_activity_item_widget.dart';
import './widgets/stats_widget.dart';
import '../../widgets/custom_icon_widget.dart';

import 'package:image_picker/image_picker.dart';
import '../../services/storage_service.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  int _currentBottomIndex = 0;
  bool _isRefreshing = false;

  final List<Map<String, dynamic>> _recentActivity = [];

  // Initialize DatabaseService
  final DatabaseService dbService = DatabaseService();

  final picker = ImagePicker();
  final storage = StorageService();

  void _testUpload() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final url = await storage.uploadXFile(picked, "uid_test_123");
    print("Uploaded URL: $url");
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Lostify',
        variant: CustomAppBarVariant.primary,
        automaticallyImplyLeading: false,
        onSearchTap: () => _handleSearch(),
        notificationCount: 3,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(),
                SizedBox(height: 2.h),
                _buildActionCards(),
                SizedBox(height: 2.h),

                // 🔥 TEST BUTTONS REMOVED COMPLETELY 🔥

                SizedBox(height: 2.h),
                _buildStatsSection(),
                SizedBox(height: 2.h),
                _buildRecentActivitySection(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: (index) => setState(() => _currentBottomIndex = index),
        variant: CustomBottomBarVariant.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showReportOptions(),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 6.w,
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Help your community find what matters most',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards() {
    return Column(
      children: [
        ActionCardWidget(
          title: 'Report Lost Item',
          description: 'Lost something? Let the community help you find it',
          iconName: 'search',
          onTap: () => Navigator.pushNamed(context, '/report-lost-item'),
          backgroundColor: AppTheme.error.withValues(alpha: 0.05),
        ),
        ActionCardWidget(
          title: 'Report Found Item',
          description: 'Found something? Help return it to its owner',
          iconName: 'check_circle',
          onTap: () => Navigator.pushNamed(context, '/report-lost-item'),
          backgroundColor: AppTheme.success.withValues(alpha: 0.05),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return StatsWidget(
      totalReported: 1247,
      totalRecovered: 892,
    );
  }

  Widget _buildRecentActivitySection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () => _handleViewAll(),
                child: Text(
                  'View All',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        _recentActivity.isEmpty
            ? EmptyStateWidget(
                onReportTap: () => _showReportOptions(),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _recentActivity.length,
                itemBuilder: (context, index) {
                  final item = _recentActivity[index];
                  return RecentActivityItemWidget(
                    item: item,
                    onTap: () => _handleItemTap(item),
                    onLongPress: () => _showItemOptions(item),
                  );
                },
              ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isRefreshing = false);
  }

  void _handleSearch() {
    showSearch(context: context, delegate: _ItemSearchDelegate());
  }

  void _handleViewAll() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Browse all items feature coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleItemTap(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item['name'] ?? 'Item Details'),
        content: Text(item['description'] ?? 'No description'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showItemOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('View Details'), onTap: () => _handleItemTap(item)),
            ListTile(title: const Text('Contact Reporter'), onTap: () {}),
            ListTile(title: const Text('Share'), onTap: () {}),
          ],
        ),
      ),
    );
  }

  void _showReportOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text('Report Lost Item'), onTap: () {}),
            ListTile(title: const Text('Report Found Item'), onTap: () {}),
          ],
        ),
      ),
    );
  }
}

// ---------------------- Search Delegate ----------------------

class _ItemSearchDelegate extends SearchDelegate<String> {
  final List<String> _searchHistory = ['iPhone', 'Wallet', 'Keys', 'Backpack', 'Watch'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('Search results for "$query"'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? _searchHistory
        : _searchHistory.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          showResults(context);
        },
      ),
    );
  }
}
