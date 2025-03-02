import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sound_model.dart';

class SoundService {
    static final SoundService _instance = SoundService._internal();
    factory SoundService() => _instance;

    SoundService._internal();

    final List<Sound> _sounds = [];

    List<Sound> get sounds => _sounds;

    Future<List<Sound>> fetchData() async {
        try {
            final response = await http.get(Uri.parse('https://mocki.io/v1/61aa00b2-2aaf-4b5c-8d43-15184643d544'));

            if (response.statusCode == 200) {
                final List<dynamic> data = jsonDecode(response.body);
                _sounds.clear();
                _sounds.addAll(data.map((json) => Sound.fromJson(json)).toList());
                return _sounds;
            } else {
                throw Exception('Errore nel caricamento dei dati: ${response.statusCode}');
            }
        } catch (e) {
            throw Exception('Errore di rete: $e');
        }
    }
}
