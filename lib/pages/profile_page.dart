import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/widgets/score_card_widget.dart';

import '../providers/auth_provider.dart';
import '../providers/scoreboard_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      context.read<AuthProvider>().loadUserProfile(uid ?? '');
      context.read<ScoreboardProvider>().loadPersonalResults();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF6B58E9),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      context.read<AuthProvider>().logout();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Main White Container
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 60,
                        left: 24,
                        right: 24,
                      ),
                      child: Column(
                        children: [
                          // User Name
                          Text(
                            authProvider.user?.displayName ?? 'Madelyn Dias',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Stats Card
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6B58E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  Icons.star_border,
                                  'POINTS',
                                  '590',
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                _buildStatItem(
                                  Icons.public,
                                  'WORLD RANK',
                                  '#1,438',
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                _buildStatItem(
                                  Icons.local_police_outlined,
                                  'LOCAL RANK',
                                  '#56',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Tabs
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Badge',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Stats',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                children: [
                                  const Text(
                                    'Details',
                                    style: TextStyle(
                                      color: Color(0xFF6B58E9),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const CircleAvatar(
                                    radius: 3,
                                    backgroundColor: Color(0xFF6B58E9),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Recent Matches Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Recent matches',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C2C2C),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                child: Selector<ScoreboardProvider, String>(
                                  selector: (_, provider) =>
                                      provider.selectedProfileFilter,
                                  builder:
                                      (
                                        BuildContext context,
                                        String value,
                                        Widget? child,
                                      ) {
                                        return PopupMenuButton<String>(
                                          initialValue: value,
                                          child: Row(
                                            children: [
                                              Text(
                                                value,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 16,
                                              ),
                                            ],
                                          ),
                                          onSelected: (value) {
                                            context
                                                    .read<ScoreboardProvider>()
                                                    .selectedProfileFilter =
                                                value;

                                            /* setState(() {
                                              _selectedFilter = value;
                                              _personalResultsFuture = context
                                                  .read<ScoreboardProvider>()
                                                  .loadPersonalResults(
                                                    filter: _selectedFilter,
                                                  );
                                            }); */
                                          },
                                          itemBuilder: (context) => const [
                                            PopupMenuItem(
                                              value: 'Daily',
                                              child: Text('Daily'),
                                            ),
                                            PopupMenuItem(
                                              value: 'Monthly',
                                              child: Text('Monthly'),
                                            ),
                                            PopupMenuItem(
                                              value: 'Yearly',
                                              child: Text('Yearly'),
                                            ),
                                            PopupMenuItem(
                                              value: 'All',
                                              child: Text('All'),
                                            ),
                                          ],
                                        );
                                      },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Matches List
                          Expanded(
                            child: Consumer<ScoreboardProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoadingPersonalHistory) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                final history = provider.personalHistory;

                                if (history.isEmpty) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 50),
                                      const Text(
                                        'No recent matches found.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ScoreboardProvider>()
                                              .loadPersonalResults();
                                        },
                                        child: const Text('refresh'),
                                      ),
                                    ],
                                  );
                                }

                                if (history.isEmpty) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 50),
                                      const Text(
                                        'No recent matches found.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () {
                                          context
                                              .read<ScoreboardProvider>()
                                              .loadPersonalResults();
                                        },
                                        child: const Text('refresh'),
                                      ),
                                    ],
                                  );
                                }

                                return ListView.builder(
                                  itemCount: history.length,
                                  itemBuilder: (context, index) {
                                    final score = history[index];

                                    return ScoreCardWidget(entry: score);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Avatar Widget (Positioned to overlap)
                  Positioned(
                    top: -50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 46,
                              backgroundColor: Color(0xFFF0EFFF),
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Color(0xFF6B58E9),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.flag,
                                  size: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
