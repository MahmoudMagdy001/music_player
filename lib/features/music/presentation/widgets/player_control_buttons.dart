import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class PlayerControlButtons extends StatelessWidget {
  const PlayerControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // ── Shuffle ──────────────────────────────────────────────
        StreamBuilder<bool>(
          stream: player.shuffleModeEnabledStream,
          builder: (context, shuffleSnap) {
            final enabled = shuffleSnap.data ?? false;
            return _IndicatorIconButton(
              icon: Icons.shuffle_rounded,
              size: 22.r,
              active: enabled,
              activeColor: context.appColors.success,
              onPressed: () => player.setShuffleModeEnabled(!enabled),
            );
          },
        ),

        // ── Previous ─────────────────────────────────────────────
        _TapScaleButton(
          onTap: player.seekToPrevious,
          child: Icon(
            Icons.skip_previous_rounded,
            color: Colors.white,
            size: 40.r,
          ),
        ),

        // ── Play / Pause ──────────────────────────────────────────
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, playerStateSnap) {
            final playerState = playerStateSnap.data;
            final playing = playerState?.playing ?? false;
            final processingState = playerState?.processingState;

            if (processingState == ProcessingState.buffering) {
              return SizedBox(
                width: 68.w,
                height: 68.h,
                child: const AppLoading(),
              );
            }

            return _PlayPauseButton(
              playing: playing,
              onTap: () {
                unawaited(HapticFeedback.lightImpact());
                if (playing) {
                  unawaited(player.pause());
                } else {
                  unawaited(player.play());
                }
              },
            );
          },
        ),

        // ── Next ──────────────────────────────────────────────────
        _TapScaleButton(
          onTap: player.seekToNext,
          child: Icon(Icons.skip_next_rounded, color: Colors.white, size: 40.r),
        ),

        // ── Repeat ───────────────────────────────────────────────
        StreamBuilder<LoopMode>(
          stream: player.loopModeStream,
          builder: (context, loopSnap) {
            final loopMode = loopSnap.data ?? LoopMode.off;
            final active = loopMode != LoopMode.off;
            final iconData = loopMode == LoopMode.one
                ? Icons.repeat_one_rounded
                : Icons.repeat_rounded;

            return _IndicatorIconButton(
              icon: iconData,
              size: 22.r,
              active: active,
              activeColor: context.appColors.success,
              onPressed: () {
                if (loopMode == LoopMode.off) {
                  unawaited(player.setLoopMode(LoopMode.all));
                } else if (loopMode == LoopMode.all) {
                  unawaited(player.setLoopMode(LoopMode.one));
                } else {
                  unawaited(player.setLoopMode(LoopMode.off));
                }
              },
            );
          },
        ),
      ],
    );
  }
}

// ── Play/Pause button with radial gradient + shadow ──────────────────────────
class _PlayPauseButton extends StatelessWidget {
  final bool playing;
  final VoidCallback onTap;

  const _PlayPauseButton({required this.playing, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 68.w,
          height: 68.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Colors.white, Color(0xFFDDDDDD)],
              center: Alignment(-0.3, -0.3),
              radius: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.25),
                blurRadius: 20.r,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 12.r,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.black,
            size: 38.r,
          ),
        ),
      );
}

// ── Prev/Next tap-scale button ────────────────────────────────────────────────
class _TapScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _TapScaleButton({required this.child, required this.onTap});

  @override
  State<_TapScaleButton> createState() => _TapScaleButtonState();
}

class _TapScaleButtonState extends State<_TapScaleButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) {
          unawaited(HapticFeedback.lightImpact());
          setState(() => _pressed = true);
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.82 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      );
}

// ── Icon with dot indicator for active state ──────────────────────────────────
class _IndicatorIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final bool active;
  final Color activeColor;
  final VoidCallback onPressed;

  const _IndicatorIconButton({
    required this.icon,
    required this.size,
    required this.active,
    required this.activeColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: 40.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: active ? activeColor : Colors.white54,
                size: size,
              ),
              3.vS,
              AnimatedOpacity(
                opacity: active ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 4.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
