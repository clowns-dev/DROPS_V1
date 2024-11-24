import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ps3_drops_v1/tools/session_manager.dart';
import 'package:ps3_drops_v1/views/users/login_view.dart';

class ApiMiddleware {
  Future<http.Response> makeRequest(
  BuildContext context,
  Future<http.Response> Function() request,
  ) async {
    try {
      final response = await request();
      if (response.statusCode == 401) {
        if (context.mounted) {
          await _handleTokenExpiration(context);
        }
      }

      return response;
    } catch (e) {
      throw Exception('Error en la solicitud HTTP: $e');
    }
  }


  Future<void> _handleTokenExpiration(BuildContext context) async {
    sessionManager.token = null;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Sesión Expirada'),
        content: const Text('Tu sesión ha expirado. Por favor, inicia sesión nuevamente.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}
