import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:sizer/sizer.dart';

class TermsPrivacyWidget extends StatefulWidget {
  final bool isAccepted;
  final ValueChanged<bool> onChanged;

  const TermsPrivacyWidget({
    super.key,
    required this.isAccepted,
    required this.onChanged,
  });

  @override
  State<TermsPrivacyWidget> createState() => _TermsPrivacyWidgetState();
}

class _TermsPrivacyWidgetState extends State<TermsPrivacyWidget> {
  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text(
            'Terms of Service',
            style: theme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome to Lostify',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'By using Lostify, you agree to the following terms:',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  '1. You will provide accurate information when reporting lost or found items.\n\n'
                  '2. You will not use the service for fraudulent or illegal activities.\n\n'
                  '3. You are responsible for verifying the identity of item owners before returning items.\n\n'
                  '4. Lostify is not liable for any disputes between users.\n\n'
                  '5. We reserve the right to remove inappropriate content.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          title: Text(
            'Privacy Policy',
            style: theme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Privacy Matters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'We collect and use your information as follows:',
                  style: theme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  '• Personal Information: Name, email, and profile data for account management.\n\n'
                  '• Item Data: Photos and descriptions of lost/found items you report.\n\n'
                  '• Location Data: General location information to help match items with users.\n\n'
                  '• Usage Data: App usage statistics to improve our service.\n\n'
                  'We do not sell your personal information to third parties.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: Checkbox(
              value: widget.isAccepted,
              onChanged: (bool? value) {
                widget.onChanged(value ?? false);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _showTermsDialog,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _showPrivacyDialog,
                  ),
                  const TextSpan(text: ' of Lostify.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
