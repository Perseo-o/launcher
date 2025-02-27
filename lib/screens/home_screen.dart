import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_model.dart';
import '../services/sound_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Sound> soundList = [];
  String? playingSound;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    List<Sound> sounds = await SoundService().fetchSounds();
    setState(() {
      soundList = sounds;
    });
  }

  void _playSound(String soundPath) async {
    if (playingSound == soundPath) {
      await _audioPlayer.stop();
      setState(() {
        playingSound = null;
      });
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.setSourceAsset(soundPath);
    await _audioPlayer.resume();

    setState(() {
      playingSound = soundPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Launchpad App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: soundList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 13,
          mainAxisSpacing: 12,
        ),
        itemCount: soundList.length,
        itemBuilder: (context, index) {
          final sound = soundList[index];
          final isPlaying = sound.filePath == playingSound;

          return GestureDetector(
            onTap: () => _playSound(sound.filePath),
            child: Container(
              decoration: BoxDecoration(
                color: isPlaying ? Colors.green : Colors.blue,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(sound.image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Center(
                    child: Text(
                      sound.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
