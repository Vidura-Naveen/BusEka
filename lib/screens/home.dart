import 'package:bus_eka/screens/track_anonymous/maportimetable.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/colors.dart';
import 'package:bus_eka/widgets/bluebutton.dart';
import 'package:bus_eka/wrapper.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart' as user_model;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // For the top space
                  Container(
                    height: MediaQuery.of(context).size.height * 0.10,
                  ),

                  // Image for logo
                  Image.asset(
                    'assets/buseka.png',
                    height: 30,
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // Text field for email
                  BlueBtn(
                    text: 'Bus Information',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapOrTimeTable(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  const Text(
                    "For Booking And Share Location",
                    style: TextStyle(
                      color: mainGreenColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'outfit',
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  BlueBtn(
                    text: 'Account',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthWrapper(),
                        ),
                      );
                    },
                  ),

                  // Remove padding around images using Container
                  Container(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/doubledeckerbus.png',
                          height: 300,
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/BusTrackingBooking.png',
                          height: 15,
                        ),
                        const SizedBox(height: 10),
                        Image.asset(
                          'assets/EasytoTravel.png',
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
