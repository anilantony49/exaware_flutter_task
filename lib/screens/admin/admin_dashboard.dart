import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'add_edit_event_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<EventProvider>(context, listen: false).fetchEvents());
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Central'),
        flexibleSpace: Container(
          decoration: AppTheme.appBarGradient,
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
          )
        ],
      ),
      body: eventProvider.events.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.calendarX, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No events to manage', style: TextStyle(fontSize: 18, color: Colors.grey)),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: eventProvider.events.length,
            separatorBuilder: (ctx, i) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final event = eventProvider.events[i];
              return Card(
                elevation: 1,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(event.location),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.edit3, color: AppTheme.primaryColor),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => AddEditEventScreen(event: event))
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.trash2, color: Colors.redAccent),
                        onPressed: () => _confirmDelete(context, eventProvider, event.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(LucideIcons.plus),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddEditEventScreen())
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, EventProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.deleteEvent(id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
