import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

final class Screen extends StatelessWidget {
  const Screen({
    required this.child,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.isScrollable = false,
    this.padding = const EdgeInsets.all(AppSpacing.space20),
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final bool isScrollable;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final content = isScrollable
        ? SingleChildScrollView(
            padding: padding,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: child,
          )
        : Padding(padding: padding, child: child);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: appBar == null,
        bottom: bottomNavigationBar == null,
        child: content,
      ),
    );
  }
}
