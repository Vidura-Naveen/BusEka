// import 'package:admin_auth/bus/bus_model.dart';
// import 'package:admin_auth/bus/bus_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/passenger/passenger_firebase_service.dart';
import 'package:bus_eka/screens/admin/passenger/passenger_model.dart';
import 'package:uuid/uuid.dart';

class AddEditPassengerPage extends StatefulWidget {
  final User? user;

  AddEditPassengerPage({Key? key, this.user}) : super(key: key);

  @override
  _AddEditPassengerPageState createState() => _AddEditPassengerPageState();
}

class _AddEditPassengerPageState extends State<AddEditPassengerPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userLoyalityController = TextEditingController();
  final TextEditingController _userPhoneNoController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _usercredentialController =
      TextEditingController();
  // final TextEditingController _uidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      _userEmailController.text = widget.user!.email;
      _userLoyalityController.text = widget.user!.loyaltycount.toString();
      _userPhoneNoController.text = widget.user!.phoneno;
      _userNameController.text = widget.user!.userName;
      _usercredentialController.text = widget.user!.usercredential;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _userEmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _userLoyalityController,
              decoration: InputDecoration(labelText: 'Loyality Count'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _userPhoneNoController,
              decoration: InputDecoration(labelText: 'Phone No'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usercredentialController,
              decoration: InputDecoration(labelText: 'Credintial'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveBus();
                Navigator.pop(context);
              },
              child: Text(widget.user == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBus() {
    final String uid = widget.user?.uid ?? Uuid().v4();
    final String email = _userEmailController.text;
    final int loyaltycount = int.parse(_userLoyalityController.text);
    final String phoneno = _userPhoneNoController.text;
    final String userName = _userNameController.text;
    final String usercredential = _usercredentialController.text;

    User user = User(
        uid: uid,
        email: email,
        loyaltycount: loyaltycount,
        phoneno: phoneno,
        userName: userName,
        usercredential: usercredential);

    if (widget.user == null) {
      _firebaseService.addUser(user);
    } else {
      _firebaseService.updateUser(user);
    }
  }
}
