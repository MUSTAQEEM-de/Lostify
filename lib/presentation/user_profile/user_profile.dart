import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/my_reports_card_widget.dart';
import './widgets/personal_info_card_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_card_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "",
    "email": "",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
    "joinDate": "",
    "lostReports": [
      // {
      //   "id": 1,
      //   "name": "iPhone 14 Pro",
      //   "image":
      //       "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      //   "status": "lost"
      // },
      // {
      //   "id": 2,
      //   "name": "Black Leather Wallet",
      //   "image":
      //       "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      //   "status": "lost"
      // },
      // {
      //   "id": 3,
      //   "name": "Blue Backpack",
      //   "image":
      //       "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      //   "status": "lost"
      // },
      // {
      //   "id": 4,
      //   "name": "Car Keys",
      //   "image":
      //       "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      //   "status": "lost"
      // }
    ],
    "foundReports": [
      // {
      //   "id": 1,
      //   "name": "Red Umbrella",
      //   "image":
      //       "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      //   "status": "found"
      // },
      // {
      //   "id": 2,
      //   "name": "Gold Watch",
      //   "image":
      //       "https://images.unsplash.com/photo-1524592094714-0f0654e20314?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      //   "status": "found"
      // }
    ]
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading ? _buildLoadingState() : _buildContent(),
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 4,
        variant: CustomBottomBarVariant.primary,
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.primary, AppTheme.secondary],
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final lostReports = (_userData["lostReports"] as List);
    final foundReports = (_userData["foundReports"] as List);

    final lostThumbnails = lostReports
        .map((dynamic report) =>
            (report as Map<String, dynamic>)["image"] as String)
        .toList();
    final foundThumbnails = foundReports
        .map((dynamic report) =>
            (report as Map<String, dynamic>)["image"] as String)
        .toList();

    return RefreshIndicator(
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ProfileHeaderWidget(
              userName: _userData["name"] as String,
              userEmail: _userData["email"] as String,
              avatarUrl: _userData["avatar"] as String?,
              onAvatarTap: _showAvatarOptions,
            ),
            SizedBox(height: 2.h),
            PersonalInfoCardWidget(
              name: _userData["name"] as String,
              email: _userData["email"] as String,
              joinDate: _userData["joinDate"] as String,
              onSave: _updatePersonalInfo,
            ),
            MyReportsCardWidget(
              title: 'My Lost Reports',
              itemCount: lostReports.length,
              thumbnailUrls: lostThumbnails,
              cardColor: AppTheme.error,
              iconName: 'search_off',
              onViewAll: () => _navigateToMyReports('lost'),
            ),
            MyReportsCardWidget(
              title: 'My Found Reports',
              itemCount: foundReports.length,
              thumbnailUrls: foundThumbnails,
              cardColor: AppTheme.success,
              iconName: 'search',
              onViewAll: () => _navigateToMyReports('found'),
            ),
            SettingsCardWidget(
              onLogout: _handleLogout,
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile refreshed'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  void _showAvatarOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 1.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Change Profile Picture',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAvatarOption(
                    'Camera',
                    'camera_alt',
                    () => _pickImage(ImageSource.camera),
                  ),
                  _buildAvatarOption(
                    'Gallery',
                    'photo_library',
                    () => _pickImage(ImageSource.gallery),
                  ),
                  _buildAvatarOption(
                    'Remove',
                    'delete',
                    _removeAvatar,
                  ),
                ],
              ),
              SizedBox(height: 4.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatarOption(String label, String iconName, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4.w),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: AppTheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _userData["avatar"] = image.path;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile picture updated'),
              backgroundColor: AppTheme.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile picture'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  void _removeAvatar() {
    setState(() {
      _userData["avatar"] = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile picture removed'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  void _updatePersonalInfo(String name, String email) {
    setState(() {
      _userData["name"] = name;
      _userData["email"] = email;
    });
  }

  void _navigateToMyReports(String type) {
    // Navigate to dedicated reports screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $type reports'),
        backgroundColor: AppTheme.primary,
      ),
    );
  }

  void _handleLogout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login-screen',
      (route) => false,
    );
  }
}
