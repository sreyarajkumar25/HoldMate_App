import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailJSService {
  // 🔴 REPLACE with your actual credentials
  static const String _publicKey = 'Qq0iRL9jK1Dli3cy2';     // From Step 2
  static const String _serviceId = 'service_vrynufq';     // From Step 3
  static const String _templateId = 'template_6s5on7t';   // From Step 1
  
  static String generateOTP() {
    final random = Random();
    int otp = 100000 + random.nextInt(900000);
    return otp.toString();
  }
  
  static Future<bool> sendOTPEmail(String toEmail, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'to_email': toEmail,
            'passcode': otp,
          },
        }),
      );
      
      if (response.statusCode == 200) {
        print('✅ OTP sent successfully to $toEmail');
        return true;
      } else {
        print('❌ Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }
}