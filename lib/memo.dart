import 'package:firebase_database/firebase_database.dart';

class Memo {
  String? key;
  String title;
  String content;
  String createTime;

  Memo({
    required this.title,
    required this.content,
    required this.createTime,
  });

  static Memo fromSnapshot(DataSnapshot snapshot) {
    Map<String, dynamic> values = Map.from(snapshot.value as Map);
    return Memo(
      title: values['title'],
      content: values['content'],
      createTime: values['createTime'],
    )..key = snapshot.key;
  }

  toJson() {
    return {
      'title': title,
      'content': content,
      'createTime': createTime,
    };
  }
}