// ACTIVITY 3: Designing a Form Submission Page (Student Registration)
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// TODO: Replace this with YOUR full name.
const String studentName = 'Juan Dela Cruz';

void main() {
  runApp(const SubmissionApp());
}

class SubmissionApp extends StatelessWidget {
  const SubmissionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Activity 3',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const RegistrationPage(),
    );
  }
}

/// A simple "data class" that holds everything the user submitted.
class Registration {
  final String fullName;
  final DateTime birthdate;
  final String studentId;
  final String email;
  final String program;
  final String yearLevel;

  const Registration({
    required this.fullName,
    required this.birthdate,
    required this.studentId,
    required this.email,
    required this.program,
    required this.yearLevel,
  });
}

// =====================================================================
// PAGE 1: THE REGISTRATION FORM
// =====================================================================
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();

  final List<String> _programs = const ['BSIT', 'BSCS', 'BSIS', 'BSEMC'];
  final List<String> _yearLevels = const ['1st', '2nd', '3rd', '4th'];

  String? _selectedProgram;
  String _selectedYear = '1st';
  DateTime? _birthdate;
  bool _agreed = false;
  bool _showAgreeError = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthdateController.dispose();
    _idController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Opens the calendar pop-up and saves the chosen date.
  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthdate ?? DateTime(now.year - 18),
      firstDate: DateTime(1950),
      lastDate: now,
      helpText: 'Select your birthdate',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthdate = picked;
      _birthdateController.text = DateFormat('MMMM d, yyyy').format(picked);
    });
  }

  Future<void> _submit() async {
    if (_isSubmitting) return; // ignore extra taps while sending

    FocusScope.of(context).unfocus();
    final formIsValid = _formKey.currentState!.validate();
    setState(() => _showAgreeError = !_agreed);

    if (!formIsValid || !_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete the form correctly.')),
      );
      return;
    }

    // Show the loading spinner inside the button.
    setState(() => _isSubmitting = true);

    // Pretend we are sending the data to a server (2 seconds).
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // the page might be gone after waiting
    setState(() => _isSubmitting = false);

    final data = Registration(
      fullName: _nameController.text.trim(),
      birthdate: _birthdate!,
      studentId: _idController.text.trim(),
      email: _emailController.text.trim(),
      program: _selectedProgram!,
      yearLevel: _selectedYear,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration submitted successfully!')),
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SummaryPage(data: data)),
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset(); // clears text fields + dropdown + errors
    setState(() {
      _selectedProgram = null;
      _selectedYear = '1st';
      _birthdate = null;
      _agreed = false;
      _showAgreeError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Act 3 - $studentName'),
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- HEADER ----------
              Row(
                children: [
                  Icon(Icons.app_registration, size: 40, color: colors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Registration',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const Text('Fill in all fields, then tap Submit.'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ---------- GROUP 1: PERSONAL INFORMATION ----------
              const FormSectionLabel('Personal information'),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Full name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                readOnly: true, // user cannot type, only pick a date
                onTap: _pickBirthdate,
                decoration: const InputDecoration(
                  labelText: 'Birthdate',
                  prefixIcon: Icon(Icons.cake),
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    _birthdate == null ? 'Please pick your birthdate' : null,
              ),
              const SizedBox(height: 24),

              // ---------- GROUP 2: SCHOOL INFORMATION ----------
              const FormSectionLabel('School information'),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  hintText: 'Numbers only',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Student ID is required';
                  }
                  if (value.length < 6) {
                    return 'Student ID must be at least 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!EmailValidator.validate(value.trim())) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Program',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                items: _programs
                    .map((program) => DropdownMenuItem(
                          value: program,
                          child: Text(program),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedProgram = value),
                validator: (value) =>
                    value == null ? 'Please select your program' : null,
              ),
              const SizedBox(height: 16),
              Text('Year level', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _yearLevels.map((year) {
                  return ChoiceChip(
                    label: Text(year),
                    selected: _selectedYear == year,
                    onSelected: (_) => setState(() => _selectedYear = year),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ---------- GROUP 3: CONFIRMATION ----------
              CheckboxListTile(
                value: _agreed,
                onChanged: (value) => setState(() {
                  _agreed = value ?? false;
                  if (_agreed) _showAgreeError = false;
                }),
                title: const Text(
                  'I confirm that the information above is correct.',
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (_showAgreeError)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'Please tick the box before submitting',
                    style: TextStyle(color: colors.error, fontSize: 12),
                  ),
                ),
              const SizedBox(height: 24),

              // ---------- SUBMIT BUTTON WITH LOADING ANIMATION ----------
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _submit,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSubmitting
                        ? SizedBox(
                            key: const ValueKey('loading'),
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colors.onPrimary,
                            ),
                          )
                        : const Text(
                            'Submit',
                            key: ValueKey('text'),
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _resetForm,
                icon: const Icon(Icons.restart_alt),
                label: const Text('Reset form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small green heading used to group related fields.
class FormSectionLabel extends StatelessWidget {
  final String text;

  const FormSectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

// =====================================================================
// PAGE 2: THE SUMMARY PAGE (shown after a successful submit)
// =====================================================================
class SummaryPage extends StatelessWidget {
  final Registration data;

  const SummaryPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Submission Summary')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // "Pop-in" animation for the check icon.
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Icon(Icons.check_circle, size: 96, color: colors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Thank you, ${data.fullName}!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text(
            'Here is what you submitted:',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                _infoTile(Icons.person, 'Full name', data.fullName),
                _infoTile(
                  Icons.cake,
                  'Birthdate',
                  DateFormat('MMMM d, yyyy').format(data.birthdate),
                ),
                _infoTile(Icons.badge, 'Student ID', data.studentId),
                _infoTile(Icons.email, 'Email', data.email),
                _infoTile(Icons.school, 'Program', data.program),
                _infoTile(Icons.stairs, 'Year level', data.yearLevel),
              ],
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.edit),
            label: const Text('Back to form'),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }
}
