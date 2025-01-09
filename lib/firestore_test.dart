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
  String configText = 'Default Config';

  Future<void> addData() async {
    try {
      CollectionReference chats =
          FirebaseFirestore.instance.collection('chats');
      await chats.add({
        'title': 'Chat Room 1',
        'created_at': DateTime.now(),
      });
      debugPrint('Data added successfully');
    } catch (e) {
      debugPrint('Failed to add data: $e');
    }
  }

  Future<void> fetchData() async {
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    QuerySnapshot snapshot = await chats.get();
    snapshot.docs.forEach((doc) {
      print(doc.data());
    });
  }

  Future<void> updateData(String docId) async {
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');
    await chats.doc(docId).update({'title': 'Updated Chat Room'});
  }

  Future<void> _fetchRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    setState(() {
      configText = remoteConfig.getString('testaa');
    });
  }

  @override
  void initState() {
    _fetchRemoteConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
          Text(configText)
        ],
      ),
    );
  }
}
