import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/event_provider.dart';
import '../../theme/app_theme.dart';

class MyRegistrationsScreen extends StatefulWidget {
  const MyRegistrationsScreen({super.key});

  @override
  State<MyRegistrationsScreen> createState() => _MyRegistrationsScreenState();
}

class _MyRegistrationsScreenState extends State<MyRegistrationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<EventProvider>(context, listen: false).fetchMyRegistrations());
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Passes'),
        flexibleSpace: Container(
          decoration: AppTheme.appBarGradient,
        ),
      ),
      body: eventProvider.myRegistrations.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.ticket, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('No registrations found', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: eventProvider.myRegistrations.length,
            itemBuilder: (ctx, i) {
              final reg = eventProvider.myRegistrations[i];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.ticket, color: AppTheme.primaryColor),
                  ),
                  title: Text(
                    reg.event?.title ?? 'Unknown Event',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(reg.event != null ? DateFormat('yMMMd').format(reg.event!.date) : "N/A"),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Registered as: ${reg.name}',
                        style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
