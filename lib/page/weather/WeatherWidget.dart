import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/weather/WeatherData.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; //文件读取
import 'package:flutter/services.dart' show rootBundle;

class WeatherWidget extends StatefulWidget {
  String cityName = '';

  WeatherWidget();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new WeatherState(this.cityName);
  }
}

class WeatherState extends State<WeatherWidget> {
  String cityName;

  WeatherData weather = WeatherData.empty();

  WeatherState(String cityName) {
    //print('第一次进来'+cityName2);

    this.cityName = cityName;
    _getWeather();
  }

  void _getWeather() async {
    if (this.cityName == '' || this.cityName == null) {
      this.cityName = await _readCityName();
    }
    if (this.cityName == '' || this.cityName == null) {
      this.cityName = '巴南';
    }
    await writeFile(this.cityName);
    WeatherData data = await _fetchWeather();
    setState(() {
      weather = data;
    });
  }

  Future<WeatherData> _fetchWeather() async {
    final response =
        await http.get('https://www.tianqiapi.com/api/?city=' + this.cityName);
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      return WeatherData.empty();
    }
  }

  //缓存处理
  localFile(path) async {
    return new File('$path/cityName.txt');
  }
  localPath() async {
    try {
      var appDocDir = await getApplicationDocumentsDirectory();
      return appDocDir.path;
    } catch (err) {
      print(err);
    }
  }
  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/cityName.txt');
  }
  //缓存处理读文件
  Future<String> _readCityName() async {
    try {
        final file = await localFile(await localPath());
        String str = await file.readAsString();
        return str;
    }
    catch (err) {
        print(err);
    }
  }
  // 写入 json 数据
  writeFile(obj) async {
    try {
      final file = await localFile(await localPath());
      return file.writeAsString(obj);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    initState() {
      print("cityName");
    }

    // TODO: implement build
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/weather_bg.jpg",
            fit: BoxFit.fitHeight,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 40.0),
                  child: GestureDetector(
                      child: Text(
                        this.cityName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          color: Colors.blue,
                          fontSize: 30.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/city').then((value) {
                          print('参数：' + value);
                          this.cityName = value;
                          _getWeather();
                        });
                      })),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 100.0),
                child: Column(
                  children: <Widget>[
                    Text(weather?.tmp,
                        style: new TextStyle(
                          color: Colors.blue,
                          fontSize: 80.0,
                        )),
                    Text(weather?.cond,
                        style:
                            new TextStyle(color: Colors.blue, fontSize: 45.0)),
                    Text(
                      weather?.hum,
                      style: new TextStyle(color: Colors.blue, fontSize: 15.0),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
