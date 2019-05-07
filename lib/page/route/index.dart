import 'package:flutter/material.dart';
import 'package:gdg_weather/page/weather/WeatherWidget.dart';
import 'package:gdg_weather/page/city/CityWidget.dart';
class myRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherWidget(), // becomes the route named '/'
      routes: <String, WidgetBuilder>{       
        '/city': (BuildContext context) => CityWidget(),
      },
    );
  }
}
