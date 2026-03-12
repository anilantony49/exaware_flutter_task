import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/event_card.dart';
import 'event_detail_screen.dart';
import 'my_registrations_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
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
        title: const Text('EventHub'),
        flexibleSpace: Container(
          decoration: AppTheme.appBarGradient,
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.list),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MyRegistrationsScreen())
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.logOut),
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => eventProvider.fetchEvents(),
        child: eventProvider.events.isEmpty 
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.calendarX, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No events available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventProvider.events.length,
              itemBuilder: (ctx, i) {
                final event = eventProvider.events[i];
                return EventCard(
                  event: event,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))
                  ),
                );
              },
            ),
      ),
    );
  }
}
                            'REFRESH_TO_SYNC',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: eventProvider.events.isEmpty ? 0 : eventProvider.events.length + 1,
                  itemBuilder: (ctx, i) {
                    if (i == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UPCOMING_STREAM',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryAccent,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                              ),
                            ).animate().fadeIn().slideX(begin: -0.2),
                            const SizedBox(height: 4),
                            Container(width: 32, height: 2, color: AppTheme.primaryAccent),
                          ],
                        ),
                      );
                    }
                    final event = eventProvider.events[i-1];
                    return EventCard(
                      index: i,
                      event: event, 
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
