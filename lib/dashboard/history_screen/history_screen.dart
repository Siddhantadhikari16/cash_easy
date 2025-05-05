import 'package:cash_easy/image_constants.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History",style: TextStyle(fontFamily: 'Parkinsans'),),backgroundColor: Colors.teal,),
     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Center(child: Image.asset(ImageConstants.working,height: 250,)),
         Text("Work In Progress...",style: TextStyle(fontSize: 30),),


       ],
     ),


    );
  }
}
