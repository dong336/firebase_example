import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';

class MemoDetailPage extends StatefulWidget {
  final DatabaseReference reference;
  final Memo memo;

  MemoDetailPage({
    super.key,
    required this.reference,
    required this.memo,
  });

  @override
  State<StatefulWidget> createState() => _MemoDetailPage();
}

class _MemoDetailPage extends State<MemoDetailPage> {
  TextEditingController? titleController;
  TextEditingController? contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.memo.title);
    contentController = TextEditingController(text: widget.memo.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: '제목',
                  fillColor: Colors.blueAccent,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: contentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 100,
                  decoration: const InputDecoration(labelText: '내용'),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Memo memo = Memo(
                    title: titleController!.value.text,
                    content: contentController!.value.text,
                    createTime: widget.memo.createTime,
                  );
                  widget.reference
                    .child('memo')
                    .child(widget.memo.key!)
                    .set(memo.toJson())
                    .then((_) {
                      Navigator.of(context).pop(memo);
                  });
                },
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(1)),
                child: const Text('수정하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}