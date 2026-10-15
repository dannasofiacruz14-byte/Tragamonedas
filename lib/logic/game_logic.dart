import 'dart:math';

enum TipoResultado { premio, castigo }

class ResultadoJuego {
  final List<String> rodillos;
  final TipoResultado tipo;
  final String mensaje;

  const ResultadoJuego({
    required this.rodillos,
    required this.tipo,
    required this.mensaje,
  });

  bool get esPremio => tipo == TipoResultado.premio;
}

class JuegoLogica {
  JuegoLogica({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const List<String> simbolos = ['🍒', '🔔', '⭐', '💎', '7️⃣', '💀'];

  static const List<String> premios = [
    'Elige quién toma y cuántos trago',
    'Elige a alguien que haga tu próximo castigo por ti',
    'Puedes cambiar un castigo por un trago',
    'Te libras del próximo castigo',
    'Haz una pregunta a todos y cada uno debe responder con sinceridad',
  ];

  static const List<String> castigos = [
    'Deja que el grupo escriba un mensaje con tu teléfono y lo mande a quien ellos elijan',
    'Mándale un audio coqueto a un amigo y que él decida si lo borras.',
    'Toma un trago sin usar las manos',
    'Toma dos tragos',
    'Muestra tu última búsqueda de Google o tu último chat de WhatsApp',
  ];

  static const double probabilidadPremio = 0.5;

  T _elegir<T>(List<T> lista) => lista[_random.nextInt(lista.length)];

  List<String> _generarRodillos({required bool premio}) {
    if (premio) {
      final s = _elegir(simbolos);
      return [s, s, s];
    }
    List<String> rodillos;
    do {
      rodillos = List.generate(3, (_) => _elegir(simbolos));
    } while (rodillos.every((s) => s == rodillos.first));
    return rodillos;
  }

  ResultadoJuego girar() {
    final premio = _random.nextDouble() < probabilidadPremio;
    final rodillos = _generarRodillos(premio: premio);

    return ResultadoJuego(
      rodillos: rodillos,
      tipo: premio ? TipoResultado.premio : TipoResultado.castigo,
      mensaje: premio ? _elegir(premios) : _elegir(castigos),
    );
  }
}