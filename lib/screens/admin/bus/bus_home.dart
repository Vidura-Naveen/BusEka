import 'package:flutter/material.dart';
import 'package:bus_eka/screens/admin/bus/bus_add_edit.dart';
import 'package:bus_eka/screens/admin/bus/bus_firebase_service.dart';
import 'package:bus_eka/screens/admin/bus/bus_model.dart';

class BusCrud extends StatefulWidget {
  @override
  _BusCrudState createState() => _BusCrudState();
}

class _BusCrudState extends State<BusCrud> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus List'),
      ),
      body: StreamBuilder<List<Bus>>(
        stream: _firebaseService.getBuss(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Bus> buss = snapshot.data!;

          return ListView.builder(
            itemCount: buss.length,
            itemBuilder: (context, index) {
              Bus bus = buss[index];
              return ListTile(
                title: Text(bus.busname),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seat Count: ${bus.seatcount}'),
                    Text('Route: ${bus.route}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _navigateToEditBus(context, bus);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _firebaseService.deleteBus(bus.busid);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddBus(context);
        },
        tooltip: 'Add Bus',
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddBus(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBusPage()),
    );
  }

  void _navigateToEditBus(BuildContext context, Bus bus) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditBusPage(bus: bus)),
    );
  }
}
