import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:semperMade/record/ui/audio_player.dart';
import 'package:semperMade/record/ui/audio_recorder.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  bool showPlayer = false;
  String? audioPath;

  @override
  void initState() {
    super.initState();
    showPlayer = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Record Screen'),
          const Gap(20),
          if (showPlayer)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: AudioPlayer(
                  source: audioPath!,
                  onDelete: () {
                    setState(() => showPlayer = false);
                  },
                ),
              ),
            ),
          if (!showPlayer)
            Expanded(
              child: Recorder(
                onStop: (path) {
                  setState(() {
                    audioPath = path;
                    showPlayer = true;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
