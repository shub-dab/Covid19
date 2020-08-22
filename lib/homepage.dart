import 'dart:convert';

import 'package:covid_19/datasource.dart';
import 'package:covid_19/pages/countryPage.dart';
import 'package:covid_19/panels/infoPanel.dart';
import 'package:covid_19/panels/mostaffectedcountries.dart';
import 'package:covid_19/panels/worldwidepanel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Map worldData;

  fetchWorldWideData() async {
    http.Response response = await http.get('https://disease.sh/v3/covid-19/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;

  fetchCountryData() async {
    http.Response response = await http.get('https://disease.sh/v3/covid-19/countries');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchWorldWideData();
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COVID-19 TRACKER',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 100,
              alignment: Alignment.center,
              padding: EdgeInsets.all(4),
              color: Colors.black87,
              child: Text(DataSource.quote,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:10.0, horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Worldwide',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => CountryPage()
                      ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text('Regional',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            worldData == null ? CircularProgressIndicator() : WorldWidePanel(worldData: worldData,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 8.0),
              child: Text('Most Affected Countries',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 5,),
            countryData == null ? Container() : MostAffectedPanel(countryData: countryData,),
            SizedBox(height: 25,),
            InfoPanel(),
            SizedBox(height: 20,),
            Center(
              child: Text('WE ARE TOGETHER IN THE FIGHT!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),),
            ),
            SizedBox(height: 50,),
          ],
        )
      ),
    );
  }
}
