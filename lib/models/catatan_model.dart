import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CatatanModel {
  final String id;
  final String judul;
  final String isi;
  final DateTime tanggal;
  final DateTime createdAt;

  CatatanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tanggal': Timestamp.fromDate(tanggal),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory CatatanModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CatatanModel(
      id: doc.id,
      judul: data['judul'] ?? '',
      isi: data['isi'] ?? '',
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Create from Map
  factory CatatanModel.fromMap(Map<String, dynamic> map, String id) {
    return CatatanModel(
      id: id,
      judul: map['judul'] ?? '',
      isi: map['isi'] ?? '',
      tanggal: (map['tanggal'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }


  CatatanModel copyWith({
    String? id,
    String? judul,
    String? isi,
    DateTime? tanggal,
    DateTime? createdAt,
  }) {
    return CatatanModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Format date for display
  String getFormattedDate() {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(tanggal);
  }

  // Format created date for display
  String getFormattedCreatedDate() {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(createdAt);
  }
}