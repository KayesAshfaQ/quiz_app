import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/scoreboard_provider.dart';
import 'package:quiz_app/models/scoreboard_entry.dart';

import '../app_route.dart';
import '../widgets/score_card_widget.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ScoreboardProvider>().fetchNextGlobalPage();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ScoreboardProvider>().fetchNextGlobalPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<ScoreboardProvider>(
      builder: (context, scoreboard, child) {
        final history = scoreboard.history;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: colorScheme.inversePrimary,
            title: const Text('Scoreboard'),
            actions: [
              if (history.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  tooltip: 'Clear History',
                  onPressed: () {} /* => _confirmClear(context, scoreboard) */,
                ),
            ],
          ),
          body:
              scoreboard.globalScores.isEmpty &&
                  scoreboard.isLoadingGlobalScores
              ? const Center(child: CircularProgressIndicator())
              : Builder(
                  builder: (context) {
                    final history = scoreboard.globalScores;

                    if (history.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.leaderboard_outlined,
                                size: 72,
                                color: colorScheme.outline.withValues(
                                  alpha: 0.5,
                                ),
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
                              TextButton(
                                onPressed: () {
                                  scoreboard.fetchNextGlobalPage(refresh: true);
                                },
                                child: const Text('Refresh'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Display results here using ListView or similar widget
                    return RefreshIndicator(
                      onRefresh: () => scoreboard.onRefreshGlobalScores(),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            scoreboard.globalScores.length +
                            (scoreboard.hasMoreGlobalScores ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index >= scoreboard.globalScores.length) {
                            // Show a loading indicator at the end of the list
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final score = scoreboard.globalScores[index];

                          return ScoreCardWidget(entry: score);
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
