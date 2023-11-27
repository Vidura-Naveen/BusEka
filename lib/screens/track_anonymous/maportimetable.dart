import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/widgets/greenbutton.dart';
import 'package:bus_eka/widgets/text_feild.dart';
import 'package:bus_eka/widgets/yellowbutton.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart' as user_model;

class MapOrTimeTable extends StatefulWidget {
  const MapOrTimeTable({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapOrTimeTableState createState() => _MapOrTimeTableState();
}

class _MapOrTimeTableState extends State<MapOrTimeTable> {
  final AuthMethodes _authMethodes = AuthMethodes();

  TextEditingController temporaryController = TextEditingController();

  user_model.User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  // Load the current user details
  void _loadCurrentUser() async {
    try {
      user_model.User user = await _authMethodes.getCurrentUser();
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
      drawer: _buildDrawer(),
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
                  'Whare You want to GO',
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
                        hintText: 'To',
                        controller: temporaryController,
                        isPassword: false,
                        inputkeyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      TextFeildInput(
                        hintText: 'Select Route',
                        controller: temporaryController,
                        isPassword: false,
                        inputkeyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 50),
                      GreenButton(
                        text: 'Search From Time table',
                        onPressed: () {
                          // Add your logic for button 1 here
                        },
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mainBlueColor,
                          fontSize: 20,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      const SizedBox(height: 30),
                      YellowButton(
                        text: 'Search From MAP',
                        onPressed: () {
                          // Add your logic for button 2 here
                        },
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

  // Open Drawer method
  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  // Sign out method
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

  // Drawer widget
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: mainBlueColor,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              _signOut();
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Nama'),
            onTap: () {
              // Close the drawer
            },
          ),
          ListTile(
            title: Text('Gama'),
            onTap: () {
              // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
