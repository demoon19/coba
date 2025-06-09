import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';

class MatchListTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const MatchListTile({
    super.key,
    required this.user,
    required this.onTap,
    this.lastMessage,
    this.lastMessageAt,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage:
              user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
              ? NetworkImage(user.profileImageUrl!) as ImageProvider
              : const AssetImage('assets/images/placeholder_profile.png'),
        ),
        title: Text(
          user.username,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: lastMessage != null
            ? Text(
                lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              )
            : Text(
                user.bio != null && user.bio!.isNotEmpty
                    ? user.bio!
                    : 'No bio available.',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
        trailing: lastMessageAt != null
            ? Text(
                '${lastMessageAt!.hour}:${lastMessageAt!.minute}', // Format waktu sederhana
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}
