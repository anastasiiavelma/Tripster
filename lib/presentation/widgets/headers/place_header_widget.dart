import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tripster/utils/constants.dart';

class HeaderDecorationWidget extends StatelessWidget {
  const HeaderDecorationWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background_reverb.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 50,
            right: 170,
            width: 400,
            height: 200,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1300),
              child: Container(
                width: 190,
                height: 150,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/traveller.png'),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 150,
            top: 100,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1600),
              child: Center(
                child: Text(
                  "Welcome!",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          Positioned(
            left: 150,
            top: 140,
            child: FadeInUp(
              duration: const Duration(milliseconds: 1600),
              child: Center(
                child: Text(
                  "Let`s discover!",
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    fontSize: mediumLargeTextSize,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
