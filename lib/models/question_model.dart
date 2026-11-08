enum TrackCategory {
  flutter('Flutter', 'assets/mascots/mascot_welcome.png'),
  dart('Dart', 'assets/mascots/mascot_quiz.png'),
  mobileUx('Mobile UX', 'assets/mascots/mascot_celebrate.png'),
  widgetLifecycle('Widget Life Cycle', 'assets/mascots/mascot_quiz.png'),
  stateManagement('State Management', 'assets/mascots/mascot_welcome.png');

  final String label;
  final String assetPath;
  const TrackCategory(this.label, this.assetPath);
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final TrackCategory category;
  final String difficulty;

  const Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.category,
    this.difficulty = 'Medium',
  });
}

class DummyQuestions {
  static const List<Question> questions = [
    Question(
      id: 'q1',
      questionText: 'Which widget is used to create a column layout in Flutter?',
      options: ['Row', 'Column', 'Stack', 'Container'],
      correctIndex: 1,
      explanation: 'Column displays its children vertically, which is perfect for building a vertical layout in Flutter.',
      category: TrackCategory.flutter,
      difficulty: 'Easy',
    ),
    Question(
      id: 'q2',
      questionText: 'Which method is called only once when a StatefulWidget is inserted into the tree?',
      options: ['build()', 'initState()', 'didUpdateWidget()', 'dispose()'],
      correctIndex: 1,
      explanation: 'initState() is called exactly once when the State object is first inserted into the tree for initialization.',
      category: TrackCategory.widgetLifecycle,
      difficulty: 'Medium',
    ),
    Question(
      id: 'q3',
      questionText: 'What is the purpose of the const constructor in Flutter widgets?',
      options: [
        'Creates new memory allocation every rebuild',
        'Allows widgets to be reused at compile-time to optimize rebuilds',
        'Forces the widget to be mutable',
        'Automatically converts widget to a StatefulWidget'
      ],
      correctIndex: 1,
      explanation: 'const constructors allow Flutter to short-circuit rebuilds and reuse existing widget instances in memory.',
      category: TrackCategory.flutter,
      difficulty: 'Easy',
    ),
    Question(
      id: 'q4',
      questionText: 'In Dart, which keyword is used to declare a variable that will be initialized later before being read?',
      options: ['const', 'final', 'late', 'static'],
      correctIndex: 2,
      explanation: 'The "late" keyword tells the sound null-safety compiler that a non-nullable variable will be initialized before use.',
      category: TrackCategory.dart,
      difficulty: 'Easy',
    ),
    Question(
      id: 'q5',
      questionText: 'Which state management technique uses InheritedWidget under the hood with a clean developer API?',
      options: ['Provider', 'Redux Native', 'Pure SharedPreferences', 'Raw StreamBuilder only'],
      correctIndex: 0,
      explanation: 'Provider is a wrapper around InheritedWidget that makes state propagation efficient, testable, and maintainable.',
      category: TrackCategory.stateManagement,
      difficulty: 'Medium',
    ),
    Question(
      id: 'q6',
      questionText: 'Which widget prevents UI elements from being obscured by hardware notches and system status bars?',
      options: ['Expanded', 'SafeArea', 'Spacer', 'SizedBox'],
      correctIndex: 1,
      explanation: 'SafeArea inspects device MediaQuery insets to dynamically pad child widgets away from notches and navigation gestures.',
      category: TrackCategory.mobileUx,
      difficulty: 'Easy',
    ),
    Question(
      id: 'q7',
      questionText: 'When should dispose() be invoked in a State object lifecycle?',
      options: [
        'When the widget is temporarily hidden',
        'When the State object is permanently removed from the widget tree',
        'Before every build() call',
        'Only on app termination'
      ],
      correctIndex: 1,
      explanation: 'dispose() releases persistent controllers, animation tickers, and stream subscriptions to prevent memory leaks.',
      category: TrackCategory.widgetLifecycle,
      difficulty: 'Medium',
    ),
    Question(
      id: 'q8',
      questionText: 'What does the "?." operator represent in Dart language syntax?',
      options: [
        'Ternary conditional execution',
        'Null-aware member access',
        'Cascade notation',
        'Bitwise XOR'
      ],
      correctIndex: 1,
      explanation: 'The null-aware member access (?.) evaluates property calls only when the target reference is non-null.',
      category: TrackCategory.dart,
      difficulty: 'Easy',
    ),
    Question(
      id: 'q9',
      questionText: 'Which widget is optimal for rendering an infinitely long or large list of items efficiently?',
      options: ['SingleChildScrollView', 'ListView.builder', 'Column with List.generate', 'Wrap'],
      correctIndex: 1,
      explanation: 'ListView.builder lazily instantiates only visible children on screen, maintaining high frame rates and low memory overhead.',
      category: TrackCategory.flutter,
      difficulty: 'Medium',
    ),
    Question(
      id: 'q10',
      questionText: 'According to Mobile UX guidelines, what is the recommended minimum touch target size?',
      options: ['24x24 dp', '48x48 dp', '12x12 dp', '100x100 dp'],
      correctIndex: 1,
      explanation: 'Material & Human Interface guidelines recommend a 48x48 dp bounding box to ensure effortless thumb accessibility.',
      category: TrackCategory.mobileUx,
      difficulty: 'Medium',
    ),
    Question(
      id: 'q11',
      questionText: 'What is the primary difference between hot reload and hot restart in Flutter?',
      options: [
        'Hot reload resets application state; hot restart preserves it',
        'Hot reload preserves application state; hot restart re-executes main() and resets state',
        'Hot restart only compiles native C++ plugins',
        'Both are identical operations'
      ],
      correctIndex: 1,
      explanation: 'Hot reload updates code into running Dart VM while keeping state; hot restart destroys VM state and reruns root main().',
      category: TrackCategory.flutter,
      difficulty: 'Easy',
    ),
    Question(
      id: 'q12',
      questionText: 'How can you rebuild only a specific sub-tree when using Provider instead of rebuilding the entire parent?',
      options: [
        'Use Consumer<T> or Selector<T, S>',
        'Wrap everything in setState',
        'Call Provider.of(listen: true) in initState',
        'Avoid ChangeNotifier'
      ],
      correctIndex: 0,
      explanation: 'Consumer and Selector isolate rebuild scopes to their direct builder closures, optimizing rendering performance.',
      category: TrackCategory.stateManagement,
      difficulty: 'Hard',
    ),
  ];
}
