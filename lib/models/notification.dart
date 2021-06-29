import 'package:flutter/cupertino.dart';

class Notification {
  final String id;
  final String title;
  final String desc;
  final String intervalTime;

  Notification({
    @required this.id,
    @required this.title,
    @required this.desc,
    @required this.intervalTime,
  });
}
