// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirestoreTest extends StatefulWidget {
  const FirestoreTest({super.key});

  @override
  State<FirestoreTest> createState() => _FirestoreTestState();
}

class _FirestoreTestState extends State<FirestoreTest> {
  String _configText = 'Default Config';
  final String _chat = 'chats';
  final _app = FirebaseFirestore.instance;

  Future<void> addData() async {
    try {
      CollectionReference chats = _app.collection(_chat);
      await chats.add({
        'title': 'Chat Room 1',
        'created_at': DateTime.now(),
      });
      debugPrint('데이터 추가 완료');
    } catch (e) {
      debugPrint('데이터 추가 실패 : $e');
    }
  }

  Future<void> fetchData() async {
    CollectionReference chats = _app.collection(_chat);
    QuerySnapshot snapshot = await chats.get();
    snapshot.docs.forEach((doc) {
      print(doc.data());
    });
  }

  Future<void> updateData(String docId) async {
    CollectionReference chats = _app.collection(_chat);
    await chats.doc(docId).update({'title': 'Updated Chat Room'});
  }

  Future<void> _fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();

    setState(() {
      _configText = remoteConfig.getString('testaa');
    });
  }

  @override
  void initState() {
    _fetchRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: addData,
          child: Text('Add Data'),
        ),
        ElevatedButton(
          onPressed: fetchData,
          child: Text('Fetch Data'),
        ),
        ElevatedButton(
          onPressed: () => updateData('docId'),
          child: Text('Update Data'),
        ),
        TextButton(
          onPressed: () {
            throw Exception();
          },
          child: const Text("Throw Test Exception"),
        ),
        Text(_configText)
      ],
    );
  }
}
