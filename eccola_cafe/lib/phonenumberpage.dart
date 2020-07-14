import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'otppage.dart';
import 'loadingscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'companylogo.dart';
import 'dart:convert';
import 'constants.dart';

import 'package:http/http.dart' as http;

class PhoneNumberPage extends StatelessWidget {
  String postalcode;

  PhoneNumberPage({this.postalcode});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color(0xffFBC601),
      body: PhoneNumberContainer(postalcode: this.postalcode),
    ));
  }
}

class PhoneNumberContainer extends StatefulWidget {
  String postalcode;
  PhoneNumberContainer({Key key, this.postalcode}) : super(key: key);
  @override
  _PhoneNumberContainerState createState() => _PhoneNumberContainerState();
}

class _PhoneNumberContainerState extends State<PhoneNumberContainer> {
  final _formKey = GlobalKey<FormState>();

  Future _fetchdata() async {
    Map data = {
      "premise_id": premise_id,
    };
    // Map data = {"email": "hanson@gmail.com", "password": "123"};

    //submitDialog(context);

    var body = json.encode(data);

    http.Response response = await http.get(
        "https://test.eccolacafedelivery.com/api/v1/takeway/get_otp?premise_id=" +
            premise_id.toString(),
        headers: {"Content-Type": "application/json"});

    var dataUser = json.decode(response.body);

    if (!dataUser.containsKey("error")) {
      //print(dataUser);
      return dataUser;
    }

    // Navigator.pop(context);
  }

  bool checkSocialmediaUrl(homepagedata) {
    return homepagedata["twitter_url"] != "" ||
            homepagedata["linked_in_url"] != "" ||
            homepagedata["linked_in_url"] != ""
        ? true
        : false;
  }

  _launchURL(url) async {
    //const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ackAlert(context, "ERROR", "Could not launch $url");
      //throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextEditingController _phonenumber = new TextEditingController();
    return FutureBuilder(
      future: _fetchdata(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(backgroundColor: Colors.blue),
              SizedBox(
                height: 10,
              ),
              Text(
                "Loading",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textcolor),
              ),
            ],
          );
        } else {
          return Stack(
            children: [
              CompanyLogo(width: width),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(1, 1),
                            spreadRadius: 1,
                            blurRadius: 10)
                      ],
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  height: (height / 2) + 120,
                  width: width,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Great news",
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "we deliver to your area",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "To start your online order please enter",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "your mobile phone number to get your",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "4 digit pass code",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 40),
                          child: Text(
                            "Mobile number",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          width: width - 80,
                          child: TextFormField(
                            controller: _phonenumber,
                            textAlign: TextAlign.center,
                            validator: (val) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(patttern);
                              if (val.length == 0) {
                                return 'Please enter mobile number';
                              } else if (!regExp.hasMatch(val)) {
                                return 'Please enter valid mobile number';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: textcolor),
                            decoration: InputDecoration(
                              counterText: "",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xff7D8CA1))),
                              hintStyle: TextStyle(color: Color(0xff7D8CA1)),
                            ),
                            maxLength: 11,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 200,
                        child: RaisedButton(
                          color: Color(0xffFBC601),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              print("Postal Code is " + this.widget.postalcode);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          (OtpPage(
                                            postalcode: this.widget.postalcode,
                                            phonenumber: _phonenumber.text,
                                            imageurl:
                                                snapshot.data["image_url"],
                                          ))));
                            }
                          },
                          child: Text(
                            "Get my 4 Digit Code",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),

                      /* checkSocialmediaUrl(snapshot.data)
                            ? Column(
                                children: [
                                  Text(
                                    "Reach us via Social media",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade300),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      snapshot.data["fb_url"] != ""
                                          ? IconButton(
                                              icon: Image.asset("images/fb.png"),
                                              onPressed: () {
                                                _launchURL(
                                                    snapshot.data["fb_url"]);
                                              })
                                          : Container(),
                                      snapshot.data["linked_in_url"] != ""
                                          ? IconButton(
                                              icon: Image.asset(
                                                  "images/linked_in.png"),
                                              onPressed: () {
                                                _launchURL(snapshot
                                                    .data["linked_in_url"]);
                                              })
                                          : Container(),
                                      snapshot.data["twitter_url"] != ""
                                          ? IconButton(
                                              icon: Image.asset(
                                                  "images/twitter.png"),
                                              onPressed: () {
                                                _launchURL(
                                                    snapshot.data["twitter_url"]);
                                              })
                                          : Container(),
                                    ],
                                  )
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Html(
                          data: snapshot.data["bottom_content"].toString(),
                          style: {
                            "p": Style(
                                textAlign: TextAlign.center,
                                color: Colors.grey.shade300),
                            "h6": Style(
                                textAlign: TextAlign.center,
                                color: Colors.grey.shade300),
                          },
                        ),*/
                    ],
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }
}
