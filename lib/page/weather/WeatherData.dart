class WeatherData{
  String cond; //天气
  String tmp; //温度
  String hum; //湿度

  WeatherData({this.cond, this.tmp, this.hum});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cond: json['data'][0]['wea'],
      tmp: json['data'][0]['tem'],
      hum: ""+json['data'][0]['air_tips'],
    );
  }

  factory WeatherData.empty() {
    return WeatherData(
      cond: "",
      tmp: "",
      hum: "",
    );
  }
}