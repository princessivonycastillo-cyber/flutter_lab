// ACTIVITY 4: Flutter Gestures Playground
import 'package:flutter/material.dart';

// TODO: Replace this with YOUR full name.
const String studentName = 'Juan Dela Cruz';

void main() {
  runApp(const GesturesApp());
}

class GesturesApp extends StatelessWidget {
  const GesturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity 4',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const GesturesHome(),
    );
  }
}

// =====================================================================
// HOME: bottom navigation with 3 tabs
// =====================================================================
class GesturesHome extends StatefulWidget {
  const GesturesHome({super.key});

  @override
  State<GesturesHome> createState() => _GesturesHomeState();
}

class _GesturesHomeState extends State<GesturesHome> {
  int _currentTab = 0;

  static const List<Widget> _pages = [
    TapBoxDemo(),
    DragDemo(),
    SwipeListDemo(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Act 4 - $studentName')),
      // IndexedStack keeps every tab "alive" so nothing resets
      // when you switch tabs.
      body: IndexedStack(index: _currentTab, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (index) => setState(() => _currentTab = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.touch_app), label: 'Tap'),
          NavigationDestination(icon: Icon(Icons.pan_tool), label: 'Drag'),
          NavigationDestination(icon: Icon(Icons.swipe), label: 'Swipe'),
        ],
      ),
    );
  }
}

// =====================================================================
// TAB 1: TAP, DOUBLE TAP, LONG PRESS
// =====================================================================
class TapBoxDemo extends StatefulWidget {
  const TapBoxDemo({super.key});

  @override
  State<TapBoxDemo> createState() => _TapBoxDemoState();
}

class _TapBoxDemoState extends State<TapBoxDemo> {
  final List<Color> _palette = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.red,
  ];
  int _colorIndex = 0;
  double _size = 150;
  String _lastGesture = 'None yet';
  int _gestureCount = 0;

  void _record(String gesture) {
    _lastGesture = gesture;
    _gestureCount++;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Last gesture: $_lastGesture',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('Total gestures: $_gestureCount'),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => setState(() {
                _colorIndex = (_colorIndex + 1) % _palette.length;
                _record('Tap (color changed)');
              }),
              onDoubleTap: () => setState(() {
                if (_size < 270) _size += 30;
                _record('Double tap (bigger)');
              }),
              onLongPress: () => setState(() {
                _size = 150;
                _colorIndex = 0;
                _record('Long press (reset)');
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: _size,
                height: _size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _palette[_colorIndex],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  'Tap me!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tap = change color  |  Double tap = grow  |  Long press = reset',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// TAB 2: DRAG (PAN) A BALL AROUND
// =====================================================================
class DragDemo extends StatefulWidget {
  const DragDemo({super.key});

  @override
  State<DragDemo> createState() => _DragDemoState();
}

class _DragDemoState extends State<DragDemo> {
  static const double _ballSize = 80;
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // LayoutBuilder tells us how big the available area is,
    // so we can keep the ball inside the screen.
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxX = constraints.maxWidth - _ballSize;
        final maxY = constraints.maxHeight - _ballSize;

        return Stack(
          children: [
            const Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Text(
                'Drag the ball anywhere inside this area.',
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: _position.dx,
              top: _position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final newX =
                        (_position.dx + details.delta.dx).clamp(0.0, maxX);
                    final newY =
                        (_position.dy + details.delta.dy).clamp(0.0, maxY);
                    _position = Offset(newX.toDouble(), newY.toDouble());
                  });
                },
                child: Container(
                  width: _ballSize,
                  height: _ballSize,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black38,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.open_with,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// =====================================================================
// TAB 3: SWIPE TO DISMISS + TAP RIPPLE
// =====================================================================
class SwipeListDemo extends StatefulWidget {
  const SwipeListDemo({super.key});

  @override
  State<SwipeListDemo> createState() => _SwipeListDemoState();
}

class _SwipeListDemoState extends State<SwipeListDemo> {
  final List<String> _tasks = [
    'Install Flutter',
    'Finish Activity 1',
    'Finish Activity 2',
    'Finish Activity 3',
    'Finish Activity 4',
    'Submit the lab report',
  ];

  void _removeTask(int index, DismissDirection direction) {
    final removed = _tasks[index];
    final action =
        direction == DismissDirection.startToEnd ? 'Completed' : 'Deleted';
    setState(() => _tasks.removeAt(index));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action "$removed"'),
        duration: const Duration(seconds: 3),
        persist: false, // auto-hide even though it has an action button
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => setState(() => _tasks.insert(index, removed)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tasks.isEmpty) {
      return const Center(child: Text('All tasks are done!'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return Dismissible(
          key: ValueKey(task),
          direction: DismissDirection.horizontal,
          // Shown when swiping RIGHT (start -> end)
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: const Icon(Icons.check, color: Colors.white),
          ),
          // Shown when swiping LEFT (end -> start)
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => _removeTask(index, direction),
          child: Card(
            child: ListTile(
              leading: const Icon(Icons.drag_indicator),
              title: Text(task),
              subtitle: const Text('Swipe right = done, left = delete'),
              // ListTile has a built-in InkWell, so tapping shows a ripple.
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('You tapped "$task"'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
