import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class FinancialHistory extends HiveObject {
  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  DateTime dueDate;

  @HiveField(3)
  DateTime startDate;

  /// Principal amount
  @HiveField(4)
  double amount;

  @HiveField(5)
  double balance;

  /// Interest in percentage per day
  @HiveField(6)
  double interest;
}
