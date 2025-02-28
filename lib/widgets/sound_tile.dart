import 'package:flutter/material.dart';
import '../models/sound_model.dart';

class SoundTile extends StatefulWidget {
  final Sound sound;
  final bool isPlaying;
  final VoidCallback onTap;

  const SoundTile({
    super.key,
    required this.sound,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  _SoundTileState createState() => _SoundTileState();
}

class _SoundTileState extends State<SoundTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.9,
      upperBound: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(), // Effetto pressione
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isPlaying ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.isPlaying
                ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 5,
              ),
            ]
                : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Immagine di sfondo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  widget.sound.imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              // Overlay per indicare il suono attivo
              AnimatedOpacity(
                opacity: widget.isPlaying ? 0.3 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.sound.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Icona animata quando il suono è attivo
              if (widget.isPlaying)
                Positioned(
                  bottom: 8,
                  child: AnimatedOpacity(
                    opacity: widget.isPlaying ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.music_note, color: Colors.white, size: 30),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
