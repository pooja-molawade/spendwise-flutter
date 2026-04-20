// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get appName => 'SpendWise';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get login => 'लॉगिन';

  @override
  String get register => 'नोंदणी';

  @override
  String get noAccount => 'खाते नाही? नोंदणी करा';

  @override
  String get haveAccount => 'आधीच खाते आहे? लॉगिन करा';

  @override
  String get add => 'जोडा';

  @override
  String get recentTransactions => 'अलीकडील व्यवहार';

  @override
  String get spendingInsights => 'खर्च विश्लेषण';

  @override
  String get totalSpent => 'एकूण खर्च';

  @override
  String get viewAnalytics => 'विश्लेषण पहा';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'काल';

  @override
  String get select_language => 'भाषा निवडा';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get analytics => 'विश्लेषण';

  @override
  String get viewAllExpenses => 'सर्व खर्च पहा';

  @override
  String get totalSpending => 'एकूण खर्च';

  @override
  String get noEmail => 'ईमेल उपलब्ध नाही';

  @override
  String get uid => 'यूआयडी';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get email_required_error => 'ईमेल आवश्यक आहे';

  @override
  String get valid_email_error => 'कृपया वैध ईमेल टाका';

  @override
  String get password_required_error => 'पासवर्ड आवश्यक आहे';

  @override
  String get password_validation_error => 'पासवर्ड किमान 6 अक्षरांचा असावा';

  @override
  String get language => 'भाषा';

  @override
  String get noDataAvailable => 'कोणताही डेटा उपलब्ध नाही';

  @override
  String spendingPercentage(Object category, Object percent) {
    return 'तुम्ही $category वर $percent% खर्च केला';
  }

  @override
  String highSpendingToday(Object todayTotal) {
    return 'आज जास्त खर्च ₹ $todayTotal';
  }

  @override
  String last7DaysSpending(Object lastWeekTotal) {
    return 'मागील 7 दिवसांत ₹$lastWeekTotal खर्च झाले';
  }

  @override
  String get food => 'अन्न';

  @override
  String get travel => 'प्रवास';

  @override
  String get bills => 'बिले';

  @override
  String get shopping => 'खरेदी';

  @override
  String get emi => 'ईएमआय';
}
