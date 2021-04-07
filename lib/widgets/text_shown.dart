import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class TextShown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TextShownState();
  }
}

class _TextShownState extends State<TextShown> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference actualSongDoc;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return textShown(context, 'Error');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          firestore
              .collection('musical-groups')
              .doc('ABCDEF')
              .snapshots()
              .listen((musicalGroupDoc) {
            if (!musicalGroupDoc.exists) {
              print('musicalGroupDoc does not exists');
            } else {
              setState(() {
                actualSongDoc = musicalGroupDoc.get('actual-song');
              });
            }
          });

          if (actualSongDoc == null) {
            return textShown(context, '');
          }

          return StreamBuilder(
              stream: actualSongDoc.snapshots().map((actualSongData) {
                if (!actualSongData.exists) {
                  return '';
                } else {
                  return actualSongData.data()['shown-lyrics'];
                }
              }),
              builder: (context, snapshot) {
                String shownLyrics = '';
                if (snapshot.hasData) {
                  shownLyrics = snapshot.data;
                }

                return textShown(context, shownLyrics.toUpperCase());
              });
        }

        return CircularProgressIndicator();
      },
    ));
  }

  Widget textShown(BuildContext context, String text) {
    var screenSize = MediaQuery.of(context).size;
    var fontSize =
        14 + (36 - 14) * (screenSize.width + screenSize.height) / 1000;
    print(fontSize);

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.white,
          decoration: TextDecoration.none,
          fontSize: fontSize),
    );
  }
}
