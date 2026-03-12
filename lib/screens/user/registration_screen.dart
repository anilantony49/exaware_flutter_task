import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../../theme/app_theme.dart';

class RegistrationScreen extends StatefulWidget {
  final Event event;
  const RegistrationScreen({super.key, required this.event});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name and email')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await Provider.of<EventProvider>(context, listen: false).registerForEvent(
      widget.event.id,
      _nameController.text,
      _emailController.text,
      _phoneController.text,
    );
    if (mounted) setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registered successfully! 🎉')),
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop(); // Back to dashboard
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Attendance'),
        flexibleSpace: Container(
          decoration: AppTheme.appBarGradient,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendarCheck, color: AppTheme.primaryColor),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Registering for:',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.event.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Your Full Name',
                  prefixIcon: Icon(LucideIcons.user, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(LucideIcons.mail, size: 20),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number (Optional)',
                  prefixIcon: Icon(LucideIcons.phone, size: 20),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 48),
              _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ElevatedButton(
                    onPressed: _submit, 
                    child: const Text('Complete Registration'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
                    ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryAccent)) 
                    : ElevatedButton.icon(
                        onPressed: _submit, 
                        icon: const Icon(Icons.security_rounded),
                        label: const Text('TRANSMIT_REGISTRATION'),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
