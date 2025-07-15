import "dart:async";
import 'dart:io';
import "package:flutter/services.dart";
import 'package:weatherapi/weatherapi.dart';
import 'package:flutter/material.dart';
import "package:webview_all/webview_all.dart";
import "package:video_player/video_player.dart";
import "package:video_player_win/video_player_win.dart";
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const mainApp());
}

class mainApp extends StatelessWidget {
  const mainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: homepage());
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});
  @override
  State<homepage> createState() {
    return homepage_State();
  }
}

class web2app extends StatefulWidget {
  web2app({super.key, required this.url});
  String? url;
  @override
  State<StatefulWidget> createState() {
    return web2app_State();
  }
}

class Digital_Clock_homepage_components extends StatefulWidget {
  const Digital_Clock_homepage_components({super.key});
  @override
  State<StatefulWidget> createState() {
    return Digital_Clock_homepage_components_State();
  }
}

class homepage_State extends State<homepage> {
  late WinVideoPlayerController wvcontroller;
  late VideoPlayerController controller;
  int normal_padding = 100;
  int ontap_padding = 180;
  final formkey = GlobalKey<FormState>();
  late double normal_width;
  late double ontap_width;
  bool width_State = false;

  @override
  void initState() {
    if (Platform.isWindows) {
      wvcontroller = WinVideoPlayerController.file(
        File(
          "D:\\Codeing\\dart (Flutter)\\web2app\\assets\\music_control_infiniteloop_wallpaper1.mp4",   //Make Sure to have this .mp4 video in the location for the video to play in the background
        ),
      );
      wvcontroller!.initialize().then((value) {
        if (wvcontroller!.value.isInitialized) {
          wvcontroller!.play();
          wvcontroller!.setLooping(true);
          wvcontroller!.setPlaybackSpeed(2.0);
          setState(() {});
        }
      });
      setState(() {});
    } else {
      controller =
          VideoPlayerController.asset(
              "assets/music_control_infiniteloop_wallpaper.mp4",
            )
            ..initialize().then((_) {
              setState(() {});
              controller.play();
              controller.setLooping(true);
              controller.setPlaybackSpeed(2.0);
            });
    }
    super.initState();
  }

  @override
  void dispose() {
    if (Platform.isWindows) {
      wvcontroller!.dispose();
      super.dispose();
    } else {
      controller.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!width_State && MediaQuery.of(context).size.width > 600) {
      normal_width = MediaQuery.of(context).size.width * 0.5;
      ontap_width = normal_width + 100;
      width_State = true;
    }
    if (!width_State && MediaQuery.of(context).size.width < 600) {
      normal_width = MediaQuery.of(context).size.width - 10;
      ontap_width = normal_width;
      width_State = true;
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            if (MediaQuery.of(context).size.width > 600) {
              normal_width = MediaQuery.of(context).size.width * 0.5;
              normal_padding = 100;
            } else {
              normal_width = MediaQuery.of(context).size.width - 10;
              normal_padding = 100;
            }
          });
        },
        child: Stack(
          children: [
            Platform.isWindows
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: wvcontroller.value.size.width,
                        height: wvcontroller.value.size.height,
                        child: WinVideoPlayer(wvcontroller),
                      ),
                    ),
                  )
                : VideoPlayer(controller),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Digital_Clock_homepage_components(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: AnimatedContainer(
                      curve: Curves.fastEaseInToSlowEaseOut,
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.only(
                        bottom: Platform.isWindows? normal_padding.toDouble(): 100,
                      ),
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 250),
                        width: normal_width,
                        height: 40,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.black54, Colors.black45],
                                    ),
                                    backgroundBlendMode: BlendMode.darken,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    border: Border(
                                      top: BorderSide(
                                        color: Colors.white38,
                                        width: 1,
                                      ),
                                      bottom: BorderSide(
                                        color: Colors.white38,
                                        width: 1,
                                      ),
                                      left: BorderSide(
                                        color: Colors.white38,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Form(
                                    key: formkey,
                                    child: TextFormField(
                                      onTap: () {
                                        setState(() {
                                          normal_width = ontap_width;
                                          normal_padding = ontap_padding;
                                        });
                                      },
                                      maxLines: 1,
                                      expands: false,
                                      keyboardAppearance: Brightness.dark,
                                      keyboardType: TextInputType.url,
                                      textAlign: TextAlign.center,
                                      cursorColor: Colors.redAccent,
                                      decoration: InputDecoration(
                                        hintText: "Enter the URL",
                                        border: InputBorder.none,
                                        fillColor: Colors.redAccent,
                                        alignLabelWithHint: true,
                                        errorStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 0,
                                        ),
                                        errorMaxLines: 1,
                                        hintStyle: TextStyle(
                                          color: Colors.white38,
                                        ),
                                        isDense: true,
                                        contentPadding: EdgeInsets.only(
                                          top: 10,
                                          right: 15,
                                          left: 15,
                                        ),
                                      ),
                                      style: TextStyle(color: Colors.white),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Enter a valid URL",
                                              ),
                                            ),
                                          );
                                          return "";
                                        }
                                      },
                                      onSaved: (newValue) {
                                        if (formkey.currentState!.validate()) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  web2app(url: newValue!),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () => formkey.currentState!.save(),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white38,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.white38,
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.white38,
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: Colors.white38,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Internet_Status(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class web2app_State extends State<web2app> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Platform.isWindows?
      AppBar(
        title: Center(
          child: Text(
            "Webview",
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        toolbarHeight: 25,
        leading: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 15),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ):null,
      body: SafeArea(child: Container(child: Webview(url: "https://" + widget.url!))),
    );
  }
}

