import 'package:flutter/material.dart';
import '../models/sound_model.dart';

class SoundTile extends StatelessWidget {
  final Sound sound;
  final bool isPlaying;
  final VoidCallback onPlay;

  const SoundTile({super.key, 
    required this.sound,
    required this.isPlaying,
    required this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(sound.image),
      ),
      title: Text(sound.name),
      subtitle: isPlaying ? const Text('In riproduzione...', style: TextStyle(color: Colors.green)) : null,
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: onPlay,
      ),
    );
  }
}
