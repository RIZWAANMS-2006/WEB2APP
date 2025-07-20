import 'dart:io';
import "package:flutter/services.dart";
import 'package:flutter/material.dart';
import "package:webview_all/webview_all.dart";
import 'homepage_components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  runApp(const Web2App());
}

class Web2App extends StatelessWidget {
  const Web2App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: homePage());
  }
}

// ignore: must_be_immutable
class web2AppConverter extends StatefulWidget {
  web2AppConverter({super.key, required this.url});
  String? url;
  @override
  State<StatefulWidget> createState() {
    return web2AppConverter_State();
  }
}

class homePage extends StatefulWidget {
  const homePage({super.key});
  @override
  State<homePage> createState() {
    return homePage_State();
  }
}

class homePage_State extends State<homePage> {
  int normalPadding = 100;
  int ontapPadding = 180;
  final formkey = GlobalKey<FormState>();
  late double normalWidth;
  late double ontapWidth;
  bool widthState = false;

  @override
  Widget build(BuildContext context) {
    if (!widthState && MediaQuery.of(context).size.width > 600) {
      normalWidth = MediaQuery.of(context).size.width * 0.5;
      ontapWidth = normalWidth + 100;
      widthState = true;
    }
    if (!widthState && MediaQuery.of(context).size.width < 600) {
      normalWidth = MediaQuery.of(context).size.width - 10;
      ontapWidth = normalWidth;
      widthState = true;
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            if (MediaQuery.of(context).size.width > 600) {
              normalWidth = MediaQuery.of(context).size.width * 0.5;
              normalPadding = 100;
            } else {
              normalWidth = MediaQuery.of(context).size.width - 10;
              normalPadding = 100;
            }
          });
        },
        child: Stack(
          children: [
            SizedBox.expand(child: WeatherBackground()),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomePage_Components(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: AnimatedContainer(
                      curve: Curves.fastEaseInToSlowEaseOut,
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.only(
                        bottom: Platform.isWindows
                            ? normalPadding.toDouble()
                            : 100,
                      ),
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 250),
                        width: normalWidth,
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
                                          normalWidth = ontapWidth;
                                          normalPadding = ontapPadding;
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
                                      // ignore: body_might_complete_normally_nullable
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
                                        }
                                      },
                                      onSaved: (newValue) {
                                        if (formkey.currentState!.validate()) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  web2AppConverter(
                                                    url: newValue!,
                                                  ),
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

class web2AppConverter_State extends State<web2AppConverter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Platform.isWindows
          ? AppBar(
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
            )
          : null,
      body: SafeArea(
        child: Container(child: Webview(url: "https://" + widget.url!)),
      ),
    );
  }
}
