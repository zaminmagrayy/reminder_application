// lib/UI/reminders_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder_application/main.dart'; // To access the global plugin

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
  
  // This function can be used to cancel a specific reminder
  Future<void> _cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    _getPendingReminders(); // Refresh the list
  }
  
  // You might want to format the time for better readability
  String _formatTime(PendingNotificationRequest reminder) {
    if (reminder.payload != null) {
      // Assuming payload contains the full time info, or you can format based on the scheduled date
      // This is a simplified example. You may need to parse the scheduled time from the plugin's data.
      return 'Scheduled for: ' + reminder.body!;
    }
    return 'Time not specified';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reminders'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                      title: Text(
                        reminder.title ?? 'No Title',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        reminder.body ?? 'No Body',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _cancelReminder(reminder.id),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}