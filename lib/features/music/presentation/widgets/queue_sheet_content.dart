import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class QueueSheetContent extends StatelessWidget {
  const QueueSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    final player = getIt<AudioPlayer>();

    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        if (state == null) return const SizedBox.shrink();

        final current = state.currentSource;
        final playlist = state.sequence;

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Header handle bar
              12.vS,
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              18.vS,
              Text(
                context.l10n.queue,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              8.vS,
              const Divider(color: Colors.white12),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final source = playlist[index];
                    final metadata = source.tag as MediaItem;
                    final currentMetadata = current?.tag as MediaItem?;
                    final isCurrent = currentMetadata?.id == metadata.id;

                    return ListTile(
                      onTap: () async {
                        await player.seek(Duration.zero, index: index);
                        if (context.mounted) Navigator.pop(context);
                      },
                      leading: CommonImage(
                        imageUrl: metadata.artUri.toString(),
                        width: 40.w,
                        height: 40.h,
                        borderRadius: 4.0,
                      ),
                      title: Text(
                        metadata.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent ? context.appColors.success : Colors.white,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14.sp,
                        ),
                      ),
                      subtitle: Text(
                        metadata.artist ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent
                              ? context.appColors.success.withValues(alpha: 0.8)
                              : Colors.white54,
                          fontSize: 12.sp,
                        ),
                      ),
                      trailing: isCurrent
                          ? Icon(
                              Icons.volume_up_rounded,
                              color: context.appColors.success,
                              size: 20.r,
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
