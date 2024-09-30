import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleNabvarMenu extends StatelessWidget {
  final String text;

  const TitleNabvarMenu({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => _gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 35 ,
          fontWeight: FontWeight.w800, // Ajustar grosor si lo necesitas más fuerte
          color: Colors.white, // El color será sobreescrito por el ShaderMask
        ),
      ),
    );
  }

  static const Gradient _gradient = LinearGradient(
    colors: [
      Color(0xFFFFAFAF), 
      Color(0xFFAA66FF), 
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}