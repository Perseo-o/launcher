/*import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SyncService {
  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path; // Percorso dei file locali
  }

  Future<void> syncWithServer(String serverUrl) async {
    try {
      // 1. Recupera lista dei suoni dal server
      final response = await http.get(Uri.parse('$serverUrl/sounds.json'));
      if (response.statusCode == 200) {
        final List<dynamic> sounds = soundListFromJson(response.body);

        for (var sound in sounds) {
          final name = sound['name'];
          final soundUrl = sound['soundUrl'];
          final imageUrl = sound['imageUrl'];

          // Scarica suono
          await _downloadFile(soundUrl, '$name.mp3');
          // Scarica immagine
          await _downloadFile(imageUrl, '$name.png');
        }
      } else {
        print('Errore durante la sincronizzazione: ${response.statusCode}');
      }
    } catch (e) {
      print('Errore durante la sincronizzazione: $e');
    }
  }

  Future<void> _downloadFile(String url, String fileName) async {
    try {
      final localPath = await getLocalPath();
      final file = File('$localPath/$fileName');

      // Controlla se il file esiste già
      if (!file.existsSync()) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          file.writeAsBytesSync(response.bodyBytes);
          print('File scaricato: $fileName');
        }
      }
    } catch (e) {
      print('Errore nel download del file $fileName: $e');
    }
  }

  // Simulazione per il parsing della lista JSON
  List<dynamic> soundListFromJson(String jsonString) {
    // Questo sarà sostituito con un parsing JSON reale
    return [
      {"name": "sound1", "soundUrl": "https://server.com/sound1.mp3", "imageUrl": "https://server.com/sound1.png"},
      {"name": "sound2", "soundUrl": "https://server.com/sound2.mp3", "imageUrl": "https://server.com/sound2.png"},
    ];
  }
}
*/