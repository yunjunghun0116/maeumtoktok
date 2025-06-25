import 'package:app/core/logging/report/report_type.dart';

class ReportEntity {
  final String memberId;
  final DateTime timeStamp;
  final ReportType reportType;

  ReportEntity({required this.memberId, required this.reportType, required this.timeStamp});

  factory ReportEntity.of({required String memberId, required ReportType reportType}) {
    var nowDate = DateTime.now();
    return ReportEntity(memberId: memberId, reportType: reportType, timeStamp: nowDate);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'memberId': memberId,
      'timeStamp': timeStamp.toIso8601String(),
      'reportType': reportType.name,
    };
  }

  @override
  String toString() {
    return 'ReportEntity{memberId: $memberId, timeStamp: ${timeStamp.toIso8601String()}, reportType: ${reportType.name}}';
  }
}
