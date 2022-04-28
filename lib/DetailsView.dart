
import 'package:f1calendarflutter/data/model/Weather.dart';
import 'package:flutter/material.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget> [
        Card(
          elevation: 20,
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const SizedBox(
            child:
              Center(child: Text('RaceDetails', style: TextStyle(fontSize: 50))),
          )
        ),
    ]
    );
  }

}

