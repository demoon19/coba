import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/api/services/user_service.dart'; // Import your local UserService
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart'; // No longer needed for local setup

class ProfileViewModel extends ChangeNotifier {
  // Use the local UserService instance through dependency injection
  final UserService _userService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor that accepts the UserService, allowing for easy testing
  ProfileViewModel(this._userService);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetches the current user's profile data.
  /// It's crucial to call this after a user logs in or when the profile screen loads.
  Future<void> fetchCurrentUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Calls the local UserService to get user data
      _currentUser = await _userService.getUser(userId);
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates specific fields of the user's profile.
  Future<bool> updateProfile(
    String userId, {
    String? username,
    String? bio,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      Map<String, dynamic> dataToUpdate = {};
      if (username != null) dataToUpdate['username'] = username;
      if (bio != null) dataToUpdate['bio'] = bio;

      // Calls the local UserService to update user profile
      await _userService.updateUserProfile(userId, dataToUpdate);

      // Refresh the current user data in the ViewModel
      await fetchCurrentUser(userId);
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Handles uploading a profile image from the gallery.
  /// In a local setup, this will store the image path or a base64 representation.
  Future<bool> uploadProfileImage(String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        File imageFile = File(pickedFile.path);

        // For a local environment, you would typically store the image
        // in the app's local storage and save its path.
        // Or, for very small images, convert to Base64 and store directly in the user data.
        final String localImageUrl = imageFile.path; // Using the local file path as the 'URL'

        // Update the user profile with the local image path/data
        await _userService.updateUserProfile(userId, {
          'profileImageUrl': localImageUrl,
        });

        // Refresh the current user data in the ViewModel to reflect the new image
        await fetchCurrentUser(userId);
        return true;
      } catch (e) {
        _errorMessage = 'Failed to upload image: $e';
        return false;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
    return false; // No image picked
  }
}