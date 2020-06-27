import 'dart:html';

import 'package:borrows/src/models/hive/financial_history.dart';
import 'package:hive/hive.dart';

class Person extends HiveObject {
  String name;
  String contact;
  List<FinancialHistory> transactionHistory;
}
