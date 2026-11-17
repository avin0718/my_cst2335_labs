import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Repository for managing and persisting user login credentials and profile data using EncryptedSharedPreferences (FlutterSecureStorage).
class ProfileRepository {
  final FlutterSecureStorage _storage;

  // Login credentials and image state
  String savedUsername = '';
  String savedPassword = '';
  String savedImageSource = 'images/question-mark.png';

  // Profile data
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';

  ProfileRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Loads stored login credentials and image source from EncryptedSharedPreferences asynchronously.
  Future<bool> loadCredentials() async {
    try {
      savedUsername = await _storage.read(key: 'saved_username') ?? '';
      savedPassword = await _storage.read(key: 'saved_password') ?? '';
      savedImageSource =
          await _storage.read(key: 'saved_image_source') ?? 'images/question-mark.png';
      return savedUsername.isNotEmpty && savedPassword.isNotEmpty;
    } catch (e) {
      savedUsername = '';
      savedPassword = '';
      savedImageSource = 'images/question-mark.png';
      return false;
    }
  }

  /// Saves login username, password, and image source to EncryptedSharedPreferences.
  Future<void> saveCredentials(String username, String password,
      {String? imageSource}) async {
    try {
      savedUsername = username;
      savedPassword = password;
      if (imageSource != null) {
        savedImageSource = imageSource;
      }
      await _storage.write(key: 'saved_username', value: username);
      await _storage.write(key: 'saved_password', value: password);
      await _storage.write(key: 'saved_image_source', value: savedImageSource);
    } catch (e) {
      // Handle write error
    }
  }

  /// Clears saved login credentials and resets image source in EncryptedSharedPreferences.
  Future<void> clearCredentials() async {
    try {
      savedUsername = '';
      savedPassword = '';
      savedImageSource = 'images/question-mark.png';
      await _storage.delete(key: 'saved_username');
      await _storage.delete(key: 'saved_password');
      await _storage.delete(key: 'saved_image_source');
    } catch (e) {
      // Handle delete error
    }
  }

  /// Loads stored profile variables from EncryptedSharedPreferences.
  Future<void> loadData() async {
    try {
      firstName = await _storage.read(key: 'first_name') ?? '';
      lastName = await _storage.read(key: 'last_name') ?? '';
      phoneNumber = await _storage.read(key: 'phone_number') ?? '';
      email = await _storage.read(key: 'email') ?? '';
    } catch (e) {
      // Fallback
    }
  }

  /// Saves current profile variables to EncryptedSharedPreferences.
  Future<void> saveData() async {
    try {
      await _storage.write(key: 'first_name', value: firstName);
      await _storage.write(key: 'last_name', value: lastName);
      await _storage.write(key: 'phone_number', value: phoneNumber);
      await _storage.write(key: 'email', value: email);
    } catch (e) {
      // Handle write error
    }
  }
}
