import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/catatan_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get collection reference for user's catatan
  CollectionReference _getCatatanCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('catatan');
  }

  // Add new catatan
  Future<void> addCatatan(String userId, CatatanModel catatan) async {
    try {
      await _getCatatanCollection(userId).doc(catatan.id).set(catatan.toMap());
    } catch (e) {
      throw 'Gagal menambahkan catatan: ${e.toString()}';
    }
  }

  // Update existing catatan
  Future<void> updateCatatan(String userId, CatatanModel catatan) async {
    try {
      await _getCatatanCollection(userId).doc(catatan.id).update(catatan.toMap());
    } catch (e) {
      throw 'Gagal mengupdate catatan: ${e.toString()}';
    }
  }

  // Delete catatan
  Future<void> deleteCatatan(String userId, String catatanId) async {
    try {
      await _getCatatanCollection(userId).doc(catatanId).delete();
    } catch (e) {
      throw 'Gagal menghapus catatan: ${e.toString()}';
    }
  }

  // Get single catatan
  Future<CatatanModel?> getCatatan(String userId, String catatanId) async {
    try {
      DocumentSnapshot doc = await _getCatatanCollection(userId).doc(catatanId).get();
      if (doc.exists) {
        return CatatanModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Gagal mengambil catatan: ${e.toString()}';
    }
  }

  // Get all catatan as stream (real-time updates)
  Stream<List<CatatanModel>> getCatatanStream(String userId) {
    return _getCatatanCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CatatanModel.fromFirestore(doc))
          .toList();
    });
  }

  // Get all catatan as future (one-time fetch)
  Future<List<CatatanModel>> getAllCatatan(String userId) async {
    try {
      QuerySnapshot snapshot = await _getCatatanCollection(userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => CatatanModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw 'Gagal mengambil daftar catatan: ${e.toString()}';
    }
  }

  // Search catatan by title or content
  Future<List<CatatanModel>> searchCatatan(String userId, String query) async {
    try {
      QuerySnapshot snapshot = await _getCatatanCollection(userId).get();
      
      return snapshot.docs
          .map((doc) => CatatanModel.fromFirestore(doc))
          .where((catatan) =>
              catatan.judul.toLowerCase().contains(query.toLowerCase()) ||
              catatan.isi.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw 'Gagal mencari catatan: ${e.toString()}';
    }
  }

  // Delete all catatan for a user
  Future<void> deleteAllCatatan(String userId) async {
    try {
      QuerySnapshot snapshot = await _getCatatanCollection(userId).get();
      for (DocumentSnapshot doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw 'Gagal menghapus semua catatan: ${e.toString()}';
    }
  }

  // Get catatan count
  Future<int> getCatatanCount(String userId) async {
    try {
      QuerySnapshot snapshot = await _getCatatanCollection(userId).get();
      return snapshot.docs.length;
    } catch (e) {
      throw 'Gagal menghitung catatan: ${e.toString()}';
    }
  }
}