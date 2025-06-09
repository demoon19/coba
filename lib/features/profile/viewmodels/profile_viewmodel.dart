import 'package:dating/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:dating/api/models/user_model.dart';
import 'package:dating/api/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfileViewModel extends ChangeNotifier {
  final UserService _userService = UserService();
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileViewModel(UserRepository of);

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCurrentUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _userService.getUser(userId);
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

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

      await _userService.updateUserProfile(userId, dataToUpdate);
      await fetchCurrentUser(userId); // Refresh data
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadProfileImage(String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        File imageFile = File(pickedFile.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$userId.jpg');
        await storageRef.putFile(imageFile);
        final imageUrl = await storageRef.getDownloadURL();

        await _userService.updateUserProfile(userId, {
          'profileImageUrl': imageUrl,
        });
        await fetchCurrentUser(userId); // Refresh data
        return true;
      } catch (e) {
        _errorMessage = 'Failed to upload image: $e';
        return false;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
    return false;
  }
}
