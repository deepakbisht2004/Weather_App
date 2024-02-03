import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget{
  final String label;
  final IconData icon;
  final String temp ;

  const HourlyForecast({super.key,
    required this.label,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return  Card(
      elevation: 10,
      child: Container(
        width: 100,
        height: 100,

        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)
        ),
        child: Column(

          children: [

            Text(label ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              overflow:TextOverflow.ellipsis,
            ),
            const SizedBox(height: 08,),
            Icon(icon),
            const SizedBox(height: 08,),
            Text(temp,style: TextStyle(fontSize: 16),)
          ],
        ),
      ),
    );


  }
}