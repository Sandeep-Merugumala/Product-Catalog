import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/firestore_service.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreService().getNotificationsStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () => _showClearConfirmation(context),
                child: const Text(
                  'CLEAR ALL',
                  style: TextStyle(
                    color: Color(0xFFFF3F6C),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/bell_snooze.json',
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.notifications_off,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'No new notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'We will notify you as soon as there is something new for you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFF3F6C)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          'START SHOPPING',
                          style: TextStyle(
                            color: Color(0xFFFF3F6C),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final bool isRead = data['isRead'] ?? true;
              final DateTime createdAt =
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

              return ListTile(
                tileColor: isRead
                    ? Colors.white
                    : Colors.blue.withValues(alpha: 0.05),
                leading: CircleAvatar(
                  backgroundColor: const Color(
                    0xFFFF3F6C,
                  ).withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Color(0xFFFF3F6C),
                  ),
                ),
                title: Text(
                  data['title'] ?? 'Notification',
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      data['body'] ?? '',
                      style: TextStyle(
                        color: isRead ? Colors.grey[700] : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a').format(createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
                onTap: () {
                  if (!isRead) {
                    FirestoreService().markNotificationAsRead(doc.id);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Notifications?'),
        content: const Text(
          'Are you sure you want to remove all notifications?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              FirestoreService().clearAllNotifications().then((_) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications cleared'),
                      backgroundColor: Colors.black87,
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              });
            },
            child: const Text(
              'CLEAR ALL',
              style: TextStyle(
                color: Color(0xFFFF3F6C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
