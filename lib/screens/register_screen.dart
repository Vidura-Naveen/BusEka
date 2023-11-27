import 'package:bus_eka/screens/home.dart';
import 'package:bus_eka/screens/login_screen.dart';
import 'package:bus_eka/services/auth_logic.dart';
import 'package:bus_eka/utils/util_functions.dart';
import 'package:bus_eka/widgets/text_feild.dart';
import 'package:bus_eka/widgets/yellowbutton.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _mobilenumController = TextEditingController();

  bool isLoading = false;

  final AuthMethodes _authMethodes = AuthMethodes();

//register the user
  void registerUser() async {
    setState(() {
      isLoading = true;
    });

    // get the user data from the text fields
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String nic = _nicController.text.trim();
    String userName = _userNameController.text.trim();
    String mobilenum = _mobilenumController.text.trim();

    // register the user
    String result = await _authMethodes.registerWithEmailAndPassword(
      email: email,
      password: password,
      userName: userName,
      nic: nic,
      mobilenum: mobilenum,
    );

    if (result != 'success') {
      showSnackBar(context, result);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }

    // show the Snackbar if the user is created or not
    setState(() {
      isLoading = false;
    });
  }

  @override
  //this  dispose methode is for remove the controller data from the memory
  void dispose() {
    super.dispose();
    //dispose the controllers
    _emailController.dispose();
    _passwordController.dispose();
    _nicController.dispose();
    _userNameController.dispose();
    _mobilenumController.dispose();
  }

  @override
  // oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
              ),

              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/buseka.png',
                  height: 80,
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              TextFeildInput(
                hintText: 'Enter Email',
                controller: _emailController,
                isPassword: false,
                inputkeyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 20,
              ),
              //text feild for password
              TextFeildInput(
                hintText: 'Enter Password',
                controller: _passwordController,
                isPassword: true,
                inputkeyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),

              //text feild for username
              TextFeildInput(
                hintText: 'Enter Username',
                controller: _userNameController,
                isPassword: false,
                inputkeyboardType: TextInputType.name,
              ),
              //text feild for nic
              const SizedBox(
                height: 20,
              ),
              TextFeildInput(
                hintText: 'Enter NIC',
                controller: _nicController,
                isPassword: false,
                inputkeyboardType: TextInputType.text,
              ),

              const SizedBox(
                height: 20,
              ),
              TextFeildInput(
                hintText: 'Enter Mobile Number',
                controller: _mobilenumController,
                isPassword: false,
                inputkeyboardType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20,
              ),
              //button for login
              YellowButton(
                text: 'Register',
                onPressed: registerUser,
              ),
              const SizedBox(
                height: 20,
              ),

              SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Log in.',
                        style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
