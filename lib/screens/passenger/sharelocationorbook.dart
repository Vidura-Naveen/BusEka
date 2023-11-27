import 'package:bus_eka/screens/passenger/sharelocation.dart';
import 'package:bus_eka/screens/track_anonymous/maportimetable.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/widgets/bluebutton.dart';
import 'package:bus_eka/widgets/greenbutton.dart';
import 'package:bus_eka/widgets/yellowbutton.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart' as user_model;

class ShareLocatioOrBookTicket extends StatefulWidget {
  const ShareLocatioOrBookTicket({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShareLocatioOrBookTicketState createState() =>
      _ShareLocatioOrBookTicketState();
}

class _ShareLocatioOrBookTicketState extends State<ShareLocatioOrBookTicket> {
  final AuthMethodes _authMethodes = AuthMethodes();

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
        // title: const Text('Your App Title'),
        // actions: [
        //   Builder(
        //     builder: (context) => IconButton(
        //       icon: const Icon(Icons.menu),
        //       onPressed: () {
        //         _openDrawer(context);
        //       },
        //     ),
        //   ),
        // ],
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
                  'Hay, ${currentUser?.userName ?? "Loading"}',
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
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/man.png',
                    height: 80,
                  ),
                ),
                // Container with buttons
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
                      GreenButton(
                        text: 'Bus Info',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MapOrTimeTable(),
                            ),
                          );
                          // Add your logic for button 1 here
                        },
                      ),
                      const SizedBox(height: 30),
                      YellowButton(
                        text: 'Bus Booking',
                        onPressed: () {
                          // Add your logic for button 2 here
                        },
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'OR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: mainBlueColor,
                          fontSize: 20,
                          fontFamily: 'RobotoMono',
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlueBtn(
                        text: 'Share Your Location',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShareLocation(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          'assets/locationicon.png',
                          height: 80,
                        ),
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

  // Open Drawer method
  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
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
