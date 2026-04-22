import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final String fallback;
  final double size;
  const Avatar({
    super.key,
    this.url,
    required this.fallback,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(fallback);
    final placeholder = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceAlt,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (url == null || url!.isEmpty) return placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.isEmpty ? '?' : parts[0].substring(0, 1).toUpperCase();
  }
}
