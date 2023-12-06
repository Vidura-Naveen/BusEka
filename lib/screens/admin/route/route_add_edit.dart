import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/route/route_firebase_service.dart';
import 'package:bus_eka/screens/admin/route/route_model.dart';
import 'package:uuid/uuid.dart';

class AddEditRoutePage extends StatefulWidget {
  final Routez? route;

  AddEditRoutePage({Key? key, this.route}) : super(key: key);

  @override
  _AddEditRoutePageState createState() => _AddEditRoutePageState();
}

class _AddEditRoutePageState extends State<AddEditRoutePage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _routeNumberController = TextEditingController();
  final TextEditingController _fromLatitudeController = TextEditingController();
  final TextEditingController _fromLongitudeController =
      TextEditingController();
  final TextEditingController _toLatitudeController = TextEditingController();
  final TextEditingController _toLongitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.route != null) {
      _routeNumberController.text = widget.route!.routename;
      _fromLatitudeController.text = widget.route!.fromlatitude.toString();
      _fromLongitudeController.text = widget.route!.fromlongitude.toString();
      _toLatitudeController.text = widget.route!.tolatitude.toString();
      _toLongitudeController.text = widget.route!.tolongitude.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.route == null ? 'Add route' : 'Edit route'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _routeNumberController,
              decoration: InputDecoration(labelText: 'route Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _fromLatitudeController,
              decoration: InputDecoration(labelText: 'From Lat'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _fromLongitudeController,
              decoration: InputDecoration(labelText: 'From Long'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _toLatitudeController,
              decoration: InputDecoration(labelText: 'To Lat'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _toLongitudeController,
              decoration: InputDecoration(labelText: 'To Long'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveRoute();
                Navigator.pop(context);
              },
              child: Text(widget.route == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveRoute() {
    final String routeId = widget.route?.routeid ?? Uuid().v4();
    final String routename = _routeNumberController.text;
    final double fromlatitude = double.parse(_fromLatitudeController.text);
    final double fromlongitude = double.parse(_fromLongitudeController.text);
    final double tolatitude = double.parse(_toLatitudeController.text);
    final double tolongitude = double.parse(_toLongitudeController.text);

    Routez route = Routez(
        routeid: routeId,
        routename: routename,
        fromlatitude: fromlatitude,
        fromlongitude: fromlongitude,
        tolatitude: tolatitude,
        tolongitude: tolongitude);

    if (widget.route == null) {
      _firebaseService.addRoute(route);
    } else {
      _firebaseService.updateRoute(route);
    }
  }
}
