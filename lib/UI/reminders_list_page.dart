// lib/UI/reminders_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_application/main.dart';

class RemindersListPage extends StatefulWidget {
  const RemindersListPage({Key? key}) : super(key: key);

  @override
  State<RemindersListPage> createState() => _RemindersListPageState();
}

class _RemindersListPageState extends State<RemindersListPage> {
  List<PendingNotificationRequest> _pendingReminders = [];

  @override
  void initState() {
    super.initState();
    _getPendingReminders();
  }

  Future<void> _getPendingReminders() async {
    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    setState(() {
      _pendingReminders = pendingNotifications;
    });
  }

  Future<void> _cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    _getPendingReminders();
  }
  
  String _formatTime(String? body) {
    return body ?? 'Time not specified';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Reminders',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        color: theme.primaryColor,
        child: SafeArea(
          child: _pendingReminders.isEmpty
              ? const Center(
                  child: Text(
                    'No reminders scheduled.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: _pendingReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = _pendingReminders[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications_active,
                          color: Colors.teal,
                        ),
                        title: Text(
                          reminder.title ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _formatTime(reminder.body),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.pink),
                          onPressed: () => _cancelReminder(reminder.id),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}