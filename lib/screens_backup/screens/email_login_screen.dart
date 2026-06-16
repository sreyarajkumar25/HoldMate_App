import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../widgets/whimsical_button.dart';
import '../widgets/sparkle_button.dart';
import '../services/email_service.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isNewUser = false;
  String _generatedOtp = '';
  String _storedEmail = '';
  int _resendTimer = 0;
  bool _canResend = true;

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  void _checkExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasUser = prefs.getBool('has_user') ?? false;
    setState(() {
      _isNewUser = !hasUser;
    });
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 30;
      _canResend = false;
    });
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (_resendTimer > 0) {
          setState(() {
            _resendTimer--;
          });
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
          });
        }
      }
    });
  }

  bool _isValidEmail(String email) {
    // Simple email validation - just check if it contains @ and .
    if (email.isEmpty) return false;
    if (!email.contains('@')) return false;
    if (!email.contains('.')) return false;
    return true;
  }

  void _sendOtp() async {
    // Check username
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    // Check email - more lenient validation
    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _generatedOtp = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    _storedEmail = email;

    // Send OTP via EmailJS
    final bool emailSent = await EmailService.sendOtpEmail(
      email,
      _generatedOtp,
      _usernameController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (emailSent) {
      setState(() {
        _isOtpSent = true;
      });
      _startResendTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ OTP sent to $email! Please check your inbox.'),
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Show OTP in app as fallback
      setState(() {
        _isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Use OTP: $_generatedOtp (Email sending failed)'),
          duration: const Duration(seconds: 6),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the OTP')),
      );
      return;
    }

    if (_otpController.text != _generatedOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', _storedEmail);
    await prefs.setString('user_name', _usernameController.text);
    await prefs.setBool('has_user', true);
    await prefs.setBool('is_logged_in', true);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _loginExistingUser() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your username')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _usernameController.text);
    await prefs.setBool('is_logged_in', true);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A0F), Color(0xFF1A1A2E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF00E5FF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C63FF).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/icons/app_icon.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.handshake,
                            size: 40,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _isNewUser ? '✨ Create Account' : '👋 Welcome Back!',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isNewUser 
                      ? 'Verify your email to get started'
                      : 'Enter your username to continue',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFA0A0B0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF6C63FF)),
                      filled: true,
                      fillColor: const Color(0xFF1C1C28),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: const TextStyle(color: Color(0xFF6B6B7D)),
                      hintStyle: const TextStyle(color: Color(0xFF6B6B7D)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isNewUser) ...[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'you@example.com',
                        prefixIcon: const Icon(Icons.email, color: Color(0xFF6C63FF)),
                        filled: true,
                        fillColor: const Color(0xFF1C1C28),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: Color(0xFF6B6B7D)),
                        hintStyle: const TextStyle(color: Color(0xFF6B6B7D)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isNewUser && _isOtpSent) ...[
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintText: '6-digit code from email',
                        prefixIcon: const Icon(Icons.security, color: Color(0xFF6C63FF)),
                        filled: true,
                        fillColor: const Color(0xFF1C1C28),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: Color(0xFF6B6B7D)),
                        hintStyle: const TextStyle(color: Color(0xFF6B6B7D)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _canResend ? _sendOtp : null,
                      child: Text(
                        _canResend ? 'Resend OTP' : 'Resend in ${_resendTimer}s',
                        style: TextStyle(
                          color: _canResend ? Color(0xFF6C63FF) : Color(0xFF6B6B7D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isNewUser && !_isOtpSent) ...[
                    WhimsicalButton(
                      onPressed: _isLoading ? () {} : _sendOtp,
                      isLoading: _isLoading,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Send OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (_isNewUser && _isOtpSent) ...[
                    SparkleButton(
                      onPressed: _isLoading ? () {} : _verifyOtp,
                      text: 'Verify & Create Account',
                      icon: Icons.check_circle,
                      color: const Color(0xFF34C759),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (!_isNewUser) ...[
                    WhimsicalButton(
                      onPressed: _isLoading ? () {} : _loginExistingUser,
                      isLoading: _isLoading,
                      color: const Color(0xFF6C63FF),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isNewUser ? 'Already have an account?' : 'New user?',
                        style: const TextStyle(color: Color(0xFFA0A0B0)),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isNewUser = !_isNewUser;
                            _isOtpSent = false;
                            _otpController.clear();
                          });
                        },
                        child: Text(
                          _isNewUser ? 'Login' : 'Create Account',
                          style: const TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
