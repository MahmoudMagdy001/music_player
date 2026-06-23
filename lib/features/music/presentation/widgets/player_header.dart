import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PlayerHeader extends StatelessWidget {
  final String? album;
  final VoidCallback onBackTap;

  const PlayerHeader({
    required this.album,
    required this.onBackTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header row ────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back / dismiss button
              _HeaderIconButton(
                icon: Icons.keyboard_arrow_down_rounded,
                size: 30.r,
                onPressed: onBackTap,
              ),

              // Center label
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.player.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                      ),
                    ),
                    3.vS,
                    Text(
                      album ?? 'Single',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // More-options button (visually balanced, no-op for now)
              _HeaderIconButton(
                icon: Icons.more_vert_rounded,
                size: 24.r,
                onPressed: () {},
              ),
            ],
          ),
        ],
      );
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;

  const _HeaderIconButton({
    required this.icon,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(icon, color: Colors.white, size: size),
        onPressed: onPressed,
        splashRadius: 22.r,
      );
}
