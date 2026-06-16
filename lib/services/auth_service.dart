import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  EmailOTP? _emailOTP;

  Future<bool> sendOTP(String email) async {
    try {
      _emailOTP = EmailOTP();
      _emailOTP!.setConfig(
        appEmail: 'yourapp@gmail.com',
        appName: 'HoldMate',
        userEmail: email,
        otpLength: 6,
        otpType: OTPType.digitsOnly,
      );
      bool result = await _emailOTP!.sendOTP();
      if (result) {
        print('✅ OTP sent to $email');
        return true;
      } else {
        throw Exception('Failed to send OTP');
      }
    } catch (e) {
      print('❌ Error sending OTP: $e');
      throw Exception('Failed to send OTP to email: $e');
    }
  }

  Future<bool> verifyOTP(String userOTP) async {
    try {
      if (_emailOTP == null) {
        throw Exception('No OTP session found. Please request OTP first.');
      }
      bool verified = await _emailOTP!.verifyOTP(otp: userOTP);
      return verified;
    } catch (e) {
      print('❌ Error verifying OTP: $e');
      throw Exception('OTP verification failed: $e');
    }
  }

  Future<void> signUpWithEmail(String email, String username) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'HoldMate@2026',
      );
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await userCredential.user?.sendEmailVerification();
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get user => _auth.authStateChanges();
}
