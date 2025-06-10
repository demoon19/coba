// import 'package:cloud_firestore/cloud_firestore.dart'; // Removed Firebase import
import 'package:dating/api/api_constants.dart'; // Still needed for collection names if you define them there
import 'package:dating/api/models/match_model.dart';

class MatchRepository {
  // Simulate a local "matches" collection with an in-memory list of maps
  static final List<Map<String, dynamic>> _localMatches = [];
  static int _nextMatchId = 1; // For generating unique local match IDs

  // A helper method to add matches for testing purposes
  static void addLocalMatch(MatchModel match) {
    _localMatches.add(match.toMap());
  }

  Future<List<MatchModel>> getUserMatches(String userId) async {
    try {
      // Filter local matches where userId is either userId1 or userId2
      final List<Map<String, dynamic>> rawMatches = _localMatches
          .where((match) => match['userId1'] == userId || match['userId2'] == userId)
          .toList();

      // Convert raw maps to MatchModel and filter duplicates
      final seenMatchIds = <String>{};
      final filteredUniqueMatches = <MatchModel>[];
      for (var matchMap in rawMatches) {
        final match = MatchModel.fromMap(matchMap); // Use fromMap for local data
        if (!seenMatchIds.contains(match.id)) {
          filteredUniqueMatches.add(match);
          seenMatchIds.add(match.id);
        }
      }

      return filteredUniqueMatches;
    } catch (e) {
      print('Error getting user matches: $e');
      return [];
    }
  }

  Future<void> markMatchAsSeen(String matchId, String currentUserId) async {
    try {
      final matchIndex = _localMatches.indexWhere((match) => match['id'] == matchId);

      if (matchIndex != -1) {
        final matchData = _localMatches[matchIndex];
        if (matchData['userId1'] == currentUserId) {
          matchData['isSeenByUser1'] = true;
        } else if (matchData['userId2'] == currentUserId) {
          matchData['isSeenByUser2'] = true;
        }
        // Update the list (no need to re-add, just modifying the map in place)
        print('Marked match $matchId as seen by $currentUserId. Current status: ${matchData['isSeenByUser1']}, ${matchData['isSeenByUser2']}'); // For debugging
      } else {
        print('Match with ID $matchId not found.');
      }
    } catch (e) {
      print('Error marking match as seen: $e');
    }
  }

  Future<void> createMatch(String userId1, String userId2) async {
    try {
      // Ensure no duplicate match regardless of order (userId1, userId2) or (userId2, userId1)
      final bool alreadyExists = _localMatches.any((match) {
        return (match['userId1'] == userId1 && match['userId2'] == userId2) ||
               (match['userId1'] == userId2 && match['userId2'] == userId1);
      });

      if (!alreadyExists) {
        final newMatchId = 'match_${_nextMatchId++}';
        final newMatch = {
          'id': newMatchId,
          'userId1': userId1,
          'userId2': userId2,
          'matchedAt': DateTime.now().toIso8601String(), // Store as ISO 8601 string
          'isSeenByUser1': false,
          'isSeenByUser2': false,
          'lastMessage': null,
          'lastMessageAt': null,
        };
        _localMatches.add(newMatch);
        print('Created new match: $newMatch'); // For debugging
      } else {
        print('Match between $userId1 and $userId2 already exists.');
      }
    } catch (e) {
      print('Error creating match: $e');
      rethrow;
    }
  }
}