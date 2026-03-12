import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../../theme/app_theme.dart';

class AddEditEventScreen extends StatefulWidget {
  final Event? event;
  const AddEditEventScreen({super.key, this.event});

  @override
  State<AddEditEventScreen> createState() => _AddEditEventScreenState();
}

class _AddEditEventScreenState extends State<AddEditEventScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _titleController.text = widget.event!.title;
      _locationController.text = widget.event!.location;
      _descriptionController.text = widget.event!.description;
      _selectedDate = widget.event!.date;
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() => _selectedDate = pickedDate);
    });
  }

  void _submit() async {
    if (_titleController.text.isEmpty || _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and Location are required')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final provider = Provider.of<EventProvider>(context, listen: false);
    bool success;
    if (widget.event == null) {
      success = await provider.addEvent(
        _titleController.text,
        _selectedDate,
        _locationController.text,
        _descriptionController.text,
      );
    } else {
      success = await provider.updateEvent(
        widget.event!.id,
        _titleController.text,
        _selectedDate,
        _locationController.text,
        _descriptionController.text,
      );
    }
    if (mounted) setState(() => _isLoading = false);
    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Create Event' : 'Edit Event'),
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
              const Text(
                'Event Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Event Title',
                  prefixIcon: Icon(LucideIcons.type, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  hintText: 'Location',
                  prefixIcon: Icon(LucideIcons.mapPin, size: 20),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Describe your event...',
                  prefixIcon: Icon(LucideIcons.alignLeft, size: 20),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              const Text(
                'When is it happening?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _presentDatePicker,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.calendar, color: AppTheme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('yMMMMd').format(_selectedDate),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ElevatedButton(
                    onPressed: _submit, 
                    child: Text(widget.event == null ? 'Launch Event' : 'Save Changes'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
                    : ElevatedButton.icon(
                        onPressed: _submit, 
                        icon: Icon(widget.event == null ? Icons.add_circle_outline : Icons.save_outlined),
                        label: Text(widget.event == null ? 'INITIALIZE_LAUNCH' : 'COMMIT_CHANGES'),
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
