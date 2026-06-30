import 'package:flutter/material.dart';

class PodiumAvatar extends StatelessWidget {
  final String displayName;
  final int score;
  final int rank;

  const PodiumAvatar({
    super.key,
    required this.displayName,
    required this.score,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (rank == 1)
          Icon(Icons.workspace_premium, color: Colors.amber, size: 30),

        Text(
          displayName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withValues(alpha: 0.9),
          ),
          child: Text(
            'Score: $score',
            style: const TextStyle(fontSize: 14, color: Colors.purple),
          ),
        ),
      ],
    );
  }
}
