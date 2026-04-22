// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SpendWise';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get noAccount => 'Don\'t have an account? Register';

  @override
  String get haveAccount => 'Already have an account? Login';

  @override
  String get add => 'Add';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get spendingInsights => 'Spending Insights';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get viewAnalytics => 'View Analytics';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get select_language => 'Select Language';

  @override
  String get settings => 'Settings';

  @override
  String get analytics => 'Analytics';

  @override
  String get viewAllExpenses => 'View All Expenses';

  @override
  String get totalSpending => 'Total Spending';

  @override
  String get noEmail => 'No Email';

  @override
  String get uid => 'UID';

  @override
  String get logout => 'Logout';

  @override
  String get email_required_error => 'Email is required';

  @override
  String get valid_email_error => 'Enter a valid email';

  @override
  String get password_required_error => 'Password is required';

  @override
  String get password_validation_error =>
      'Password must be at least 6 characters';

  @override
  String get language => 'Language';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String spendingPercentage(Object category, Object percent) {
    return 'You spent $percent% on $category';
  }

  @override
  String highSpendingToday(Object todayTotal) {
    return 'High spending today ₹ $todayTotal';
  }

  @override
  String last7DaysSpending(Object lastWeekTotal) {
    return '₹ $lastWeekTotal spent in last 7 days';
  }

  @override
  String get food => 'Food';

  @override
  String get travel => 'Travel';

  @override
  String get bills => 'Bills';

  @override
  String get shopping => 'Shopping';

  @override
  String get emi => 'EMI';
}
