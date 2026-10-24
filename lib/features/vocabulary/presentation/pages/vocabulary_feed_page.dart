import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/pronounce_word_use_case.dart';
import 'package:vocabulary_app/features/vocabulary/domain/usecases/stop_speech_use_case.dart';

class VocabularyFeedPage extends StatefulWidget {
  const VocabularyFeedPage({
    required this.pronounceWord,
    required this.stopSpeech,
    this.isActive = true,
    super.key,
  });

  final PronounceWordUseCase pronounceWord;
  final StopSpeechUseCase stopSpeech;
  final bool isActive;

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
  final Set<int> _bookmarkedWords = {};

  static const _backgroundColor = Color(0xFFF1ECDF);
  static const _textColor = Color(0xFF24231F);
  static const _secondaryTextColor = Color(0xFF68645B);

  @override
  void didUpdateWidget(covariant VocabularyFeedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive && !widget.isActive) {
      unawaited(_stopSpeech());
    }
  }

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

  Future<void> _showWordDetails(Map<String, dynamic> item) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _backgroundColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          item['word'] as String,
          style: const TextStyle(
            color: _textColor,
            fontFamily: 'serif',
          ),
        ),
        content: Text(
          '${item['meaning']}\n\nExample: ${item['example']}',
          style: const TextStyle(color: _secondaryTextColor, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _copyWord(Map<String, dynamic> item) async {
    final word = item['word'] as String;
    await Clipboard.setData(
      ClipboardData(
        text: '$word\n${item['meaning']}\n\nExample: ${item['example']}',
      ),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Word copied to clipboard.')));
  }

  @override
  void dispose() {
    unawaited(_stopSpeech());
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = words[_currentPage];
    final isFavorite = currentWord['isFavorite'] as bool;
    final isBookmarked = _bookmarkedWords.contains(_currentPage);

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
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
                  final word = item['word'] as String;
                  final meaning = item['meaning'] as String;
                  final example = item['example'] as String;

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32, 28, 32, 16),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        Text(
                          word,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _textColor,
                            fontFamily: 'serif',
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          onPressed: () => _speakWord(word),
                          icon: Icon(
                            Icons.volume_up_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 18,
                          ),
                          label: Text(
                            'Listen',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          meaning,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _textColor,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          example,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: _secondaryTextColor,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    tooltip: 'Word details',
                    onPressed: () => _showWordDetails(words[_currentPage]),
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                  IconButton(
                    tooltip: 'Copy word',
                    onPressed: () => _copyWord(words[_currentPage]),
                    icon: const Icon(Icons.ios_share_outlined),
                  ),
                  IconButton(
                    tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                    onPressed: () {
                      setState(() {
                        words[_currentPage]['isFavorite'] = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite
                          ? Theme.of(context).colorScheme.primary
                          : _textColor,
                    ),
                  ),
                  IconButton(
                    tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark word',
                    onPressed: () {
                      setState(() {
                        if (isBookmarked) {
                          _bookmarkedWords.remove(_currentPage);
                        } else {
                          _bookmarkedWords.add(_currentPage);
                        }
                      });
                    },
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
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
}
