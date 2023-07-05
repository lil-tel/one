import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

class PagePeople extends StatelessWidget {
  const PagePeople({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Center(
        child: Text(
          "Page Number 3",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary ,
            fontSize: 45,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
