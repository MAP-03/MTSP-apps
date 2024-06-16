import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:mtsp/view/kalendar/acara.dart';
import 'package:mtsp/widgets/toast.dart';

class AcaraService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; 

  Future<void> addEvent(Event event) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        event = Event(
          id: event.id,
          note: event.note,
          startDate: event.startDate,
          endDate: event.endDate,
          color: event.color,
          userId: user.email!,
        );
        await _firestore.collection('Events').doc(event.id).set(event.toJson());
        showToast(message: 'Acara berjaya disimpan');
      } else {
        showToast(message: 'User not logged in');
      }
    } catch (e) {
      showToast(message: 'Error saving event: $e');
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('Events')
            .where('userId', isEqualTo: user.email)
            .get();
        return snapshot.docs
            .map((doc) => Event.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      } else {
        showToast(message: 'User not logged in');
        return [];
      }
    } catch (e) {
      showToast(message: 'Error fetching events: $e');
      return [];
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('Events').doc(eventId).get();
        if (doc.exists && doc.data()?['userId'] == user.email) {
          await _firestore.collection('Events').doc(eventId).delete();
          showToast(message: 'Event successfully deleted');
        } else {
          showToast(message: 'No permission to delete this event');
        }
      } else {
        showToast(message: 'User not logged in');
      }
    } catch (e) {
      showToast(message: 'Error deleting event: $e');
    }
  }

  Future<Event?> getEvent(String eventId) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('Events').doc(eventId).get();
        if (doc.exists && doc.data()?['userId'] == user.email) {
          return Event.fromJson(doc.data() as Map<String, dynamic>);
        }
        return null;
      } else {
        showToast(message: 'User not logged in');
        return null;
      }
    } catch (e) {
      showToast(message: 'Error fetching event: $e');
      return null;
    }
  }
}
