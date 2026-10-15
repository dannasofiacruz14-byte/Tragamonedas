// lib/screens/game_screen.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/result_dialog.dart';
import '../widgets/rodillos_widget.dart'; 

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _girando = false; // true mientras la máquina gira

  void _girar() {
    if (_girando) return; // evita girar dos veces seguidas
    setState(() {
      _girando = true;
    });
  }

  // Se ejecuta automáticamente al finalizar la animación de los 3 rodillos
  void _alTerminarGiro(List<String> resultados) {
    if (!mounted) return;

    setState(() {
      _girando = false;
    });

    // PROVISIONAL: Evaluación básica hasta que el Integrante 3 conecte sus listas
    // Verifica si los 3 símbolos son idénticos
    final bool esPremio = resultados[0] == resultados[1] && resultados[1] == resultados[2];
    final String mensaje = esPremio ? '¡Felicidades! Ganas un premio' : 'Haz 10 sentadillas';

    mostrarResultado(context, esPremio: esPremio, mensaje: mensaje);
  }

  // Cuerpo rojo de la máquina con el título, los rodillos y las luces
  Widget _cuerpoMaquina() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.maquina, AppColors.maquinaOscura],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.dorado, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'JACKPOT',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.dorado,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24, width: 2),
            ),


            //  Componente de los rodillos con animación
            child: SlotMachineReels(
              girando: _girando,
              onAnimationComplete: _alTerminarGiro,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Luz(color: Colors.red),
              _Luz(color: Colors.blue),
              _Luz(color: Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondo,
      appBar: AppBar(
        title: const Text('Tragamonedas de Retos'),
        centerTitle: true,
        backgroundColor: AppColors.maquinaOscura,
        foregroundColor: AppColors.dorado,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Máquina + palanca al lado
              Row(
                children: [
                  Expanded(child: _cuerpoMaquina()),
                  const SizedBox(width: 10),
                  _Palanca(onTap: _girando ? null : _girar),
                ],
              ),
              const SizedBox(height: 24),
              // Botón grande de giro
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _girando ? null : _girar,
                  icon: const Icon(Icons.casino, size: 28),
                  label: Text(
                    _girando ? 'GIRANDO...' : '¡GIRAR!',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dorado,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Leyenda
              const Row(
                children: [
                  _Luz(color: AppColors.premioInicio, tamano: 14),
                  SizedBox(width: 6),
                  Text('3 iguales: Premio', style: TextStyle(color: Colors.white70)),
                  Spacer(),
                  Text('Si no: Castigo', style: TextStyle(color: Colors.white70)),
                  SizedBox(width: 6),
                  _Luz(color: AppColors.castigoInicio, tamano: 14),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Palanca (tirador) de la máquina
class _Palanca extends StatelessWidget {
  final VoidCallback? onTap;
  const _Palanca({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 6)],
            ),
          ),
          Container(
            width: 10,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}

// Luz circular decorativa
class _Luz extends StatelessWidget {
  final Color color;
  final double tamano;
  const _Luz({required this.color, this.tamano = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}