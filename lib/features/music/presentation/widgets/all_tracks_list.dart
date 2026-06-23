import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';
import 'package:music_player/features/music/domain/entities/song.dart';

class AllTracksList extends StatelessWidget {
  final List<Song> filteredSongs;
  final List<Song> allSongs;
  final ValueChanged<int> onSongTap;

  const AllTracksList({
    required this.filteredSongs,
    required this.allSongs,
    required this.onSongTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (filteredSongs.isEmpty) return const SizedBox.shrink();

    return AppUnifiedSection(
      title: 'All Tracks',
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredSongs.length,
        itemBuilder: (context, idx) {
          final song = filteredSongs[idx];
          final originalIndex = allSongs.indexOf(song);
          return Container(
            margin: EdgeInsets.only(bottom: 8.h),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => onSongTap(originalIndex),
              leading: CommonImage(
                imageUrl: song.imageUrl,
                width: 50.w,
                height: 50.h,
                borderRadius: 6.0,
              ),
              title: Text(
                song.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                song.artist,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12.sp,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: Colors.white54,
                ),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
