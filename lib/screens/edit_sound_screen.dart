import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/sound_model.dart';
import '../services/sound_service.dart';

class EditSoundScreen extends StatefulWidget {
  final Sound sound;

  const EditSoundScreen({super.key, required this.sound});

  @override
  _EditSoundScreenState createState() => _EditSoundScreenState();
}

class _EditSoundScreenState extends State<EditSoundScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.sound.name;
    _imagePath = widget.sound.imagePath;
  }

  Future<void> _pickNewImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _imagePath = result.files.single.path!;
      });
    }
  }

  void _saveChanges() {
    setState(() {
      widget.sound.name = _nameController.text;
      widget.sound.imagePath = _imagePath ?? widget.sound.imagePath;
    });

    Navigator.pop(context); // Torna alla seconda schermata
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifica Suono"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Torna alla seconda schermata
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nome Suono"),
            ),
            const SizedBox(height: 20),
            _imagePath != null
                ? Image.asset(_imagePath!, width: 100, height: 100, fit: BoxFit.cover)
                : const Icon(Icons.image, size: 100),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickNewImage,
              child: const Text("Cambia Immagine"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Salva"),
            ),
          ],
        ),
      ),
    );
  }
}
