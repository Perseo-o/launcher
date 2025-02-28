import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../models/sound_model.dart';
import '../services/sound_service.dart';
import 'edit_sound_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final SoundService _soundService = SoundService();
  List<Sound> soundList = [];

  @override
  void initState() {
    super.initState();
    _loadSounds();
  }

  Future<void> _loadSounds() async {
    List<Sound> sounds = await _soundService.fetchSounds();
    setState(() {
      soundList = sounds;
    });
  }


  Future<void> _addNewSound() async {

    FilePickerResult? audioResult = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (audioResult == null) return;

    File audioFile = File(audioResult.files.single.path!);
    String soundName = path.basenameWithoutExtension(audioFile.path);

    FilePickerResult? imageResult = await FilePicker.platform.pickFiles(type: FileType.image);
    if (imageResult == null) return;

    File imageFile = File(imageResult.files.single.path!);

    Directory appDir = await getApplicationDocumentsDirectory();

    String newAudioPath = path.join(appDir.path, "sounds", path.basename(audioFile.path));
    String newImagePath = path.join(appDir.path, "images", path.basename(imageFile.path));

    await audioFile.copy(newAudioPath);
    await imageFile.copy(newImagePath);

    Sound newSound = Sound(name: soundName, filePath: newAudioPath, imagePath: newImagePath);

    setState(() {
      soundList.add(newSound);
    });

    await _soundService.addSound(newSound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Personalizza Suoni"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: soundList.isEmpty
          ? const Center(child: Text("Nessun suono aggiunto"))
          : ListView.builder(
        itemCount: soundList.length,
        itemBuilder: (context, index) {
          final sound = soundList[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditSoundScreen(sound: sound),
                  ),
                );
              },
              leading: sound.imagePath.startsWith("assets/")
                  ? Image.asset(
                sound.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.image_not_supported),
              )
                  : Image.file(
                File(sound.imagePath),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(sound.name),
              subtitle: Text("Audio: ${sound.filePath.split('/').last}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewSound,
        child: const Icon(Icons.add),
      ),
    );
  }
}
