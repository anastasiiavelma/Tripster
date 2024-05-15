import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  HeaderWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 35,
            right: 170,
            width: 400,
            height: 200,
            child: FadeInUp(
                duration: const Duration(seconds: 1),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/airplane8.png'))),
                )),
          ),
          Positioned(
            left: 170,
            top: 100,
            width: 400,
            height: 150,
            child: FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bagage.png'))),
                )),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1600),
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
