import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field_v2/intl_phone_field.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';

// -----------------------------------------------------------
// 1. TEXT FIELD WIDGET (Supports Validation)
// -----------------------------------------------------------

class TextFieldWidget extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.onChanged,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isEmpty = true;

  void _handleOnChanged(String value) {
    setState(() {
      _isEmpty = value.isEmpty;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword,
        onChanged: _handleOnChanged,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        style: TextStyleManager.interSemiBold16.copyWith(
          color: GrayColor.grey100,
        ),

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyleManager.interMedium16.copyWith(
            color: GrayColor.grey60,
          ),
          fillColor: Secondary.form,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 20.0,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: GrayColor.grey30),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _isEmpty ? Secondary.fillRed : PrimaryColor.primary100,
              width: 1.5,
            ),
          ),
          errorStyle: const TextStyle(color: Secondary.fillRed, fontSize: 12),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------
// 2. PHONE NUMBER FIELD WIDGET
// -----------------------------------------------------------

class PhoneNumberFieldWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const PhoneNumberFieldWidget({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
  });

  @override
  State<PhoneNumberFieldWidget> createState() => _PhoneNumberFieldWidgetState();
}

class _PhoneNumberFieldWidgetState extends State<PhoneNumberFieldWidget> {
  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: IntlPhoneField(
        controller: widget.controller,
        initialCountryCode: 'EG',

        style: TextStyleManager.interSemiBold16.copyWith(
          color: GrayColor.grey100,
        ),

        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyleManager.interMedium16.copyWith(
            color: GrayColor.grey60,
          ),
          fillColor: Secondary.form,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 20.0,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: GrayColor.grey30),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: GrayColor.grey30),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: _isEmpty ? Secondary.fillRed : PrimaryColor.primary100,
              width: 1.5,
            ),
          ),
          counterText: "",
        ),

        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        keyboardType: TextInputType.phone,

        onChanged: (phone) {
          final numberIsEmpty = phone.number.trim().isEmpty;
          setState(() {
            _isEmpty = numberIsEmpty;
          });

          if (widget.onChanged != null) {
            widget.onChanged!(phone.completeNumber);
          }
        },
      ),
    );
  }
}
