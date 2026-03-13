import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _permissionGranted = false;
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final granted = await NotificationService.requestPermission();
    setState(() => _permissionGranted = granted);
  }

  Future<void> _showSimpleNotification() async {
    if (!_permissionGranted) {
      _showPermissionWarning();
      return;
    }
    _notificationCount++;
    await NotificationService.showSimpleNotification(
      id: _notificationCount,
      title: '🔔 Simple Notification',
      body: 'This is notification #$_notificationCount from Lab 10.5!',
    );
    _showSnackBar('Simple notification sent!');
  }

  Future<void> _showLoginSuccessNotification() async {
    if (!_permissionGranted) {
      _showPermissionWarning();
      return;
    }
    _notificationCount++;
    await NotificationService.showSimpleNotification(
      id: _notificationCount,
      title: '✅ Login Successful',
      body: 'Welcome back! You have logged in successfully.',
    );
    _showSnackBar('Login success notification sent!');
  }

  Future<void> _showBigTextNotification() async {
    if (!_permissionGranted) {
      _showPermissionWarning();
      return;
    }
    _notificationCount++;
    await NotificationService.showBigTextNotification(
      id: _notificationCount,
      title: '📋 Big Text Notification',
      body: 'Tap to expand and read more...',
      bigText:
      'This is a big text notification from Lab 10.5!\n\nIt can contain a lot of text that expands when the user taps on the notification.\n\nThis demonstrates the BigTextStyle notification in Flutter.',
    );
    _showSnackBar('Big text notification sent!');
  }

  Future<void> _cancelAll() async {
    await NotificationService.cancelAll();
    _showSnackBar('All notifications cancelled!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.teal,
      ),
    );
  }

  void _showPermissionWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⚠️ Notification permission not granted!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10.5 - Notifications'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Permission status card
            Card(
              color: _permissionGranted ? Colors.green[50] : Colors.red[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _permissionGranted ? Colors.green : Colors.red,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      _permissionGranted
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: _permissionGranted ? Colors.green : Colors.red,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Permission',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _permissionGranted
                                ? Colors.green[800]
                                : Colors.red[800],
                          ),
                        ),
                        Text(
                          _permissionGranted ? '✅ Granted' : '❌ Not Granted',
                          style: TextStyle(
                            color: _permissionGranted
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    if (!_permissionGranted) ...[
                      const Spacer(),
                      TextButton(
                        onPressed: _requestPermission,
                        child: const Text('Grant'),
                      ),
                    ]
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Trigger Notifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _buildButton(
              icon: Icons.notifications,
              label: 'Simple Notification',
              color: Colors.teal,
              onPressed: _showSimpleNotification,
            ),
            const SizedBox(height: 12),

            _buildButton(
              icon: Icons.login,
              label: 'Login Success Notification',
              color: Colors.blue,
              onPressed: _showLoginSuccessNotification,
            ),
            const SizedBox(height: 12),

            _buildButton(
              icon: Icons.article,
              label: 'Big Text Notification',
              color: Colors.purple,
              onPressed: _showBigTextNotification,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),

            _buildButton(
              icon: Icons.cancel,
              label: 'Cancel All Notifications',
              color: Colors.red,
              onPressed: _cancelAll,
            ),

            const SizedBox(height: 24),

            // Info box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal[200]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 Lab 10.5 Info',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Uses flutter_local_notifications package\n'
                        '• Requests permission on Android 13+\n'
                        '• Demonstrates simple & big text notifications\n'
                        '• Login Success notification simulates LO7',
                    style: TextStyle(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}