Future<Widget?> weather() async {
  WeatherRequest wr = WeatherRequest(
    'YOUR API-KEY',
    language: Language.english,
  );
  RealtimeWeather rw = await wr.getRealtimeWeatherByCityName("chennai");
  String? temp = rw.current.condition.text;
  if (temp!.toLowerCase().contains('sun') ||
      temp!.toLowerCase().contains('clear')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.sunny, color: Colors.yellow.withOpacity(0.7), size: 30),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  if (temp!.toLowerCase() == 'thunder' ||
      temp!.toLowerCase().contains('light')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.thunderstorm,
          color: Colors.blueGrey.withOpacity(0.7),
          size: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  if (temp!.toLowerCase().contains('rain') ||
      temp!.toLowerCase().contains('drizzle') ||
      temp!.toLowerCase().contains('shower')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(
          Icons.water_drop,
          color: Colors.lightBlue.withOpacity(0.7),
          size: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  if (temp!.toLowerCase() == 'partly cloudy' ||
      temp!.toLowerCase().contains('cloudy') ||
      temp!.toLowerCase().contains('overcast')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.cloud, color: Colors.white24, size: 30),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  if (temp!.toLowerCase() == 'snow' ||
      temp!.toLowerCase().contains('ice') ||
      temp!.toLowerCase().contains('freez')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.snowing, color: Colors.white12, size: 30),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  if (temp!.toLowerCase() == 'mist' || temp!.toLowerCase().contains('fog')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.air, color: Colors.white, size: 30),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  if (temp!.toLowerCase() == 'dust' ||
      temp!.toLowerCase().contains('blizzard')) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.air, color: Colors.white, size: 30),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  } else {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(Icons.sunny, color: Colors.yellow.withOpacity(0.7), size: 30),
        Padding(
          padding: const EdgeInsets.only(left: 7),
          child: Text(
            temp!,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class Digital_Clock_homepage_components_State
    extends State<Digital_Clock_homepage_components> {
  late DateTime digitalclock;
  Timer? timer;
  int hour = 0;
  int minute = 0;
  String noon = "";
  String day = "";
  String date = "";
  String month = "";
  String year = "";
  late Future<Widget?> weather_variable;
  @override
  void initState() {
    super.initState();
    weather_variable = weather();
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
                  child: FutureBuilder(
                    future: weather_variable,
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
              : Container(height: 20, color: Colors.transparent,);
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
