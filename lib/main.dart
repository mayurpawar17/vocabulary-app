import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VocabularyFeed(),
    );
  }
}

class VocabularyFeed extends StatelessWidget {
  VocabularyFeed({super.key});

  final List<Map<String, String>> words = [
    {
      'word': 'Abundant',
      'meaning': 'Existing in large quantities.',
      'example': 'The garden has abundant flowers.',
    },
    {
      'word': 'Resilient',
      'meaning': 'Able to recover quickly.',
      'example': 'She is resilient after setbacks.',
    },
    {
      'word': 'Meticulous',
      'meaning': 'Very careful about details.',
      'example': 'He is meticulous in his work.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: words.length,
        itemBuilder: (context, index) {
          final item = words[index];

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['word']!,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    item['meaning']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Example: ${item['example']}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  const Icon(Icons.keyboard_arrow_up),
                  const Text('Swipe up for the next word'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
