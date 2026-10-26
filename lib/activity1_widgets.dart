// ACTIVITY 1: Designing Buttons, Text Fields, Cards and a Simple Animation
import 'package:flutter/material.dart';

const String studentName = 'Princess Ivony P. Castillo';

void main() {
  runApp(const WidgetShowcaseApp());
}

class WidgetShowcaseApp extends StatelessWidget {
  const WidgetShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity 1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ShowcasePage(),
    );
  }
}

class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  final TextEditingController _nameController = TextEditingController();
  String _greeting = 'Type your name above';
  bool _isLiked = false;
  bool _hidePassword = true;
  bool _isExpanded = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Act 1 - $studentName'),
        backgroundColor: colors.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------------- SECTION 1: BUTTONS ----------------
          const SectionTitle('1. Buttons'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: () => _showMessage('ElevatedButton pressed'),
                child: const Text('Elevated'),
              ),
              FilledButton(
                onPressed: () => _showMessage('FilledButton pressed'),
                child: const Text('Filled'),
              ),
              OutlinedButton(
                onPressed: () => _showMessage('OutlinedButton pressed'),
                child: const Text('Outlined'),
              ),
              TextButton(
                onPressed: () => _showMessage('TextButton pressed'),
                child: const Text('Text'),
              ),
              IconButton(
                onPressed: () => setState(() => _isLiked = !_isLiked),
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showMessage('Styled button pressed'),
              icon: const Icon(Icons.send),
              label: const Text('Styled Button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 6,
              ),
            ),
          ),

          // ---------------- SECTION 2: TEXT FIELDS ----------------
          const SectionTitle('2. Text Fields'),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: 'Full name',
              hintText: 'e.g. Juan Dela Cruz',
              prefixIcon: const Icon(Icons.person),
              helperText: 'A plain TextField (no validation yet)',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _nameController.clear();
                  setState(() => _greeting = 'Type your name above');
                },
              ),
            ),
            onChanged: (value) {
              setState(() {
                _greeting =
                    value.isEmpty ? 'Type your name above' : 'Hello, $value!';
              });
            },
          ),
          const SizedBox(height: 8),
          Text(_greeting, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextField(
            obscureText: _hidePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _hidePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
              ),
            ),
          ),

          // ---------------- SECTION 3: CARD & CONTAINER ----------------
          const SectionTitle('3. Card, Container and Layout'),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    child: const Icon(Icons.school, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Text('BS Information Technology'),
                        const SizedBox(height: 4),
                        Text(
                          'Caraga State University',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.secondary, width: 2),
            ),
            child: const Text(
              'This is a Container with a BoxDecoration: '
              'background color, rounded corners and a border.',
            ),
          ),

          // ---------------- SECTION 4: ANIMATION ----------------
          const SectionTitle('4. Animation (AnimatedContainer)'),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              width: _isExpanded ? 220 : 110,
              height: _isExpanded ? 220 : 110,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isExpanded ? colors.primary : Colors.deepOrange,
                borderRadius: BorderRadius.circular(_isExpanded ? 110 : 16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                _isExpanded ? 'Big!' : 'Small',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: FilledButton.tonal(
              onPressed: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(_isExpanded ? 'Shrink' : 'Animate!'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// A small reusable widget for the green section headings.
class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
