import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onBackPressed;

  const ErrorDialog({
    required this.title,
    required this.message,
    required this.onBackPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 354,
          maxHeight: 315,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 71, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFFDEDED), // Fondo rojo claro para el error
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 121,
              height: 121,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  '../assets/img/error_form.png', 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.red, // Color de texto para enfatizar el error
              ),
            ),
            const SizedBox(height: 17),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Carrois Gothic SC',
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 21),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onBackPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Color rojo para botón de error
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  minimumSize: const Size(70, 24),
                ),
                child: const Text(
                  'Entendido',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
