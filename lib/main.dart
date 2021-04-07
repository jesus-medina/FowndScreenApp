import 'package:flutter/material.dart';
import 'package:myapp/widgets/text_shown.dart';
import 'screen/video_player_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(VideoPlayerApp());
}

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: Stack(
        children: [
          VideoPlayerScreen(),
          TextShown()
        ],
      ),
    );
  }
}
