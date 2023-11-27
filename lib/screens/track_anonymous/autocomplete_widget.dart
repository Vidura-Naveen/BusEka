// import 'package:flutter/material.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';

// class AutocompleteWidget extends StatefulWidget {
//   final Function(String) onLocationSelected;
//   final String hintText;

//   AutocompleteWidget(
//       {required this.onLocationSelected, required this.hintText});

//   @override
//   _AutocompleteWidgetState createState() => _AutocompleteWidgetState();
// }

// class _AutocompleteWidgetState extends State<AutocompleteWidget> {
//   TextEditingController _textController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return GooglePlaceAutoCompleteTextField(
//       textEditingController: _textController,
//       googleAPIKey: "AIzaSyBBDeYlysnT_H3CIITMGlwlCV2ecoASOWk",
//       debounceTime: 800,
//       countries: ["LK"],
//       itemClick: (Prediction prediction) {
//         setState(() {
//           _textController.text = prediction.description!;
//         });

//         // Trigger the callback to notify the parent widget of the selected location
//         widget.onLocationSelected(prediction.description!);
//       },
//       itemBuilder: (context, index, Prediction prediction) {
//         return Container(
//           padding: EdgeInsets.all(10),
//           child: Row(
//             children: [
//               Icon(Icons.location_on),
//               SizedBox(width: 7),
//               Expanded(child: Text("${prediction.description ?? ""}")),
//             ],
//           ),
//         );
//       },
//       getPlaceDetailWithLatLng: (Prediction prediction) {
//         print("Latitude: ${prediction.lat}");
//         print("Longitude: ${prediction.lng}");
//         // Use the latitude and longitude as needed
//       },
//     );
//   }
// }
