// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'SpendWise';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'रजिस्टर';

  @override
  String get noAccount => 'खाता नहीं है? रजिस्टर करें';

  @override
  String get haveAccount => 'पहले से खाता है? लॉगिन करें';

  @override
  String get add => 'जोड़ें';

  @override
  String get recentTransactions => 'हाल के लेन-देन';

  @override
  String get spendingInsights => 'खर्च की जानकारी';

  @override
  String get totalSpent => 'कुल खर्च';

  @override
  String get viewAnalytics => 'विश्लेषण देखें';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get select_language => 'भाषा चुनें';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get viewAllExpenses => 'सभी खर्च देखें';

  @override
  String get totalSpending => 'कुल खर्च';

  @override
  String get noEmail => 'कोई ईमेल नहीं';

  @override
  String get uid => 'यूआईडी';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get email_required_error => 'ईमेल आवश्यक है';

  @override
  String get valid_email_error => 'कृपया एक मान्य ईमेल दर्ज करें';

  @override
  String get password_required_error => 'पासवर्ड आवश्यक है';

  @override
  String get password_validation_error =>
      'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए';

  @override
  String get language => 'भाषा';

  @override
  String get noDataAvailable => 'कोई डेटा उपलब्ध नहीं';

  @override
  String spendingPercentage(Object category, Object percent) {
    return 'आपने $category पर $percent% खर्च किया';
  }

  @override
  String highSpendingToday(Object todayTotal) {
    return 'आज अधिक खर्च ₹$todayTotal';
  }

  @override
  String last7DaysSpending(Object lastWeekTotal) {
    return 'पिछले 7 दिनों में ₹$lastWeekTotal खर्च किए';
  }

  @override
  String get food => 'खाना';

  @override
  String get travel => 'यात्रा';

  @override
  String get bills => 'बिल';

  @override
  String get shopping => 'खरीदारी';

  @override
  String get emi => 'ईएमआई';
}
