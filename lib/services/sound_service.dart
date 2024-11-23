import '../models/sound_model.dart';

class SoundService {
  // Simula l'ottenimento dei suoni
  List<Sound> fetchSounds() {
    return [
      Sound(name: 'Sound 1 where porco dio mannaggia', image: 'assets/sound1.png', filePath: 'path_to_sound_1'),
      Sound(name: 'Sound 2', image: 'assets/sound2.png', filePath: 'path_to_sound_2'),
      Sound(name: 'Sound 3', image: 'assets/sound3.png', filePath: 'path_to_sound_3'),
    ];
  }
}
