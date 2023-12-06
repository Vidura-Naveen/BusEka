import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/bus/bus_firebase_service.dart';
import 'package:bus_eka/screens/admin/bus/bus_model.dart';
import 'package:uuid/uuid.dart';

class AddEditBusPage extends StatefulWidget {
  final Bus? bus;

  AddEditBusPage({Key? key, this.bus}) : super(key: key);

  @override
  _AddEditBusPageState createState() => _AddEditBusPageState();
}

class _AddEditBusPageState extends State<AddEditBusPage> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _seatcountController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bus != null) {
      _busNameController.text = widget.bus!.busname;
      _seatcountController.text = widget.bus!.seatcount.toString();
      _routeController.text = widget.bus!.route;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bus == null ? 'Add Bus' : 'Edit Bus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _busNameController,
              decoration: InputDecoration(labelText: 'Bus Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _seatcountController,
              decoration: InputDecoration(labelText: 'Seat Count'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _routeController,
              decoration: InputDecoration(labelText: 'Route'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveBus();
                Navigator.pop(context);
              },
              child: Text(widget.bus == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveBus() {
    final String busId = widget.bus?.busid ?? Uuid().v4();
    final String busname = _busNameController.text;
    final int seatcount = int.parse(_seatcountController.text);
    final String route = _routeController.text;

    Bus bus =
        Bus(busid: busId, busname: busname, seatcount: seatcount, route: route);

    if (widget.bus == null) {
      _firebaseService.addBus(bus);
    } else {
      _firebaseService.updateBus(bus);
    }
  }
}
