import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _publicKey = 'Qq0iRL9jK1Dli3cy2'; 
  static const String _serviceId = 'service_vrynufq'; 
  static const String _templateId = 'template_6s5on7t'; 
  
  
  static Future<bool> sendOtpEmail(String toEmail, String otp, String username) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'to_email': toEmail,
            'passcode': otp,
            'username': username,
          },
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ OTP email sent successfully to $toEmail');
        return true;
      } else {
        print('❌ Failed to send email. Status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending email: $e');
      return false;
    }
  }
}
