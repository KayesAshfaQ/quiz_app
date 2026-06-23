import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/scoreboard_entry.dart';
import '../providers/auth_provider.dart';
import '../providers/scoreboard_provider.dart';
import '../widgets/score_card_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    // Load the user's profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      context.read<AuthProvider>().loadUserProfile(uid ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout action
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authProvider.user?.displayName ?? 'unknown',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              authProvider.user?.email ?? 'N/A',
              style: TextStyle(fontSize: 18),
            ),

            Expanded(
              child: FutureBuilder<List<ScoreboardEntry>>(
                future: context.read<ScoreboardProvider>().loadPersonalResults(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading results: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final history = snapshot.data ?? [];

                    if (history.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.leaderboard_outlined,
                              size: 72,
                              color: colorScheme.outline.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No Scores Recorded Yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Complete a quiz to record your score here and track your learning progress!',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    // Display results here using ListView or similar widget
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: history.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final score = history[index];

                        return ScoreCardWidget(entry: score);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
