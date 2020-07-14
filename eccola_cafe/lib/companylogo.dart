import 'package:flutter/material.dart';
import 'dart:math';

class CompanyLogo extends StatefulWidget {
  const CompanyLogo({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  _CompanyLogoState createState() => _CompanyLogoState();
}

class _CompanyLogoState extends State<CompanyLogo> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topRight,
      children: [
        CustomPaint(
          painter: LogoPaint(),
          child: ClipPath(
            clipper: LogoClipper(),
            child: Container(
                width: widget.width,
                decoration: BoxDecoration(
                    color: Color(0xffACA7A3),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30))),
                height: 200,
                child: Transform.rotate(
                  angle: -pi / 30,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ecco'la",
                            style: TextStyle(shadows: [
                              Shadow(
                                  blurRadius: 0.6,
                                  color: Colors.white,
                                  offset: Offset(1, 1))
                            ], fontSize: 50, fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "CAFE AND PIZZERIA",
                            style: TextStyle(shadows: [
                              Shadow(
                                  blurRadius: 0.6,
                                  color: Colors.white,
                                  offset: Offset(1, 1))
                            ], fontSize: 18, fontStyle: FontStyle.italic),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ),
        Positioned(
          top: -10,
          right: -30,
          child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1494548162494-384bba4ab999?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80"))),
              child: Text("")),
        )
      ],
    );
  }
}

class LogoPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(0, 30);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.quadraticBezierTo(size.width / 2, size.height / 2, 0, size.height);

    path.close();
    // path.close();
    canvas.drawShadow(path, Colors.black, 50, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class LogoClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 30);
    path.lineTo(size.width, 0);

    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> customClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
