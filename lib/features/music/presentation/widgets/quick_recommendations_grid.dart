import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/domain/entities/song.dart';

class QuickRecommendationsGrid extends StatelessWidget {
  final List<Song> filteredSongs;
  final List<Song> allSongs;
  final ValueChanged<int> onSongTap;

  const QuickRecommendationsGrid({
    required this.filteredSongs,
    required this.allSongs,
    required this.onSongTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final displaySongs = filteredSongs.take(4).toList();
    if (displaySongs.isEmpty) return const SizedBox.shrink();

    return AppUnifiedSection(
      title: 'Quick Recommendations',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displaySongs.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 2.8,
        ),
        itemBuilder: (context, gridIdx) {
          final song = displaySongs[gridIdx];
          final originalIndex = allSongs.indexOf(song);
          return AppUnifiedCard(
            padding: EdgeInsets.zero,
            onTap: () => onSongTap(originalIndex),
            child: Row(
              children: [
                CommonImage(
                  imageUrl: song.imageUrl,
                  width: 55.w,
                  height: double.infinity,
                  borderRadius: 4.0,
                ),
                8.hS,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      2.vS,
                      Text(
                        song.artist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.play_circle_fill_rounded,
                  color: context.appColors.success,
                  size: 24.r,
                ),
                8.hS,
              ],
            ),
          );
        },
      ),
    );
  }
}
