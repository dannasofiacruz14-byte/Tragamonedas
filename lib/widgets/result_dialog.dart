import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


void mostrarResultado(
  BuildContext context, {
  required bool esPremio,
  required String mensaje,
}) {
  showDialog(
    context: context,
    barrierDismissible: false, 
    builder: (BuildContext contextDialogo) {
      return ResultDialog(esPremio: esPremio, mensaje: mensaje);
    },
  );
}

class ResultDialog extends StatelessWidget {
  final bool esPremio;
  final String mensaje;

  const ResultDialog({
    super.key,
    required this.esPremio,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    final Color colorA = esPremio ? AppColors.premioInicio : AppColors.castigoInicio;
    final Color colorB = esPremio ? AppColors.premioFin : AppColors.castigoFin;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorA, colorB],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              esPremio ? Icons.emoji_events : Icons.warning_amber_rounded,
              size: 72,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              esPremio ? '¡PREMIO!' : '¡CASTIGO!',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                mensaje,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorA,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Jugar otra vez', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}