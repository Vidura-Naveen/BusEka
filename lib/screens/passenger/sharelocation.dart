import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bus_eka/screens/drawer.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/widgets/text_feild.dart';
import '../../models/user.dart' as user_model;

class ShareLocation extends StatefulWidget {
  const ShareLocation({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShareLocationState createState() => _ShareLocationState();
}

class _ShareLocationState extends State<ShareLocation> {
  //share firebase location
  final databaseReference = FirebaseDatabase.instance.ref();
  bool isSharingLocation = false;

  final AuthMethodes _authMethodes = AuthMethodes();

  TextEditingController temporaryController = TextEditingController();

  user_model.User? currentUser;

  void startSharingLocation() async {
    // Check for location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Handle the case when the user denies permission
        _showPopup('Location permission denied.');
        return;
      }
    }

    setState(() {
      isSharingLocation = true;
    });

    // Start continuous location updates
    updateLocation();
    _showPopup('Sharing location started.');
  }

  void stopSharingLocation() {
    setState(() {
      isSharingLocation = false;
    });

    // Stop location updates or perform any necessary cleanup
    // For simplicity, we can set the location to null in the database
    databaseReference.child('location').set(null);
    _showPopup('Sharing location stopped.');
  }

  void updateLocation() async {
    // Add logic to continuously update and share the location
    while (isSharingLocation) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Update the Firebase Realtime Database with the current location.
        databaseReference.child('location').set(
            {'latitude': position.latitude, 'longitude': position.longitude});

        // Simulate continuous updates by adding a delay
        await Future.delayed(Duration(seconds: 2));
      } catch (e) {
        // Handle the exception
        print('Error getting location: $e');
      }
    }
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Sharing"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Load the current user details
  void _loadCurrentUser() async {
    try {
      user_model.User? user = await _authMethodes.getCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (e) {
      print("Error loading current user: $e");
      // Handle the error as needed
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
                    fontSize: 20, // Set the font size to 20
                    fontFamily:
                        'Montserrat', // Replace 'RobotoMono' with the actual font family name
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Share Your Location',
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
                    children: [
                      const SizedBox(height: 15),
                      const SizedBox(height: 20),
                      TextFeildInput(
                        hintText: 'Select Route',
                        controller: temporaryController,
                        isPassword: false,
                        inputkeyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      TextFeildInput(
                        hintText: 'Select Bus',
                        controller: temporaryController,
                        isPassword: false,
                        inputkeyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 50),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: startSharingLocation,
                        child: Text('Start Sharing Location'),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: stopSharingLocation,
                        child: Text('Stop Sharing Location'),
                      ),
                      const SizedBox(height: 5),
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

  // Sign out method
  void _signOut() async {
    try {
      await _authMethodes.signOut();

      // Update the currentUser state after signing out
      setState(() {
        currentUser = null;
      });

      Navigator.pop(context); // Close the current screen after sign-out
    } catch (err) {
      print(err.toString());
    }
  }
}
