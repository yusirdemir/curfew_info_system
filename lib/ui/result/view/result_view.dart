import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instagram_share/instagram_share.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultView extends StatefulWidget {
  final String name;
  final int age;
  final String date;
  final String workingBack;

  const ResultView({Key key, this.name, this.age, this.date, this.workingBack})
      : super(key: key);
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  bool calculate() {
    DateFormat dateFormat = DateFormat('MM/dd/yyyy hh:mm:ss');
    DateTime dateTime = dateFormat.parse(widget.date);
    if (!isWeekendDay(dateTime)) {
      // Haftaiçi
      if (widget.workingBack == 'Evet') return true;
      if (widget.age <= 20) {
        if (dateTime.hour <= 13 || dateTime.hour >= 16) return false;
        return true;
      } else {
        if (widget.age > 65) {
          if (dateTime.hour >= 10 || dateTime.hour <= 13) return true;
          return false;
        }
        return true;
      }
    } else {
      // Haftasonu
      if (dateTime.hour <= 10) return false;
      if (dateTime.hour >= 20) return false;
      if (dateTime.hour <= 20) {
        if (widget.age <= 20) {
          if (dateTime.hour <= 13 || dateTime.hour >= 16) return false;
          return true;
        } else {
          if (widget.age > 65) {
            if (dateTime.hour >= 10 || dateTime.hour <= 13) return true;
            return false;
          }
          return true;
        }
      }
    }
    return true;
  }

  bool isWeekendDay(DateTime date) {
    if (date.weekday == 6 || date.weekday == 7) {
      return true;
    }
    return false;
  }

  ScreenshotController screenshotController = ScreenshotController();
  bool shot = false;

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Sonuç'),
            backgroundColor: Colors.black87,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  calculate()
                      ? 'Dışarı Çıkabilirsiniz ${widget.name}'
                      : 'Dışarı Çıkamazsınız ${widget.name}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200.0,
                  child: Container(
                    height: 4,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    calculate()
                        ? 'Lütfen Maskenizi Takınız Ve Sosyal Mesafeye Kuralına Uyunuz.'
                        : 'Lütfen Evde Kalın.',
                    style: TextStyle(fontSize: 25.0, color: Colors.black87),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                shot
                    ? Container()
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        width: double.maxFinite,
                        child: RaisedButton(
                          onPressed: () async {
                            setState(() {
                              shot = true;
                            });
                            await screenshotController
                                .capture()
                                .then((File image) {
                              InstagramShare.share(image.path, 'image');
                            }).catchError((onError) {
                              print(onError);
                            });
                          },
                          padding: EdgeInsets.symmetric(vertical: 2),
                          elevation: 0.0,
                          color: Colors.black87,
                          textColor: Colors.white,
                          child: Text('İnstagramda Paylaş'),
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                shot
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        width: double.maxFinite,
                        child: RaisedButton(
                          onPressed: () {},
                          padding: EdgeInsets.symmetric(vertical: 2),
                          elevation: 0.0,
                          color: Colors.black87,
                          textColor: Colors.white,
                          child: Text('Link =>   https://bit.ly/curfew-apk'),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        width: double.maxFinite,
                        child: RaisedButton(
                          onPressed: () async {
                            const url = 'https://bit.ly/curfew_donation';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 2),
                          elevation: 0.0,
                          color: Color(0xff6c5ce7),
                          textColor: Colors.white,
                          child: Text('Bağış Yap'),
                        ),
                      )
              ],
            ),
          )),
    );
  }
}
