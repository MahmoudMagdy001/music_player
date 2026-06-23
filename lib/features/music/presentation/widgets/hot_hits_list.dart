import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/domain/entities/song.dart';

class HotHitsList extends StatelessWidget {
  final List<Song> filteredSongs;
  final List<Song> allSongs;
  final ValueChanged<int> onSongTap;

  const HotHitsList({
    required this.filteredSongs,
    required this.allSongs,
    required this.onSongTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredSongs.isEmpty) return const SizedBox.shrink();

    return AppUnifiedSection(
      title: 'Hot Hits',
      child: SizedBox(
        height: 160.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredSongs.length,
          itemBuilder: (context, idx) {
            final song = filteredSongs[idx];
            final originalIndex = allSongs.indexOf(song);
            return Container(
              width: 110.w,
              margin: EdgeInsets.only(right: 12.w),
              child: AppUnifiedCard(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                onTap: () => onSongTap(originalIndex),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonImage(
                      imageUrl: song.imageUrl,
                      width: 110.w,
                      height: 100.h,
                    ),
                    8.vS,
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
                        color: Colors.white54,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
