import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../widgets/whimsical_button.dart';
import '../widgets/sparkle_button.dart';
import '../services/email_service.dart';
import '../theme.dart';

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
  bool _emailFailed = false;

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
    if (email.isEmpty) return false;
    if (!email.contains('@')) return false;
    if (!email.contains('.')) return false;
    return true;
  }

  void _sendOtp() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }

    final email = _emailController.text.trim();
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _emailFailed = false;
    });

    _generatedOtp = (100000 + DateTime.now().millisecondsSinceEpoch % 900000).toString();
    _storedEmail = email;

    try {
      final bool emailSent = await EmailService.sendOtpEmail(
        email,
        _generatedOtp,
        _usernameController.text,
      );

      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _emailFailed = !emailSent;
      });

      if (emailSent) {
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ OTP sent to $email! Check your inbox.'),
            duration: const Duration(seconds: 3),
            backgroundColor: AppTheme.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ OTP: $_generatedOtp (Use this to login)'),
            duration: const Duration(seconds: 6),
            backgroundColor: AppTheme.warning,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _emailFailed = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ OTP: $_generatedOtp (Use this to login)'),
          duration: const Duration(seconds: 6),
          backgroundColor: AppTheme.warning,
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
            colors: [Color(0xFFF8F9FF), Color(0xFFF0F2FF)],
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
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.glowShadow,
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
                      color: AppTheme.textPrimary,
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
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: const Icon(Icons.person, color: AppTheme.primary),
                      filled: true,
                      fillColor: AppTheme.surfaceLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: const TextStyle(color: AppTheme.textSecondary),
                      hintStyle: const TextStyle(color: AppTheme.textHint),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_isNewUser) ...[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'you@example.com',
                        prefixIcon: const Icon(Icons.email, color: AppTheme.primary),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        hintStyle: const TextStyle(color: AppTheme.textHint),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (_isNewUser && _isOtpSent) ...[
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintText: _emailFailed ? 'OTP shown above' : 'Check your email',
                        prefixIcon: Icon(
                          _emailFailed ? Icons.info : Icons.security,
                          color: _emailFailed ? AppTheme.warning : AppTheme.primary,
                        ),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        labelStyle: const TextStyle(color: AppTheme.textSecondary),
                        hintStyle: TextStyle(
                          color: _emailFailed ? AppTheme.warning : AppTheme.textHint,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _canResend ? _sendOtp : null,
                      child: Text(
                        _canResend ? 'Resend OTP' : 'Resend in ${_resendTimer}s',
                        style: TextStyle(
                          color: _canResend ? AppTheme.primary : AppTheme.textMuted,
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
                      color: AppTheme.success,
                    ),
                    const SizedBox(height: 16),
                  ],

                  if (!_isNewUser) ...[
                    WhimsicalButton(
                      onPressed: _isLoading ? () {} : _loginExistingUser,
                      isLoading: _isLoading,
                      color: AppTheme.primary,
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
                        style: const TextStyle(color: AppTheme.textSecondary),
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
                            color: AppTheme.primary,
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
