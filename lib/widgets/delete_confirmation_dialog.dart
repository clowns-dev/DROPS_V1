import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirmDelete;

  const DeleteConfirmationDialog({
    required this.onConfirmDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SizedBox(
        width: 336,
        height: 284,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 336,
                height: 284,
                decoration: ShapeDecoration(
                  color: const Color(0xFFE1F2E1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 51.25,
              top: 10.0,
              child: Column(
                children: [
                  Image.asset(
                    '../assets/img/interroga.png',
                    width: 116,
                    height: 124,
                  ),
                  const SizedBox(
                    width: 218.31,
                    height: 30,
                    child: Text(
                      '¿Eliminar?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Positioned(
              left: 33,
              top: 180,
              child: SizedBox(
                width: 270,
                height: 50,
                child: Text(
                  '¿Está seguro de que desea eliminar este registro?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
            Positioned(
              left: 93,
              top: 237,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el modal
                  onConfirmDelete();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9494),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(70, 31),
                ),
                child: const Text(
                  'Sí',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 197,
              top: 237,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF48E86B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(70, 31),
                ),
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1,
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
