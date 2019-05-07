import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdg_weather/page/city/CityData.dart';
import 'package:flutter/services.dart' show rootBundle;

class CityWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CityState();
  }
}

class CityState extends State<CityWidget> {
  List<CityData> cityList = new List<CityData>();

  CityState() {
    _getCityList();
  }

  void _getCityList() async {
    List<CityData> citys = await _fetchCityList();
    setState(() {
      cityList = citys;
    });
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/city.json');
  }

  //拉取城市列表
  Future<List<CityData>> _fetchCityList() async {
    String response =await loadAsset();
    List<CityData> cityList = new List<CityData>();
    for(dynamic data in jsonDecode(response)){
      CityData cityData = CityData(data['cityZh']);
      cityList.add(cityData);      
    }
    return cityList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemCount: cityList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: GestureDetector(
              child: Text(cityList[index].cityName),
              onTap: () {
                Navigator.pop(context, cityList[index].cityName);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             WeatherWidget(cityList[index].cityName)));
              },
            ),
          );
        });
  }
}
