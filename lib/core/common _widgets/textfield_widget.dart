import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taskmanager/core/theme/app_colors.dart';
import 'package:taskmanager/core/theme/app_theme.dart';

class CommonTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged? onChange;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final int? maxLength;
  final bool? enabled;
  final int? maxline;
  final Color? hintColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle;
  final FocusNode? focusNode;
  final bool underlinedBorder;
  final bool noBorder;
  final int? minLines;
  final Color? borderColor;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets? contentPadding;
  final Color? fillcolor;
  final Color? textColor;

  const CommonTextFormField({
    required this.hintText,
    this.borderColor,
    this.controller,
    this.validator,
    this.onChange,
    this.keyboardType,
    this.textInputAction,
    this.prefix,
    this.maxLength,
    this.obscureText = false,
    this.underlinedBorder = false,
    this.noBorder = false,
    this.enabled = true,
    Key? key,
    this.maxline = 1,
    this.minLines,
    this.suffix,
    this.hintColor,
    this.inputFormatters,
    this.hintStyle,
    this.focusNode,
    this.onFieldSubmitted,
    this.contentPadding,
    this.fillcolor = AppColors.surface,
    this.textColor = AppColors.textPrimary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      style: AppTheme.bodyText2.copyWith(
        color: textColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      enabled: enabled,
      minLines: minLines,
      maxLines: maxline,
      maxLength: maxLength,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
      onChanged: onChange,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.border,
      decoration: InputDecoration(
        errorMaxLines: 2,
        suffixIcon: suffix,
        filled: true,
        prefixIcon: prefix,
        fillColor: fillcolor,
        focusedBorder: fieldBorder(),
        enabledBorder: fieldBorder(),
        errorBorder: fieldBorder(),
        disabledBorder: fieldBorder(),
        border: fieldBorder(),
        focusedErrorBorder: fieldBorder(),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 19, vertical: 12),
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle ??
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: hintColor ?? Colors.black.withOpacity(0.44),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
        counterText: "",
      ),
    );
  }

  InputBorder fieldBorder() => noBorder
      ? InputBorder.none
      : underlinedBorder
          ? const UnderlineInputBorder()
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: borderColor ?? const Color(0xFF808080)),
            );
}
