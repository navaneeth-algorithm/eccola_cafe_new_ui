import 'package:flutter/material.dart';
import 'dart:convert';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ondelivery.dart';
import 'phonenumberpage.dart';
import 'package:http/http.dart' as http;
import 'orderpage.dart';
import 'companylogo.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(
        backgroundColor: Color(0xffFBC601), //Color(0xff304059),
        body: HomePageContainer(),
      )),
    );
  }
}

class HomePageContainer extends StatefulWidget {
  @override
  _HomePageContainerState createState() => _HomePageContainerState();
}

class HomePageModal {
  String companyname = "";
  String imageurl = "";
  String desc1 = "";
  String desc2 = "";
  String btn1 = "";
  String btn2 = "";
  String heading;

  HomePageModal(
      {this.companyname,
      this.imageurl,
      this.desc1,
      this.desc2,
      this.btn1,
      this.btn2,
      this.heading});
}

bool validsession;
String sessionid;
String postcode;
HomePageModal homePageData;

class _HomePageContainerState extends State<HomePageContainer> {
  Future _fetchdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var usersession = prefs.getString('usersession');
      print(usersession);
      sessionid = usersession == null ? "" : usersession;
      //  print(usersession);
      // Map data = {"premise_id": premise_id, "session_id": sessionid};
      // Map data = {"email": "hanson@gmail.com", "password": "123"};
      // print(data);
      //submitDialog(context);

      //  var body = json.encode(data);

      http.Response response = await http.get(
          "https://test.eccolacafedelivery.com/api/v1/takeway?premise_id=" +
              premise_id.toString() +
              "&&session_id=" +
              sessionid,
          headers: {"Content-Type": "application/json"});

      print("https://test.eccolacafedelivery.com/api/v1/takeway?premise_id=" +
          premise_id.toString() +
          "&&session_id=" +
          sessionid);

      var dataUser = json.decode(response.body);

      if (!dataUser.containsKey("error")) {
        return dataUser;
      }
    } on Exception catch (e) {
      print(e.toString());
    }

    // Navigator.pop(context);
  }

  validateOtp(ordertype) async {
    var otp = sessionid.toString().split("*")[2];
    String phonesessionid = sessionid.toString().split("*")[1];
    // print(postcode);
    var postcodeotp = ordertype == 1 ? postcode : null;
    String o1, o2, o3, o4;

    var otplist = otp.toString().split("");
    o1 = otplist[0].toString();
    o2 = otplist[1].toString();
    o3 = otplist[2].toString();
    o4 = otplist[3].toString();
    //print(o1);

    Map data = {
      "premise_id": premise_id,
      "postcode": postcodeotp,
      "o1": o1,
      "o2": o2,
      "o3": o3,
      "o4": o4,
      "phone_session_id": phonesessionid
    };
    // print(data);
    // Map data = {"email": "hanson@gmail.com", "password": "123"};

    //submitDialog(context, msg: "Validating OTP");

    var body = json.encode(data);

    http.Response response = await http.post(
        "https://test.eccolacafedelivery.com/api/v1/takeway/validate_otp",
        headers: {"Content-Type": "application/json"},
        body: body);
    //await Navigator.pop(context);

    var dataUser = json.decode(response.body);
    // Map mapData = dataUser;

    // print("Respose  got for validate_otp");
    //[name, order_type, delivery_charge, order_history_list, active_order_list, current_order, menu_items, status]
    //print(dataUser["menu_items"].toString());

    if (dataUser["status"] != 401) {
      //setUserId(usersession);
      //print(dataUser);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => (OrderPage(
                    otpdata: data,
                    orderpagedata: dataUser,
                  ))));
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
    return Center(
      child: FutureBuilder(
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
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "Error in Server..Retry Some again later or Check your Internet Connection",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textcolor),
                ),
              );
            } else {
              validsession = snapshot.data["valid_session"];
              postcode = snapshot.data["postcode"];
              print(snapshot.data);
              //print(snapshot.data["postcode"]);
              homePageData = new HomePageModal(
                companyname: snapshot.data["name"],
                imageurl: snapshot.data["image_url"],
                heading: snapshot.data["heading"],
                desc1: snapshot.data["desc1"],
                desc2: snapshot.data["desc2"],
                btn1: snapshot.data["btn1"],
                btn2: snapshot.data["btn2"],
              );

              // print(homePageData.companyname);

              // print(snapshot.data);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /* Text(
                    "" + homePageData.heading,
                    style: TextStyle(color: textcolor, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "" + homePageData.desc1,
                    style: TextStyle(color: textcolor, fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "" + homePageData.desc2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textcolor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),*/

                  SizedBox(
                    height: 20,
                  ),
                  CompanyLogo(width: width),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "WELCOME",
                    style: TextStyle(fontSize: 29),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Choose how you want to",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "recieve our food",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 300,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        //  print("DELIVERY ORDER TYPE");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OnDeliveryPage(
                                      companyName: homePageData.companyname,
                                      validsession: validsession,
                                    )));
                      },
                      child: Text(
                        "" + homePageData.btn1,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 300,
                    child: RaisedButton(
                      color: Colors.white,
                      onPressed: () {
                        // print("COLLECTION ORDER TYPE");

                        if (validsession) {
                          validateOtp(2);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PhoneNumberPage(
                                        postalcode: "",
                                      )));
                        }
                      },
                      child: Text(
                        "" + homePageData.btn2,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Ecco'la Cafe and Pizzeria",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.5)),
                  ),
                  Text(
                    "020 8618 0262 - 020 8127 6434",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.5)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "",
                        style: TextStyle(color: buttontextcolor),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
