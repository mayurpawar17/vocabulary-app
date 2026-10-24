import 'package:flutter/material.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  static const _questions = [
    (
      word: 'Abundant',
      choices: ['Rare', 'Available in large quantities', 'Temporary'],
      answer: 'Available in large quantities',
    ),
    (
      word: 'Resilient',
      choices: ['Quick to recover', 'Difficult to understand', 'Very precise'],
      answer: 'Quick to recover',
    ),
    (
      word: 'Ephemeral',
      choices: ['Long-lasting', 'Easy to find', 'Short-lived'],
      answer: 'Short-lived',
    ),
  ];

  int _questionIndex = 0;
  String? _selectedChoice;
  bool _isSubmitted = false;
  int _correctAnswers = 0;

  void _submitAnswer() {
    if (_selectedChoice == null) return;

    setState(() {
      _isSubmitted = true;
      if (_selectedChoice == _questions[_questionIndex].answer) {
        _correctAnswers++;
      }
    });
  }

  void _continue() {
    setState(() {
      _questionIndex++;
      _selectedChoice = null;
      _isSubmitted = false;
    });
  }

  void _restart() {
    setState(() {
      _questionIndex = 0;
      _selectedChoice = null;
      _isSubmitted = false;
      _correctAnswers = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _questionIndex == _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF1ECDF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text('Practice'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isComplete
              ? _buildCompletion()
              : _buildQuestion(_questions[_questionIndex]),
        ),
      ),
    );
  }

  Widget _buildQuestion(
    ({String word, List<String> choices, String answer}) question,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Question ${_questionIndex + 1} of ${_questions.length}',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: (_questionIndex + 1) / _questions.length,
          color: primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(height: 40),
        Text(
          'What does this word mean?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          question.word,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        for (final choice in question.choices) ...[
          _buildChoice(choice, question.answer),
          const SizedBox(height: 12),
        ],
        const Spacer(),
        if (_isSubmitted)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _selectedChoice == question.answer
                  ? 'Correct!'
                  : 'The correct answer is: ${question.answer}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: _selectedChoice == question.answer
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        FilledButton(
          onPressed: _isSubmitted
              ? _continue
              : _selectedChoice == null
              ? null
              : _submitAnswer,
          child: Text(_isSubmitted ? 'Next' : 'Check answer'),
        ),
      ],
    );
  }

  Widget _buildChoice(String choice, String correctAnswer) {
    final isSelected = _selectedChoice == choice;
    final isCorrect = choice == correctAnswer;
    final colorScheme = Theme.of(context).colorScheme;

    Color? backgroundColor;
    Color? foregroundColor;
    if (_isSubmitted && isCorrect) {
      backgroundColor = Colors.green.withValues(alpha: 0.12);
      foregroundColor = Colors.green.shade800;
    } else if (_isSubmitted && isSelected) {
      backgroundColor = colorScheme.errorContainer;
      foregroundColor = colorScheme.onErrorContainer;
    } else if (isSelected) {
      backgroundColor = colorScheme.primaryContainer;
      foregroundColor = colorScheme.onPrimaryContainer;
    }

    return OutlinedButton(
      onPressed: _isSubmitted
          ? null
          : () {
              setState(() {
                _selectedChoice = choice;
              });
            },
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(16),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Text(choice),
    );
  }

  Widget _buildCompletion() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.celebration_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text('Practice complete', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('You got $_correctAnswers of ${_questions.length} correct.'),
          const SizedBox(height: 24),
          FilledButton(onPressed: _restart, child: const Text('Try again')),
        ],
      ),
    );
  }
}
