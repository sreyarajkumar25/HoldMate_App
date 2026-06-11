import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _translations;

  AppLocalizations(this.locale) {
    if (locale.languageCode == 'ta') {
      _translations = _tamilTranslations;
    } else {
      _translations = _englishTranslations;
    }
  }

  String translate(String key) {
    return _translations[key] ?? key;
  }

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const Map<String, String> _englishTranslations = {
    'find_lockers': 'Find Lockers',
    'hello': 'Hello',
    'guest': 'Guest',
    'guest_user': 'Guest User',
    'search_lockers': 'Search locker locations...',
    'book_locker': 'Book a Locker',
    'my_bookings': 'My Bookings',
    'track_bag': 'Track Bag',
    'wallet': 'Wallet',
    'recommended_lockers': 'Recommended Lockers',
    'see_all': 'See all',
    'available': 'Available',
    'full': 'Full',
    'notifications_coming': 'Notifications coming soon!',
    'wallet_coming': 'Wallet feature coming soon!',
    'support_coming': 'Support coming soon!',
    'coming_soon': 'Feature coming soon! Stay tuned!',
    'home': 'Home',
    'book': 'Book',
    'bookings': 'Bookings',
    'language': 'Language',
    'select_language': 'Select Language',
    'profile': 'Profile',
    'booking_history': 'Booking History',
    'help_support': 'Help & Support',
    'logout': 'Logout',
    'logout_confirm': 'Are you sure you want to logout?',
    'cancel': 'Cancel',
    'enter_email': 'Enter Your Email',
    'we_will_send_otp': 'We will send you a verification code',
    'email_address': 'Email Address',
    'send_otp': 'SEND OTP',
    'dont_have_account': "Don't have an account?",
    'sign_up': 'Sign Up',
    'verify_email': 'Verify Your Email',
    'enter_6_digit_code': 'Enter the 6-digit code sent to',
    'verify_otp': 'VERIFY OTP',
    'resend_code': 'RESEND',
    'didnt_receive': "Didn't receive code?",
    'resend_in': 'Resend code in',
    'seconds': 'seconds',
    'what_should_we_call_you': 'What should we call you?',
    'enter_name': 'Enter your name to personalize your experience',
    'your_name': 'Your Name',
    'continue_text': 'CONTINUE',
  };

  static const Map<String, String> _tamilTranslations = {
    'find_lockers': 'பூட்டறைகளை கண்டுபிடிக்கவும்',
    'hello': 'வணக்கம்',
    'guest': 'விருந்தினர்',
    'guest_user': 'விருந்தினர் பயனர்',
    'search_lockers': 'பூட்டறை இடங்களை தேடுங்கள்...',
    'book_locker': 'பூட்டறை முன்பதிவு செய்யுங்கள்',
    'my_bookings': 'என் முன்பதிவுகள்',
    'track_bag': 'பையை கண்காணிக்கவும்',
    'wallet': 'பணப்பை',
    'recommended_lockers': 'பரிந்துரைக்கப்பட்ட பூட்டறைகள்',
    'see_all': 'அனைத்தையும் காண்க',
    'available': 'கிடைக்கும்',
    'full': 'நிரம்பியது',
    'notifications_coming': 'அறிவிப்புகள் விரைவில் வரும்!',
    'wallet_coming': 'பணப்பை அம்சம் விரைவில் வரும்!',
    'support_coming': 'உதவி விரைவில் வரும்!',
    'coming_soon': 'அம்சம் விரைவில் வரும்! காத்திருங்கள்!',
    'home': 'முகப்பு',
    'book': 'முன்பதிவு',
    'bookings': 'முன்பதிவுகள்',
    'language': 'மொழி',
    'select_language': 'மொழியை தேர்ந்தெடுக்கவும்',
    'profile': 'சுயவிவரம்',
    'booking_history': 'முன்பதிவு வரலாறு',
    'help_support': 'உதவி',
    'logout': 'வெளியேறு',
    'logout_confirm': 'நீங்கள் வெளியேற விரும்புகிறீர்களா?',
    'cancel': 'ரத்து செய்யுங்கள்',
    'enter_email': 'உங்கள் மின்னஞ்சலை உள்ளிடவும்',
    'we_will_send_otp': 'நாங்கள் உங்களுக்கு சரிபார்ப்பு குறியீட்டை அனுப்புவோம்',
    'email_address': 'மின்னஞ்சல் முகவரி',
    'send_otp': 'OTP அனுப்பு',
    'dont_have_account': 'கணக்கு இல்லையா?',
    'sign_up': 'பதிவு செய்யுங்கள்',
    'verify_email': 'உங்கள் மின்னஞ்சலை சரிபார்க்கவும்',
    'enter_6_digit_code': 'இதற்கு அனுப்பப்பட்ட 6 இலக்க குறியீட்டை உள்ளிடவும்',
    'verify_otp': 'OTP சரிபார்க்கவும்',
    'resend_code': 'மீண்டும் அனுப்பு',
    'didnt_receive': 'குறியீடு வரவில்லையா?',
    'resend_in': 'மீண்டும் அனுப்ப காத்திருக்கும் நேரம்',
    'seconds': 'வினாடிகள்',
    'what_should_we_call_you': 'உங்களை எப்படி அழைக்க வேண்டும்?',
    'enter_name': 'உங்கள் அனுபவத்தை தனிப்பயனாக்க உங்கள் பெயரை உள்ளிடவும்',
    'your_name': 'உங்கள் பெயர்',
    'continue_text': 'தொடரவும்',
  };
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ta'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}