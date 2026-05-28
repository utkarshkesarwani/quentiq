import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';

class QuentiqLogo extends StatelessWidget {
  const QuentiqLogo({
    super.key,
    this.size = 72,
    this.showGlow = true,
    this.compact = false,
  });

  final double size;
  final bool showGlow;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.45;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.gradientPrimary,
            borderRadius: BorderRadius.circular(size * 0.28),
            boxShadow: showGlow
                ? [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.45),
                      blurRadius: size * 0.5,
                      spreadRadius: size * 0.02,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        if (!compact) ...[
          SizedBox(height: size * 0.22),
          Text(
            'Quentiq',
            style: TextStyle(
              fontSize: size * 0.38,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkText
                  : AppColors.lightText,
            ),
          ),
          if (!compact)
            Text(
              'Smart living, resolved',
              style: TextStyle(
                fontSize: size * 0.16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkMuted
                    : AppColors.lightMuted,
              ),
            ),
        ],
      ],
    );
  }
}
