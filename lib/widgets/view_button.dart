import 'package:flutter/material.dart';

class ViewButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ViewButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD8BFD8), // Color lila similar al de la imagen
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Borde redondeado más pronunciado
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding similar
      ),
      onPressed: onPressed,
      icon: const Icon(
        Icons.visibility, // Icono de ojo
        color: Colors.purple, // Color similar al que se ve en la imagen
        size: 20,
      ),
      label: const Text(
        'Ver',
        style: TextStyle(
          color: Colors.purple, // Color del texto en morado
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
