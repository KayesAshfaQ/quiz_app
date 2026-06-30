import 'package:flutter/material.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';
import 'package:quiz_app/widgets/podium_avatar.dart';

import 'podium_painter.dart';

class PodiumWidget extends StatelessWidget {
  final List<ScoreboardEntry> topUsers;

  const PodiumWidget({super.key, required this.topUsers});

  @override
  Widget build(BuildContext context) {
    final firstPlace = topUsers.isNotEmpty ? topUsers[0] : null;
    final secondPlace = topUsers.length > 1 ? topUsers[1] : null;
    final thirdPlace = topUsers.length > 2 ? topUsers[2] : null;

    final baseColor = Theme.of(context).colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final podiumHeight = constraints.maxHeight.isInfinite
            ? constraints.maxWidth * 0.5
            : constraints.maxHeight * 0.5;

        return Stack(
          children: [
            SizedBox(height: podiumHeight + 120, width: constraints.maxWidth),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomPaint(
                size: Size(constraints.maxWidth, podiumHeight),
                painter: PodiumPainter(
                  firstPlaceColor: baseColor,
                  secondPlaceColor: baseColor,
                  thirdPlaceColor: baseColor,
                ),
              ),
            ),

            // 2nd Place
            if (secondPlace != null)
              Positioned(
                left: 0,
                bottom: podiumHeight * 0.7,
                width: constraints.maxWidth / 3,
                child: Center(
                  child: PodiumAvatar(
                    displayName: secondPlace.displayName ?? 'Unknown',
                    score: secondPlace.correctCount,
                    rank: 2,
                  ),
                ),
              ),
            // 1st Place
            if (firstPlace != null)
              Positioned(
                left: constraints.maxWidth / 3,
                bottom: podiumHeight + 20,
                width: constraints.maxWidth / 3,
                child: Center(
                  child: PodiumAvatar(
                    displayName: firstPlace.displayName ?? 'Unknown',
                    score: firstPlace.correctCount,
                    rank: 1,
                  ),
                ),
              ),
            // 3rd Place
            if (thirdPlace != null)
              Positioned(
                right: 0,
                bottom: podiumHeight * 0.5,
                width: constraints.maxWidth / 3 - 28,
                child: Center(
                  child: PodiumAvatar(
                    displayName: thirdPlace.displayName ?? 'Unknown',
                    score: thirdPlace.correctCount,
                    rank: 3,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
