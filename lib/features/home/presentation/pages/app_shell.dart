import 'package:flutter/material.dart';
import 'package:vocabulary_app/features/auth/presentation/pages/profile_page.dart';
import 'package:vocabulary_app/features/practice/presentation/pages/practice_page.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/pronounce_word_use_case.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/stop_speech_use_case.dart';
import 'package:vocabulary_app/features/vocabulary/presentation/pages/vocabulary_feed_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    required this.pronounceWord,
    required this.stopSpeech,
    this.initialIndex = 0,
    super.key,
  });

  final PronounceWordUseCase pronounceWord;
  final StopSpeechUseCase stopSpeech;
  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          VocabularyFeedPage(
            pronounceWord: widget.pronounceWord,
            stopSpeech: widget.stopSpeech,
            isActive: _selectedIndex == 0,
          ),
          const PracticePage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz_rounded),
            label: 'Practice',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
