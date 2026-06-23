import 'package:flutter/material.dart';
import 'package:music_player/core/imports/core_imports.dart';
import 'package:music_player/core/imports/packages_imports.dart';

class NetworkStatusBar extends StatelessWidget {
  const NetworkStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final internetService = getIt<InternetConnectionService>();

    return StreamBuilder<NetworkState>(
      stream: internetService.networkStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data ?? NetworkState.connected;
        if (state == NetworkState.disconnected) {
          return Container(
            width: double.infinity,
            color: context.colors.error,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off_rounded,
                    color: Colors.white,
                    size: 16.r,
                  ),
                  8.hS,
                  Text(
                    context.l10n.offlineMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state == NetworkState.unstable) {
          return Container(
            width: double.infinity,
            color: context.appColors.warning,
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 16.r,
                  ),
                  8.hS,
                  Text(
                    context.l10n.unstableMessage,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
