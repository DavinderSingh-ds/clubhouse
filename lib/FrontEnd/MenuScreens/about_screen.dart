import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'About ClubHouse',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "A very Secure and Cool App,It provides messaging Facillity without interfering third pary person or even developer team.Very Secure reliable and cooling features app Made by @Davinder Singh.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.black87, fontSize: 16.0),
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       'Alert:  If you registered your mobile number and if any connection will call you, your number will visible in their call Logs.',
            //       textAlign: TextAlign.justify,
            //       style: TextStyle(color: Colors.redAccent, fontSize: 16.0),
            //     ),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0, left: 20.0, right: 20.0, top: 10.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Messages are End-to-End Encrypted',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.amber, fontSize: 16.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0, left: 20.0, right: 20.0, top: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Hope You Like this app',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: 20.0, left: 20.0, right: 20.0, top: 50.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Developer : - Davinder Singh \nBtech. IT \n 1907608\nFrom :- Earth',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
