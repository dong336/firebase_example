import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';
class MemoPage extends StatefulWidget {
  const MemoPage({super.key});
  @override
  State<StatefulWidget> createState() => _MemoPage();
}
class _MemoPage extends State<MemoPage> {
  DatabaseReference? reference;
  final String _databaseURL = 'https://example-a9969-default-rtdb.firebaseio.com/';
  List<Memo> memos = [];
  @override
  void initState() {
    super.initState();
    try {
      reference = FirebaseDatabase.instance.refFromURL(_databaseURL);
      reference?.child('memo').onChildAdded.listen((event) {
        print(event.snapshot.value.toString());
        setState(() {
          memos.add(Memo.fromSnapshot(event.snapshot));
        });
      });
    } catch(e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메모 앱'),
      ),
      body: Container(
        child: Center(
          child: memos.isEmpty ? const CircularProgressIndicator() :
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Card(
                child: GridTile(
                  header: Text(memos[index].title),
                  footer: Text(memos[index].createTime.substring(0, 10)),
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                      child: GestureDetector(
                        onTap: () async {
                          Memo? memo = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => MemoDetailPage(reference: reference!, memo: memos[index]),
                              )
                          );
                          if (memo != null) {
                            setState(() {
                              memos[index].title = memo.title;
                              memos[index].content = memo.content;
                            });
                          }
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(memos[index].title),
                                  content: const Text('삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        reference!
                                            .child(memos[index].key!)
                                            .remove()
                                            .then((_) {
                                          setState(() {
                                            memos.removeAt(index);
                                            Navigator.of(context).pop();
                                          });
                                        });
                                      },
                                      child: const Text('예'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('아니요'),
                                    )
                                  ],
                                );
                              }
                          );
                        },
                        child: Text(memos[index].content),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: memos.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MemoAddPage(reference: reference!),
              )
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}