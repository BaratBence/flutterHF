import 'package:f1calendarflutter/bloc/weather_bloc.dart';
import 'package:f1calendarflutter/data/model/Weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'DetailsView.dart';

class WeatherSearchPage extends StatelessWidget {
  const WeatherSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  title: const Text("Weather Search"),
      //),
      body: Column(
        children: <Widget> [
          Card(
            elevation: 20,
              color: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
              ),
              child: const SizedBox(
                child:
                Center(child: Text('Race', style: TextStyle(fontSize: 50))),
              )
          ),
          BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if(state is WeatherError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                )
              );
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return buildInitialInput();
            } else if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(state.weather);

              /*return ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailsView()),
                  );
                },
                child: const Text('Enabled'),
              );*/
            } else {
              // (state is WeatherError)
              return buildInitialInput();
            }
          },
        ),
     ] ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildInitialInput() {
    return const CityInputField();
  }

  Widget buildColumnWithData(Weather weather) {
    /*return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget> [
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize:  30,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          "${weather.temperatureCelsius.toStringAsFixed(1)} C",
          style: const TextStyle(fontSize: 80),
        )
      ],
    );*/
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        itemCount: weather.names.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
            height: 50,
            color: Colors.amber,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children : <Widget> [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      weather.names[index]
                    )
                  ),
                  ]
              ),
            )
          );
        }
    );
  }
}


class CityInputField extends StatelessWidget {
  const CityInputField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter City",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: const Icon(Icons.search)
        ),
      )
    );
  }
  
  void submitCityName(BuildContext context, String cityName) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);
    weatherBloc.add(GetWeather(cityName));
  }
}