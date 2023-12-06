import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_eka/screens/drawer.dart';
import 'package:bus_eka/screens/map_part/map_page.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';

import '../../models/user.dart' as user_model;

class MapOrTimeTable extends StatefulWidget {
  const MapOrTimeTable({Key? key}) : super(key: key);

  @override
  _MapOrTimeTableState createState() => _MapOrTimeTableState();
}

class _MapOrTimeTableState extends State<MapOrTimeTable> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  LatLng location1 = LatLng(0.0, 0.0);
  LatLng location2 = LatLng(0.0, 0.0);
  double fromLatitude = 0.0;
  double fromLongitude = 0.0;
  double toLatitude = 0.0;
  double toLongitude = 0.0;
  List<String> routeNames = [];
  final AuthMethodes _authMethodes = AuthMethodes();
  TextEditingController temporaryController = TextEditingController();
  user_model.User? currentUser;

  String? selectedRoute;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _requestLocationPermission();
    loadRouteNames();
  }

  void loadRouteNames() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('routcolection').get();

    setState(() {
      routeNames =
          querySnapshot.docs.map((doc) => doc['routename'] as String).toList();
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permission Required'),
            content: Text('Please enable location services to use this app.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _loadCurrentUser() async {
    try {
      user_model.User? user = await _authMethodes.getCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print("Error loading current user: $e");
    }
  }

  void loadRouteData() async {
    if (selectedRoute != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('routcolection')
          .where('routename', isEqualTo: selectedRoute)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var routeData = querySnapshot.docs.first.data();
        if (routeData != null && routeData is Map<String, dynamic>) {
          setState(() {
            fromLatitude = routeData['fromlatitude'] ?? 0.0;
            fromLongitude = routeData['fromlongitude'] ?? 0.0;
            toLatitude = routeData['tolatitude'] ?? 0.0;
            toLongitude = routeData['tolongitude'] ?? 0.0;

            location1 = LatLng(fromLatitude, fromLongitude);
            location2 = LatLng(toLatitude, toLongitude);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBlueColor,
      appBar: AppBar(
        backgroundColor: mainBlueColor,
        elevation: 0.0,
      ),
      drawer: AppDrawer(
        onSignOut: _signOut,
        userName: currentUser?.userName,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  'Hay, ${currentUser?.userName ?? "User"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Where You want to GO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextField(
                        controller: _fromController,
                        decoration: InputDecoration(labelText: 'From'),
                      ),
                      TextField(
                        controller: _toController,
                        decoration: InputDecoration(labelText: 'To'),
                      ),
                      DropdownButton<String>(
                        value: selectedRoute,
                        items: routeNames.map((String route) {
                          return DropdownMenuItem<String>(
                            value: route,
                            child: Text(route),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedRoute = value;
                          });
                          loadRouteData();
                        },
                        hint: Text('Select Route'),
                      ),
                      ElevatedButton(
                        child: Text('Show Map'),
                        onPressed: () async {
                          try {
                            if (_fromController.text.isEmpty ||
                                _toController.text.isEmpty) {
                              throw Exception(
                                  'Please enter both From and To locations');
                            }

                            List<Location> fromLocations =
                                await locationFromAddress(_fromController.text);
                            List<Location> toLocations =
                                await locationFromAddress(_toController.text);

                            LatLng fromLatLng = LatLng(
                                fromLocations[0].latitude,
                                fromLocations[0].longitude);
                            LatLng toLatLng = LatLng(toLocations[0].latitude,
                                toLocations[0].longitude);

                            Position currentPosition =
                                await Geolocator.getCurrentPosition();
                            LatLng currentLatLng = LatLng(
                                currentPosition.latitude,
                                currentPosition.longitude);

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapPage(
                                  fromLatLng: fromLatLng,
                                  toLatLng: toLatLng,
                                  location1: location1,
                                  location2: location2,
                                  currentLatLng: currentLatLng,
                                ),
                              ),
                            );
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(e.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signOut() async {
    try {
      await _authMethodes.signOut();
      setState(() {
        currentUser = null;
      });
      Navigator.pop(context);
    } catch (err) {
      print(err.toString());
    }
  }
}
