import 'package:flutter/material.dart';

class LoaderComponent extends StatelessWidget{
  final double size;

  const LoaderComponent({super.key, this.size = 50.0});

  @override
  Widget build(BuildContext context){
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        strokeWidth: 4.0,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
