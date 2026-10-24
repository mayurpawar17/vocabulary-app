import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/pronounce_word_use_case.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/stop_speech_use_case.dart';

class VocabularyFeedPage extends StatefulWidget {
  const VocabularyFeedPage({
    required this.pronounceWord,
    required this.stopSpeech,
    super.key,
  });

  final PronounceWordUseCase pronounceWord;
  final StopSpeechUseCase stopSpeech;

  @override
  State<VocabularyFeedPage> createState() => _VocabularyFeedPageState();
}

class _VocabularyFeedPageState extends State<VocabularyFeedPage> {
  final List<Map<String, dynamic>> words = [
    {
      'word': 'Abundant',
      'meaning': 'Existing or available in large quantities; overflowing.',
      'example': 'The coastal region has an abundant supply of fresh seafood.',
      'isFavorite': false,
    },
    {
      'word': 'Resilient',
      'meaning':
          'Able to withstand or recover quickly from difficult conditions.',
      'example':
          'She proved to be remarkably resilient after facing major setbacks.',
      'isFavorite': true,
    },
    {
      'word': 'Meticulous',
      'meaning': 'Showing great attention to detail; very careful and precise.',
      'example':
          'He was meticulous in planning every single detail of the expedition.',
      'isFavorite': false,
    },
    {
      'word': 'Ephemeral',
      'meaning': 'Lasting for a very short time; fleeting or transient.',
      'example':
          'The beauty of the cherry blossoms is breathtaking but ephemeral.',
      'isFavorite': false,
    },
    {
      'word': 'Eloquent',
      'meaning': 'Fluent or persuasive in speaking or writing.',
      'example':
          'The guest speaker gave an eloquent address that inspired the audience.',
      'isFavorite': false,
    },
    {
      'word': 'Pragmatic',
      'meaning':
          'Dealing with things sensibly and realistically based on practical considerations.',
      'example': 'We need a pragmatic approach to solve this technical issue.',
      'isFavorite': false,
    },
    {
      'word': 'Candid',
      'meaning': 'Truthful and straightforward; frank and open.',
      'example':
          'During the interview, the director gave a candid evaluation of the project.',
      'isFavorite': false,
    },
    {
      'word': 'Serendipity',
      'meaning':
          'The occurrence of finding valuable or pleasant things by chance.',
      'example':
          'Discovering my favorite book in a tiny secondhand store was pure serendipity.',
      'isFavorite': false,
    },
    {
      'word': 'Tenacious',
      'meaning':
          'Persistent in maintaining, adhering to, or seeking something.',
      'example':
          'Her tenacious spirit helped her finish the marathon despite rainy weather.',
      'isFavorite': false,
    },
    {
      'word': 'Ubiquitous',
      'meaning': 'Present, appearing, or found everywhere at once.',
      'example': 'Smartphones have become ubiquitous in modern daily life.',
      'isFavorite': false,
    },
    {
      'word': 'Voracious',
      'meaning':
          'Having a huge appetite or an excessively eager pursuit of an activity.',
      'example': 'He has been a voracious reader since early childhood.',
      'isFavorite': false,
    },
    {
      'word': 'Lucid',
      'meaning': 'Expressed clearly and easy to understand.',
      'example':
          'The professor gave a lucid explanation of a complex physics principle.',
      'isFavorite': false,
    },
    {
      'word': 'Fortuitous',
      'meaning': 'Happening by a lucky chance or coincidence.',
      'example':
          'Their fortuitous meeting at the conference led to a successful partnership.',
      'isFavorite': false,
    },
    {
      'word': 'Profound',
      'meaning': 'Very great, intense, or possessing deep insight.',
      'example':
          'The documentary had a profound effect on how I view conservation.',
      'isFavorite': false,
    },
    {
      'word': 'Versatile',
      'meaning':
          'Able to adapt or be adapted to many different functions or activities.',
      'example':
          'This software is versatile enough to support both beginners and advanced users.',
      'isFavorite': false,
    },
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _speakWord(String word) async {
    try {
      await widget.pronounceWord.execute(word);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not play pronunciation. Check that a text-to-speech voice is available.',
          ),
        ),
      );
    }
  }

  Future<void> _stopSpeech() async {
    try {
      await widget.stopSpeech.execute();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not stop pronunciation.')),
        );
      }
    }
  }

  @override
  void dispose() {
    unawaited(_stopSpeech());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate dark background
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: words.length,
            onPageChanged: (index) {
              unawaited(_stopSpeech());
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final item = words[index];

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'DAILY WORD',
                                    style: TextStyle(
                                      color: Color(0xFF818CF8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    item['isFavorite']
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: item['isFavorite']
                                        ? Colors.redAccent
                                        : Colors.white60,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      item['isFavorite'] = !item['isFavorite'];
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['word'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Pronounce ${item['word']}',
                                  onPressed: () =>
                                      _speakWord(item['word'] as String),
                                  icon: const Icon(
                                    Icons.volume_up_rounded,
                                    color: Color(0xFF818CF8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              item['meaning'],
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 18,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.05),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.format_quote_rounded,
                                    color: Color(0xFF818CF8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item['example'],
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.65,
                                        ),
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Top Header Counter
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vocabulary',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  '${_currentPage + 1} / ${words.length}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  // tooltip: 'Sign out',
                  onPressed: () => context.push('/profile'),
                  // context.read<AuthBloc>().add(const SignOutRequested()),
                  // icon: const Icon(Icons.logout_rounded, color: Colors.white70),
                  icon: const Icon(Icons.person, color: Colors.white70),
                ),
              ],
            ),
          ),
          // Bottom Swipe Indicator
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: Colors.white.withValues(alpha: 0.4),
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  _currentPage < words.length - 1
                      ? 'Swipe up for next word'
                      : 'End of feed',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
