import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    // Carica i suoni
    soundList = SoundService().fetchSounds();
  }

  void _playSound(String soundName) {
    setState(() {
      playingSound = soundName;
    });
    // Simulazione della riproduzione
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing $soundName')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,  // Centra il titolo orizzontalmente
          children: [
            Text(
              'Launchpad App',
              style: TextStyle(
                fontWeight: FontWeight.bold,  // Imposta il testo in grassetto
              ),
            ),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Quattro colonne per i tasti
          crossAxisSpacing: 13,
          mainAxisSpacing: 12,
        ),
        itemCount: soundList.length,
        itemBuilder: (context, index) {
          final sound = soundList[index];
          final isPlaying = sound.name == playingSound;

          return GestureDetector(
            onTap: () => _playSound(sound.name),
            child: Container(
              decoration: BoxDecoration(
                color: isPlaying ? Colors.green : Colors.blue,
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(sound.image), // L'immagine come background
                  fit: BoxFit.cover,  // Copre l'intero spazio del quadrato
                ),
              ),
              child: Stack(
                children: [
                  // Sovrapposizione semitrasparente per il testo
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5), // Colore semitrasparente sopra l'immagine
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Nome del suono
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center, // Centra il testo sia orizzontalmente che verticalmente
                      child: Text(
                        sound.name,
                        style: const TextStyle(
                          color:  Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
