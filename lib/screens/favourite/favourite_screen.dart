import 'package:flutter/material.dart';
class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("Favourites",style: TextStyle(color: Colors.black,fontSize: 28),),),
    );
  }
}
