import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sound_model.dart';

class SoundService {
    static final SoundService _instance = SoundService._internal();
    factory SoundService() => _instance;

    SoundService._internal(); // Costruttore privato

    final List<Sound> _sounds = [];

    List<Sound> get sounds => _sounds;

    Future<List<Sound>> fetchSounds() async {
        final String response = await rootBundle.loadString('assets/sounds/sounds.json');
        final List<dynamic> data = json.decode(response);

        return data.map((json) => Sound.fromJson(json)).toList();
    }

    Future<void> addSound(Sound sound) async {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String audioDir = p.join(appDocDir.path, 'assets/sounds');
        String imageDir = p.join(appDocDir.path, 'assets/images');

        Directory(audioDir).createSync(recursive: true);
        Directory(imageDir).createSync(recursive: true);

        String audioPath = p.join(audioDir, p.basename(sound.filePath));
        File(audioPath).writeAsBytesSync(await File(sound.filePath).readAsBytes());

        String imagePath = p.join(imageDir, p.basename(sound.imagePath));
        File(imagePath).writeAsBytesSync(await File(sound.imagePath).readAsBytes());

        Sound newSound = Sound(
            name: sound.name,
            filePath: audioPath,
            imagePath: imagePath,
        );
        _sounds.add(newSound);

        await _saveSoundsToLocalStorage();
    }

    Future<void> _saveSoundsToLocalStorage() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> soundNames = _sounds.map((e) => e.name).toList();
        List<String> soundPaths = _sounds.map((e) => e.filePath).toList();
        List<String> imagePaths = _sounds.map((e) => e.imagePath).toList();

        // Salva i dati sui suoni
        prefs.setStringList('sound_names', soundNames);
        prefs.setStringList('sound_paths', soundPaths);
        prefs.setStringList('image_paths', imagePaths);
    }

    Future<void> loadSoundsFromLocalStorage() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String>? soundNames = prefs.getStringList('sound_names');
        List<String>? soundPaths = prefs.getStringList('sound_paths');
        List<String>? imagePaths = prefs.getStringList('image_paths');

        if (soundNames != null && soundPaths != null && imagePaths != null) {

            _sounds.clear();
            for (int i = 0; i < soundNames.length; i++) {
                _sounds.add(Sound(
                    name: soundNames[i],
                    filePath: soundPaths[i],
                    imagePath: imagePaths[i],
                ));
            }
        }
    }


/*
List<Sound> _sounds = [
      Sound(name: 'Sound 1', image: 'assets/images/image1.jpg', filePath: 'sounds/sound1.ogg'),
      Sound(name: 'Sound 2', image: 'assets/images/image2.jpg', filePath: 'sounds/sound2.ogg'),
      Sound(name: 'Sound 3', image: 'assets/images/image3.jpg', filePath: 'sounds/sound3.ogg'),
      Sound(name: 'Sound 4', image: 'assets/images/image1.jpg', filePath: 'sounds/sound4.mp3'),
      Sound(name: 'Sound 5', image: 'assets/images/image2.jpg', filePath: 'sounds/sound5.mp3'),
      Sound(name: 'Sound 6', image: 'assets/images/image3.jpg', filePath: 'sounds/sound6.mp3'),
      Sound(name: 'Sound 7', image: 'assets/images/image1.jpg', filePath: 'sounds/sound7.mp3'),
      Sound(name: 'Sound 8', image: 'assets/images/image2.jpg', filePath: 'sounds/sound8.mp3'),
      Sound(name: 'Sound 9', image: 'assets/images/image3.jpg', filePath: 'sounds/sound9.mp3'),
      Sound(name: 'Sound 10', image: 'assets/images/image1.jpg', filePath: 'sounds/sound10.mp3'),
      Sound(name: 'Sound 11', image: 'assets/images/image2.jpg', filePath: 'sounds/sound11.mp3'),
      Sound(name: 'Sound 12', image: 'assets/images/image3.jpg', filePath: 'sounds/sound12.mp3'),
      Sound(name: 'Sound 13', image: 'assets/images/image1.jpg', filePath: 'sounds/sound13.mp3'),
      Sound(name: 'Sound 14', image: 'assets/images/image2.jpg', filePath: 'sounds/sound14.mp3'),
      Sound(name: 'Sound 15', image: 'assets/images/image3.jpg', filePath: 'sounds/sound15.mp3'),
      Sound(name: 'Sound 16', image: 'assets/images/image1.jpg', filePath: 'sounds/sound16.mp3'),
      Sound(name: 'Sound 17', image: 'assets/images/image2.jpg', filePath: 'sounds/sound17.mp3'),
      Sound(name: 'Sound 18', image: 'assets/images/image3.jpg', filePath: 'sounds/sound18.mp3'),
      Sound(name: 'Sound 19', image: 'assets/images/image1.jpg', filePath: 'sounds/sound19.mp3'),
      Sound(name: 'Sound 20', image: 'assets/images/image2.jpg', filePath: 'sounds/sound20.mp3'),
      Sound(name: 'Sound 21', image: 'assets/images/image3.jpg', filePath: 'sounds/sound21.mp3'),
      Sound(name: 'Sound 22', image: 'assets/images/image1.jpg', filePath: 'sounds/sound22.mp3'),
      Sound(name: 'Sound 23', image: 'assets/images/image2.jpg', filePath: 'sounds/sound23.mp3'),
      Sound(name: 'Sound 24', image: 'assets/images/image3.jpg', filePath: 'sounds/sound24.mp3'),
      Sound(name: 'Sound 25', image: 'assets/images/image1.jpg', filePath: 'sounds/sound25.mp3'),
      Sound(name: 'Sound 26', image: 'assets/images/image2.jpg', filePath: 'sounds/sound26.ogg'),
    ];
    List<Sound> get sounds => _sounds ;

    void addSound(Sound sound) {
      _sounds.add(sound);

  }*/
}
