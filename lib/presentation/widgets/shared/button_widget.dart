import 'package:flutter/material.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';

enum ButtonSize { large, medium, small, tiny }

enum ButtonType { primary, secondary, disabled, white }

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final ButtonSize size;
  final ButtonType type;
  final double? width;

  const ButtonWidget({
    super.key,
    required this.text,
    this.onTap,
    this.size = ButtonSize.medium,
    this.type = ButtonType.primary,
    this.width,
  });

  double _getHeight() {
    switch (size) {
      case ButtonSize.large: return 56;
      case ButtonSize.medium: return 48;
      case ButtonSize.small: return 45;
      case ButtonSize.tiny: return 32;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.large: return 16;
      case ButtonSize.medium: return 14;
      case ButtonSize.small: return 12;
      case ButtonSize.tiny: return 12;
    }
  }


  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary: return PrimaryColor.primary100;
      case ButtonType.secondary: return Colors.transparent;
      case ButtonType.disabled: return GrayColor.grey40;
      case ButtonType.white: return Colors.white;
    }
  }


  Color _getTextColor() {
    switch (type) {
      case ButtonType.primary: return Colors.white;
      case ButtonType.secondary: return PrimaryColor.primary100;
      case ButtonType.disabled: return GrayColor.grey60;
      case ButtonType.white: return PrimaryColor.primary100;
    }
  }

  BoxBorder? _getBorder() {
    if (type == ButtonType.secondary) {
      return Border.all(color: PrimaryColor.primary100, width: 1.5);
    } else if (type == ButtonType.disabled) {
      return Border.all(color: GrayColor.grey40, width: 1);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = type == ButtonType.disabled || onTap == null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          constraints: BoxConstraints(
            minWidth: width ?? (size == ButtonSize.tiny ? 70 : 120),
            minHeight: _getHeight(),
          ),
          width: width,
          height: _getHeight(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            border: _getBorder(),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyleManager.interMedium14.copyWith(
                fontSize: _getFontSize(),
                color: _getTextColor(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}