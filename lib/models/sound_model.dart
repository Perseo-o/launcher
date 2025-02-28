class Sound {
  late final String name;
  late final String imagePath;
  final String filePath;

  Sound({required this.name, required this.imagePath, required this.filePath});

  factory Sound.fromJson(Map<String, dynamic> json) {
    return Sound(
      name: json['name'],
      imagePath: 'assets/images/${json['image']}',
      filePath: 'sounds/${json['file']}',
    );
  }
}
