import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/question_model.dart';

class QuizProvider extends ChangeNotifier {
  String _userName = 'Richard Jonathan';
  int _streakDays = 42;
  int _gems = 2480;
  TrackCategory _selectedCategory = TrackCategory.flutter;

  List<Question> _activeQuestions = [];
  int _currentIndex = 0;
  final Map<int, int> _userAnswers = {};
  int _score = 0;

  Timer? _countdownTimer;
  static const int questionDuration = 24;
  int _remainingSeconds = questionDuration;
  bool _isAnswerSubmitted = false;
  bool _isQuizCompleted = false;

  QuizProvider() {
    _initializeQuestions();
  }

  String get userName => _userName;
  int get streakDays => _streakDays;
  int get gems => _gems;
  TrackCategory get selectedCategory => _selectedCategory;
  List<Question> get activeQuestions => _activeQuestions;
  int get currentIndex => _currentIndex;
  int get remainingSeconds => _remainingSeconds;
  bool get isAnswerSubmitted => _isAnswerSubmitted;
  bool get isQuizCompleted => _isQuizCompleted;
  int get score => _score;
  Map<int, int> get userAnswers => _userAnswers;

  int get totalQuestions => _activeQuestions.isEmpty ? 6 : _activeQuestions.length;
  Question get currentQuestion => _activeQuestions[_currentIndex];
  int? get currentSelectedOption => _userAnswers[_currentIndex];

  bool get isCurrentAnswerCorrect {
    final selected = currentSelectedOption;
    if (selected == null) return false;
    return selected == currentQuestion.correctIndex;
  }

  double get progressRatio =>
      totalQuestions == 0 ? 0.0 : (_currentIndex + 1) / totalQuestions;

  String get formattedTimer =>
      '00:${_remainingSeconds.toString().padLeft(2, '0')}';

  int get scorePercentage =>
      totalQuestions == 0 ? 0 : ((_score / totalQuestions) * 100).round();

  int get brainRotCuredPercentage =>
      totalQuestions == 0 ? 0 : ((_score / totalQuestions) * 100).clamp(15, 100).round();

  String get achievementTier {
    final pct = scorePercentage;
    if (pct >= 90) return 'Flutter Grandmaster 🏆';
    if (pct >= 70) return 'Widget Wizard ⚡';
    if (pct >= 50) return 'Syntax Survivor 🛡️';
    return 'Code Novice 🌱';
  }

  void setUserName(String name) {
    final trimmed = name.trim();
    if (trimmed.isNotEmpty && trimmed != _userName) {
      _userName = trimmed;
      notifyListeners();
    }
  }

  void selectCategory(TrackCategory category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void _initializeQuestions() {
    // Filter questions by category or supply top 6 to match the Duolingo style mockup
    final categoryFiltered = DummyQuestions.questions
        .where((q) => q.category == _selectedCategory)
        .toList();

    if (categoryFiltered.length >= 6) {
      _activeQuestions = categoryFiltered.take(6).toList();
    } else {
      _activeQuestions = List<Question>.from(DummyQuestions.questions.take(6));
    }
  }

  void startQuiz({TrackCategory? category}) {
    if (category != null) {
      _selectedCategory = category;
    }
    _initializeQuestions();
    _currentIndex = 0;
    _userAnswers.clear();
    _score = 0;
    _isAnswerSubmitted = false;
    _isQuizCompleted = false;
    _resetAndStartTimer();
    notifyListeners();
  }

  void selectOption(int optionIndex) {
    if (_isAnswerSubmitted || _isQuizCompleted) return;
    _userAnswers[_currentIndex] = optionIndex;
    _isAnswerSubmitted = true;
    _stopTimer();

    if (optionIndex == currentQuestion.correctIndex) {
      _score++;
      _gems += 10;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < totalQuestions - 1) {
      _currentIndex++;
      _isAnswerSubmitted = _userAnswers.containsKey(_currentIndex);
      _resetAndStartTimer();
      notifyListeners();
    } else {
      _isQuizCompleted = true;
      _stopTimer();
      _streakDays++;
      notifyListeners();
    }
  }

  void retryQuiz() {
    startQuiz(category: _selectedCategory);
  }

  void _resetAndStartTimer() {
    _stopTimer();
    _remainingSeconds = questionDuration;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _stopTimer();
        if (!_isAnswerSubmitted) {
          // Time expired without an answer
          _isAnswerSubmitted = true;
          notifyListeners();
        }
      }
    });
  }

  void _stopTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
