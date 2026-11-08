import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/theme_provider.dart';

class DynamicAppBackground extends StatelessWidget {
  final Widget child;
  final Widget? bottomNavigationBar;

  const DynamicAppBackground({
    super.key,
    required this.child,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: bottomNavigationBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Bottom Layer: Dynamic LinearGradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? const [
                          Color(0xFF0F172A),
                          AppColors.bgDark,
                          AppColors.bgDarkGradientEnd,
                        ]
                      : const [
                          Color(0xFF86D9F7),
                          Color(0xFFD6F3FD),
                          AppColors.bgLight,
                          AppColors.bgLight,
                        ],
                  stops: isDark ? const [0.0, 0.45, 1.0] : const [0.0, 0.22, 0.55, 1.0],
                ),
              ),
            ),
          ),

          // 2. Decorative Top Layer: Anchored SVG Clouds
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Opacity(
                opacity: isDark ? 0.08 : 0.65,
                child: SvgPicture.asset(
                  'assets/svgs/clouds.svg',
                  fit: BoxFit.cover,
                  height: 180,
                  alignment: Alignment.topCenter,
                  colorFilter: isDark
                      ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                      : null,
                ),
              ),
            ),
          ),

          // 3. Content Layer: SafeArea with Adaptive Viewport
          SafeArea(
            bottom: bottomNavigationBar == null,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: child,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
