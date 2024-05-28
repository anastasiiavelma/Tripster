import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const largeTextSize = 35.0;
const mediumLargeTextSize = 27.0;
const mediumTextSize = 16.0;
const smallTextSize = 14.0;

Color kBackgroundColor = HexColor("#003335");
Color kPrimaryColor = Colors.white;
Color kAccentColor = HexColor("#e0c8d3");
Color kTexFieldColor = Colors.grey;
Color kErrorColorLight = HexColor("#cc0000");
Color kErrorColorDark = HexColor("#ff4d4d");

Color kBackgroundColorDark = HexColor("#045353");
Color kPrimaryColorDark = Colors.black87;
Color kAccentColorDark = HexColor("#b89aa6");
Color kTextFieldColorDark = Colors.black54;
Color kErrorColorLightDark = HexColor("#cc0000");
Color kErrorColorDarkDark = HexColor("#ff0000");

const smallSizedBoxWidth = SizedBox(width: 10.0);
const smallerSizedBoxWidth = SizedBox(width: 4.0);
const smallerSizedBoxHeight = SizedBox(height: 4.0);
const smallSizedBoxHeight = SizedBox(height: 10.0);
const mediumSizedBoxHeight = SizedBox(height: 20.0);
// spacer
const spacer = Spacer();

// Divider
const divider = Divider(
  thickness: 1,
  height: 3,
  color: Colors.white,
);

// padding
const smallerPadding = EdgeInsets.all(3.0);
const smallPadding = EdgeInsets.all(8.0);
const midPadding = EdgeInsets.all(13.0);
const largePadding = EdgeInsets.all(20.0);
const leftBottomPadding = EdgeInsets.fromLTRB(
  10.0,
  0.0,
  0.0,
  10.0,
);
CircularProgressIndicator getCircularProgressIndicator(
  BuildContext context,
) {
  return CircularProgressIndicator(
    strokeWidth: 2,
    valueColor:
        AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.background),
  );
}

CircularProgressIndicator getCircularProgressIndicator2(
  BuildContext context,
) {
  return CircularProgressIndicator(
    strokeWidth: 2,
    valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.onBackground),
  );
}
