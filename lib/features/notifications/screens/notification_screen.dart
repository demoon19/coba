import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Jika notifikasi disimpan di Firestore

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_active, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'No new notifications.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            // Jika Anda menyimpan notifikasi di Firestore, Anda bisa menggunakan StreamBuilder di sini
            /*
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('notifications')
                  .where('userId', isEqualTo: currentUserId) // Filter sesuai user
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No notifications yet.');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(doc['title']),
                      subtitle: Text(doc['body']),
                      trailing: Text(DateFormat.yMd().add_jm().format((doc['timestamp'] as Timestamp).toDate())),
                    );
                  },
                );
              },
            )
            */
          ],
        ),
      ),
    );
  }
}