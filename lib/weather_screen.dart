



import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_info.dart';
import 'package:weather_app/horlyforecast.dart';
import 'package:http/http.dart' as http;



class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  Future <Map< String,dynamic>> getweather() async {
    try{
      final res = await http.get(Uri.parse
        ('https://api.openweathermap.org/data/2.5/forecast?q=Delhi,india&APPID=a78710ad13e353bc3d04933485b23646'),
      );
     final data = jsonDecode(res.body);
      if(data['cod']!='200'){
        throw("an unexpects error is  occuered" );
      }
      return data;
    }

    catch(e){

      throw(e).toString();

    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: const Text("Weather App",
        style: TextStyle(fontWeight: FontWeight.bold),
        ) ,
      actions:   [

        IconButton(onPressed:

            (){
          setState(() {

          });
            }, icon: Icon(Icons.refresh)
         ,

        )
      ],
      )
     ,body:  FutureBuilder(
       future: getweather(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return
              const Center
                (child:  CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
           return Text(snapshot.error.toString());
          }

        final data=snapshot.data!;
       final  current =  data['list'][0]['main']['temp'];
      final currenticon = data['list'][0]['weather'][0]['main'];
      final pressure = data['list'][0]['main']['pressure'];
      final windspeed = data['list'][0]['wind']['speed'];
      final humidity = data['list'][0]['main']['humidity'];
         return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                width: double.infinity,
                child: Card(
                    elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                  )
                ,
                child:  Column(
                    children: [

                      ClipRRect(
                        borderRadius:  BorderRadius.circular(16),
                        child: BackdropFilter( filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                          child: Padding(
                                        padding: const EdgeInsets.all(16.0),

                            child:
                            Text("$current k",style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(  height: 20,),

                      Icon(
                        currenticon =='cloud'||currenticon =='Rain'
                        ?Icons.cloud
                        :Icons.sunny,size: 55,color: Colors.white,),
                      const SizedBox(height: 20,),
                       Text("$currenticon",style: TextStyle(fontSize: 32
                        ,fontWeight: FontWeight.bold,
                      ))

                     ] ,

                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            const Align(alignment: Alignment.centerLeft,
                child: Text("Weather Forecast",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26)
                  ,),
            ),
            //main card,
            const SizedBox(height: 20,),
           

           SizedBox(
             height: 120,
             child: ListView.builder(
                        itemCount:5,
               scrollDirection:Axis.horizontal,
               itemBuilder:(context,Index){
                 final time = DateTime.parse(data['list'][Index+1]['dt_txt']);
                          return HourlyForecast(

                              label: DateFormat.j().format(time),
                            icon: data['list'][Index+1]['weather'][0]['main']=='cloud'||
                                data['list'][Index+1]['weather'][0]['main']=='Rain'
                                ?Icons.cloud
                                :Icons.sunny ,
                              temp: data['list'][Index+1]['main']['temp'].toString()
                          );
               }
              ),
           ),


            const  SizedBox(
              height: 50,
            ),
            const Align(alignment: Alignment.centerLeft,
                child: Text("Additional Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
           const SizedBox(
              height: 30,
            ),
             Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                  Additional_info(icon: Icons.water_drop,label:"humidiy",value: humidity.toString()),
                   Additional_info(icon: Icons.air,label:"windspeed",value: windspeed.toString() ),
                  Additional_info(icon: Icons.beach_access,label:"pressure",value: pressure.toString() ),

              ],
            ),],
           );
        },
  ),

    )
   ;
  }
}