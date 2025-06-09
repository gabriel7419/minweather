import 'package:flutter/material.dart';
import 'package:minweather/models/weather_model.dart';
import 'package:minweather/service/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('23b03beb8cacb24d767e0102096e8e5c');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // obtém o nome da cidade atual
    String cityName = await _weatherService.getCurrentCity();
    // clima para a cidade
    try {
      Weather weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
      // caso tenha algum erro
    } catch (e) {
      // tratamento de erro
      print('Erro ao obter clima: $e');
    }
  }

  // animações de clima
  String getWeatherAnimation(String? condition) {
    switch (condition) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json'; // animação padrão
    }
  }

  //  estado inicial
  @override
  void initState() {
    super.initState();
    // chama a função de buscar clima
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // nome da cidade
          Text(
            _weather?.cityName ?? 'Carregando...',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          // animação
          Lottie.asset(getWeatherAnimation(_weather?.condition)),
          // temperatura
          Text(
            _weather != null
                ? '${_weather!.temperature.toStringAsFixed(1)}°C'
                : 'Carregando...',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),

          // condição do clima
          Text(_weather?.condition ?? ""),
        ],
      ),
    );
  }
}
