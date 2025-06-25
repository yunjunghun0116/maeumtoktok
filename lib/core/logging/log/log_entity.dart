class LogEntity {
  final Object? input;
  final Object? output;
  final String functionName;
  final DateTime timeStamp;

  LogEntity({required this.input, required this.output, required this.functionName, required this.timeStamp});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'input': input?.toString(),
      'output': output?.toString(),
      'functionName': functionName,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    var inputString = input?.toString();
    var outputString = output?.toString();
    return 'LogEntity{input: $inputString, output: $outputString, functionName: $functionName, timeStamp: ${timeStamp.toIso8601String()}';
  }
}
