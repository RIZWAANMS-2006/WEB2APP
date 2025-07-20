import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';
import "dart:async";
import 'weather_info.dart';

class HomePage_Components extends StatefulWidget {
  const HomePage_Components({super.key});
  @override
  State<StatefulWidget> createState() {
    return HomePage_Components_State();
  }
}

class HomePage_Components_State extends State<HomePage_Components> {
  late DateTime digitalclock;
  Timer? timer;
  int hour = 0;
  int minute = 0;
  String noon = "";
  String day = "";
  String date = "";
  String month = "";
  String year = "";
  late Stream<Widget?> weatherStreamVariable;
  @override
  void initState() {
    super.initState();
    weatherStreamVariable = weatherDetailsFunction();
    digitalclock = DateTime.now();
    day = digitalclock.weekday == 1
        ? "Monday"
        : digitalclock.weekday == 2
        ? "Tuesday"
        : digitalclock.weekday == 3
        ? "Wednesday"
        : digitalclock.weekday == 4
        ? "Thusday"
        : digitalclock.weekday == 5
        ? "Friday"
        : digitalclock.weekday == 6
        ? "Saturday"
        : "Sunday";
    date = digitalclock.day.toString() == 1
        ? "0$digitalclock.day"
        : digitalclock.day.toString();
    month = digitalclock.month.toString() == 1
        ? "0$digitalclock.month"
        : digitalclock.month.toString();
    year = digitalclock.year.toString();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        digitalclock = DateTime.now();
        hour = digitalclock.hour.toInt() % 12;
        minute = digitalclock.minute;
        noon = digitalclock.hour >= 12 ? "PM" : "AM";
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MediaQuery.of(context).size.width < 600
            ? MainAxisAlignment.center
            : MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${(hour == 0 && noon == "PM")
                      ? 12
                      : hour.toString().length == 1
                      ? "0$hour"
                      : hour}:${minute.toString().length == 1 ? "0$minute" : minute} ${noon}",
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "$date/$month/$year $day",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: StreamBuilder(
                    stream: weatherStreamVariable,
                    initialData: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Transform.scale(
                          scale: 0.5,
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(child: snapshot.data!);
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Internet_Status extends StatefulWidget {
  const Internet_Status({super.key});
  @override
  State<Internet_Status> createState() {
    return Internet_Status_State();
  }
}

class Internet_Status_State extends State<Internet_Status> {
  late bool status;
  late bool timerofinternetconnected = true;
  Future<bool> internet_Status() async {
    bool status = await InternetConnectionChecker.instance.hasConnection;
    return status;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        timerofinternetconnected = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: internet_Status(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return timerofinternetconnected == true
              ? Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.green,
                  alignment: Alignment.center,
                  child: Text(
                    "Internet Connected",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(height: 20, color: Colors.transparent);
        } else {
          return Container(
            height: 20,
            width: double.infinity,
            color: Colors.red,
            alignment: Alignment.center,
            child: Text(
              "No Internet Connected",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      },
    );
  }
}

class WeatherBackground extends StatefulWidget {
  const WeatherBackground({super.key});
  @override
  State<WeatherBackground> createState() {
    return WeatherBackground_State();
  }
}

class WeatherBackground_State extends State<WeatherBackground> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: WeatherScene.weatherEvery.sceneWidget,
      stream: WeatherBackgroundFunction(),
      builder: (content, snapshot) {
        if (snapshot.data != null) {
          return snapshot.data!;
        } else {
          return Container();
        }
      },
    );
  }
}
