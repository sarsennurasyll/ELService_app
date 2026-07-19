import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';

final class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.isMultiline = false,
    this.isPassword = false,
    this.isEnabled = true,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool isMultiline;
  final bool isPassword;
  final bool isEnabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

final class _AppTextFieldState extends State<AppTextField> {
  var _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final suffixIcon = widget.isPassword
        ? IconButton(
            onPressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
            color: AppColors.mutedForeground,
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
          )
        : widget.suffixIcon;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label case final label?) ...[
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
          const SizedBox(height: AppSpacing.space8),
        ],
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.isEnabled,
          obscureText: widget.isPassword && !_isPasswordVisible,
          enableSuggestions: !widget.isPassword,
          autocorrect: !widget.isPassword,
          keyboardType:
              widget.keyboardType ??
              (widget.isMultiline ? TextInputType.multiline : null),
          textInputAction: widget.textInputAction,
          minLines: widget.isMultiline ? null : 1,
          maxLines: widget.isMultiline ? null : 1,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: suffixIcon,
            errorText: widget.errorText,
            errorStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderSide: BorderSide(color: color),
    );
  }
}
