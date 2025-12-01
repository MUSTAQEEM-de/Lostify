
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/app_export.dart';
import './widgets/date_picker_widget.dart';
import './widgets/image_upload_widget.dart';
import './widgets/location_input_widget.dart';

class ReportLostItem extends StatefulWidget {
  const ReportLostItem({super.key});

  @override
  State<ReportLostItem> createState() => _ReportLostItemState();
}

class _ReportLostItemState extends State<ReportLostItem> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDate;
  List<XFile> _selectedImages = [];
  bool _isSubmitting = false;

  // Error states
  String? _itemNameError;
  String? _descriptionError;
  String? _locationError;
  String? _dateError;

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _itemNameError = null;
      _descriptionError = null;
      _locationError = null;
      _dateError = null;
    });

    if (_itemNameController.text.trim().isEmpty) {
      setState(() {
        _itemNameError = 'Item name is required';
      });
      isValid = false;
    }

    if (_descriptionController.text.trim().isEmpty) {
      setState(() {
        _descriptionError = 'Description is required';
      });
      isValid = false;
    } else if (_descriptionController.text.trim().length < 10) {
      setState(() {
        _descriptionError = 'Description must be at least 10 characters';
      });
      isValid = false;
    }

    if (_locationController.text.trim().isEmpty) {
      setState(() {
        _locationError = 'Location is required';
      });
      isValid = false;
    }

    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Date lost is required';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _submitReport() async {
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Lost item report submitted successfully!'),
              ],
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );

        // Navigate back to home dashboard
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Report Lost Item',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
              AppTheme.lightTheme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              CustomIconWidget(
                                iconName: 'search_off',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 48,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Help us help you find your lost item',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Provide detailed information to increase the chances of recovery',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 32),

                        // Item Name Field
                        Text(
                          'Item Name *',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _itemNameController,
                          decoration: InputDecoration(
                            hintText: 'e.g., iPhone 14, Black Wallet, Keys',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(12),
                              child: CustomIconWidget(
                                iconName: 'inventory_2',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                            errorText: _itemNameError,
                          ),
                          onChanged: (value) {
                            if (_itemNameError != null) {
                              setState(() {
                                _itemNameError = null;
                              });
                            }
                          },
                        ),

                        SizedBox(height: 24),

                        // Description Field
                        Text(
                          'Description *',
                          style: AppTheme.lightTheme.textTheme.titleMedium,
                        ),
                        SizedBox(height: 12),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText:
                                'Describe your item in detail (color, size, brand, distinctive features, etc.)',
                            alignLabelWithHint: true,
                            errorText: _descriptionError,
                          ),
                          onChanged: (value) {
                            if (_descriptionError != null) {
                              setState(() {
                                _descriptionError = null;
                              });
                            }
                          },
                        ),

                        SizedBox(height: 24),

                        // Location Field
                        LocationInputWidget(
                          controller: _locationController,
                          errorText: _locationError,
                          onLocationSelected: (location) {
                            if (_locationError != null) {
                              setState(() {
                                _locationError = null;
                              });
                            }
                          },
                        ),

                        SizedBox(height: 24),

                        // Date Picker
                        DatePickerWidget(
                          selectedDate: _selectedDate,
                          errorText: _dateError,
                          onDateSelected: (date) {
                            setState(() {
                              _selectedDate = date;
                              _dateError = null;
                            });
                          },
                        ),

                        SizedBox(height: 24),

                        // Image Upload
                        ImageUploadWidget(
                          selectedImages: _selectedImages,
                          onImagesSelected: (images) {
                            setState(() {
                              _selectedImages = images;
                            });
                          },
                        ),

                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppTheme.lightTheme.colorScheme.primary,
                        foregroundColor:
                            AppTheme.lightTheme.colorScheme.onPrimary,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Submitting...',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'send',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Submit Report',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelLarge
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
