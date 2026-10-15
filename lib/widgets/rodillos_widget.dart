import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/game_logic.dart';

class SlotMachineReels extends StatefulWidget {
  final bool girando;

  final List<String>? resultadosFinales;

  final Function(List<String> resultadosFinales)? onAnimationComplete;

  const SlotMachineReels({
    super.key,
    required this.girando,
    this.resultadosFinales,
    this.onAnimationComplete,
  });

  @override
  State<SlotMachineReels> createState() => _SlotMachineReelsState();
}

class _SlotMachineReelsState extends State<SlotMachineReels> {

  final List<String> _simbolos = JuegoLogica.simbolos;

  late List<ScrollController> _controllers;
  late List<Timer?> _timers;

  List<String> _simbolosVisibles = ['7️⃣', '7️⃣', '7️⃣'];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (_) => ScrollController());
    _timers = List.filled(3, null);
  }

  @override
  void didUpdateWidget(covariant SlotMachineReels oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.girando && !oldWidget.girando) {
      _iniciarGiro();
    }
  }

  void _iniciarGiro() {
    final random = Random();

    final List<String> resultadosFinales = widget.resultadosFinales ??
        List.generate(3, (_) => _simbolos[random.nextInt(_simbolos.length)]);

    final tiemposParada = [2000, 3000, 4000];

    for (int i = 0; i < 3; i++) {
      _animarRodillo(i, tiemposParada[i], resultadosFinales[i]);
    }

    Future.delayed(const Duration(milliseconds: 4500), () {
      if (mounted) {
        setState(() {
          _simbolosVisibles = List.of(resultadosFinales);
        });
        if (widget.onAnimationComplete != null) {
          widget.onAnimationComplete!(resultadosFinales);
        }
      }
    });
  }

  void _animarRodillo(int index, int duracionMs, String resultadoFinal) {
    const int velocidadLoop = 50; // Velocidad del desplazamiento
    int tiempoTranscurrido = 0;

    _timers[index]?.cancel();
    _timers[index] = Timer.periodic(const Duration(milliseconds: velocidadLoop), (timer) {
      tiempoTranscurrido += velocidadLoop;

      if (tiempoTranscurrido >= duracionMs) {
        timer.cancel();
        setState(() {
          _simbolosVisibles[index] = resultadoFinal;
        });
      } else {
        setState(() {
          _simbolosVisibles[index] = _simbolos[Random().nextInt(_simbolos.length)];
        });
      }
    });
  }

  @override
  void dispose() {
    for (var timer in _timers) {
      timer?.cancel();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (index) => _buildSingleReel(index)),
    );
  }

  Widget _buildSingleReel(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade700, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            child: Text(
              _simbolosVisibles[index],
              key: ValueKey<String>('${_simbolosVisibles[index]}_$index'),
              style: const TextStyle(fontSize: 48),
            ),
          ),
        ),
      ),
    );
  }
}