import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LocationInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String) onLocationSelected;

  const LocationInputWidget({
    super.key,
    required this.controller,
    this.errorText,
    required this.onLocationSelected,
  });

  @override
  State<LocationInputWidget> createState() => _LocationInputWidgetState();
}

class _LocationInputWidgetState extends State<LocationInputWidget> {
  bool _showSuggestions = false;
  final List<String> _locationSuggestions = [
    'Central Park, New York',
    'Times Square, New York',
    'Brooklyn Bridge, New York',
    'Empire State Building, New York',
    'Statue of Liberty, New York',
    'Madison Square Garden, New York',
    'Grand Central Terminal, New York',
    'High Line Park, New York',
    'One World Trade Center, New York',
    'Metropolitan Museum of Art, New York',
  ];
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = _locationSuggestions;
  }

  void _filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = _locationSuggestions;
      } else {
        _filteredSuggestions = _locationSuggestions
            .where((location) =>
                location.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _showSuggestions = query.isNotEmpty && _filteredSuggestions.isNotEmpty;
    });
  }

  void _selectLocation(String location) {
    widget.controller.text = location;
    widget.onLocationSelected(location);
    setState(() {
      _showSuggestions = false;
    });
  }

  void _useCurrentLocation() {
    // Simulate getting current location
    const currentLocation = 'Current Location - Manhattan, New York';
    widget.controller.text = currentLocation;
    widget.onLocationSelected(currentLocation);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Using current location'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location *',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: _showSuggestions
                ? [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: widget.controller,
                onChanged: _filterSuggestions,
                onTap: () {
                  if (widget.controller.text.isNotEmpty) {
                    _filterSuggestions(widget.controller.text);
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter location where item was lost',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'location_on',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: _useCurrentLocation,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: 'my_location',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  errorText: widget.errorText,
                  filled: true,
                  fillColor: AppTheme.lightTheme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.error,
                      width: 2,
                    ),
                  ),
                ),
              ),
              if (_showSuggestions) _buildSuggestionsList(),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            CustomIconWidget(
              iconName: 'info_outline',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tap the location icon to use your current location',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(
          left: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          right: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _filteredSuggestions.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
        itemBuilder: (context, index) {
          final suggestion = _filteredSuggestions[index];
          return ListTile(
            dense: true,
            leading: CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 16,
            ),
            title: Text(
              suggestion,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            onTap: () => _selectLocation(suggestion),
          );
        },
      ),
    );
  }
}
