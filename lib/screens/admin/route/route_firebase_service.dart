import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bus_eka/screens/admin/route/route_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRoute(Routez route) async {
    await _firestore
        .collection('routcolection')
        .doc(route.routeid)
        .set(route.toJson());
  }

  Stream<List<Routez>> getRoutes() {
    return _firestore.collection('routcolection').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Routez.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> updateRoute(Routez route) async {
    await _firestore
        .collection('routcolection')
        .doc(route.routeid)
        .update(route.toJson());
  }

  Future<void> deleteRoute(String routeId) async {
    await _firestore.collection('routcolection').doc(routeId).delete();
  }
}
