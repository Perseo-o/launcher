import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/sound_model.dart';
import '../services/sound_service.dart';
import '../widgets/sound_tile.dart';
import 'second_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
    List<Sound> sounds = await SoundService().fetchData();
    setState(() {
      soundList = sounds;
    });
  }



  void _playSound(String soundPath) async {
    if (playingSound == soundPath) {
      await _audioPlayer.stop();
      setState(() => playingSound = null);
      return;
    }

    await _audioPlayer.stop();
    await _audioPlayer.setSourceAsset(soundPath);
    await _audioPlayer.resume();

    setState(() => playingSound = soundPath);

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        playingSound = null;
      });
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
      body: Column(
        children: [
          // Lista dei suoni
          Expanded(
            child: soundList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 13,
                mainAxisSpacing: 12,
              ),
              itemCount: soundList.length,
              itemBuilder: (context, index) {
                final sound = soundList[index];
                final isPlaying = sound.filePath == playingSound;

                return Padding(
                    padding: const EdgeInsets.all(8.0), // Padding interno ai tile
                child:SoundTile(
                  sound: sound,
                  isPlaying: isPlaying,
                  onTap: () => _playSound(sound.filePath),
                ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Vai alla Seconda Pagina',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
