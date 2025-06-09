class ApiConstants {
  // --- Exchange Rate API (Example: exchangerate-api.com) ---
  static const String exchangeRateApiKey = 'YOUR_EXCHANGE_RATE_API_KEY'; // GANTI DENGAN KUNCI API ANDA
  static const String exchangeRateBaseUrl = 'https://v6.exchangerate-api.com/v6/$exchangeRateApiKey/latest/';

  // --- Google Maps API (Client-side) ---
  // API Key untuk Google Maps SDK akan diatur di file native (Android/iOS)
  // Tidak disarankan menyimpan di sini jika Anda ingin membatasi akses

  // --- Google Cloud Functions (Jika Anda menggunakan backend kustom serverless) ---
  // Contoh endpoint untuk autentikasi jika Anda membangunnya sendiri
  static const String cloudFunctionsBaseUrl = 'YOUR_CLOUD_FUNCTIONS_BASE_URL'; // e.g., 'https://us-central1-your-project-id.cloudfunctions.net'
  static const String loginEndpoint = '$cloudFunctionsBaseUrl/login';
  static const String registerEndpoint = '$cloudFunctionsBaseUrl/register';
  static const String likeProfileEndpoint = '$cloudFunctionsBaseUrl/likeProfile';
  static const String updateProfileEndpoint = '$cloudFunctionsBaseUrl/updateProfile';

  // --- Firestore Collection Names ---
  static const String usersCollection = 'users';
  static const String matchesCollection = 'matches';
  static const String messagesCollection = 'messages';
  static const String notificationsCollection = 'notifications';
}