import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Column splashCard(BuildContext context) {
  var wid = MediaQuery.of(context).size.width;
  var hei = MediaQuery.of(context).size.height;
  var asp = MediaQuery.of(context).size.aspectRatio;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset('assets/images/Learn-it.png', height: asp * 200),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 105, 172, 227),

            child: Text(
              "Learn-IT",
              style: TextStyle(
                fontFamily: 'mont2',
                color: Colors.white,
                fontSize: asp * 75,
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: wid * 0.15,
            height: 1,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          ),
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: const Color.fromARGB(255, 105, 172, 227),
            child: Text(
              ' GRAMMER - MADE - SIMPLE ',
              style: TextStyle(
                color: Colors.white,
                fontSize: asp * 30,
                fontFamily: 'mont2',
              ),
            ),
          ),
          Container(
            width: wid * 0.15,
            height: 1,
            decoration: BoxDecoration(border: Border.all(color: Colors.white)),
          ),
        ],
      ),
      SizedBox(height: hei * 0.05),
    ],
  );
}


// Column logoCard(BuildContext context) {
//  return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Image.asset('assets/images/Learn-it.png', height: asp * 200),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Shimmer.fromColors(
//             baseColor: Colors.white,
//             highlightColor: const Color.fromARGB(255, 105, 172, 227),

//             child: Text(
//               "Learn-IT",
//               style: TextStyle(
//                 fontFamily: 'mont2',
//                 color: Colors.white,
//                 fontSize: asp * 75,
//               ),
//             ),
//           ),
//         ],
//       ),
// }