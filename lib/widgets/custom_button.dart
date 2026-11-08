import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';

enum ButtonVariant { primary, secondary, outline }

class Custom3DButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final double? width;
  final double height;
  final double fontSize;

  const Custom3DButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.width,
    this.height = 54,
    this.fontSize = 15,
  });

  @override
  State<Custom3DButton> createState() => _Custom3DButtonState();
}

class _Custom3DButtonState extends State<Custom3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPrimary = widget.variant == ButtonVariant.primary;
    final isOutline = widget.variant == ButtonVariant.outline;

    final Color topColor = isPrimary
        ? AppColors.accent
        : (isOutline
            ? (isDark ? AppColors.cardDark : Colors.white)
            : (isDark ? AppColors.cardDark : AppColors.accentLight));

    final Color bottomShadowColor = isPrimary
        ? AppColors.accentDark
        : (isOutline
            ? (isDark ? const Color(0xFF161E2E) : const Color(0xFFE2EDF4))
            : (isDark ? const Color(0xFF201625) : const Color(0xFFF7C2DE)));

    final Color textColor = isPrimary
        ? Colors.white
        : AppColors.accent;

    const double depth = 4.0;
    final double offset = _isPressed ? depth : 0.0;

    return Semantics(
      button: true,
      label: widget.text,
      child: GestureDetector(
        onTapDown: widget.onPressed == null ? null : (_) => setState(() => _isPressed = true),
        onTapUp: widget.onPressed == null
            ? null
            : (_) {
                setState(() => _isPressed = false);
                widget.onPressed!();
              },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 70),
          width: widget.width,
          height: widget.height,
          transform: Matrix4.translationValues(0, offset, 0),
          decoration: BoxDecoration(
            color: topColor,
            borderRadius: BorderRadius.circular(widget.height / 2),
            border: isOutline
                ? Border.all(
                    color: AppColors.accent.withValues(alpha: 0.35),
                    width: 1.5,
                  )
                : null,
            boxShadow: [
              if (!_isPressed)
                BoxShadow(
                  color: bottomShadowColor,
                  offset: const Offset(0, depth),
                  blurRadius: 0,
                ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: widget.fontSize + 2,
                    color: textColor,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: textColor,
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
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
