import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/catatan_model.dart';
import '../services/firestore_service.dart';

class AddEditCatatanScreen extends StatefulWidget {
  final CatatanModel? catatan;

  const AddEditCatatanScreen({super.key, this.catatan});

  @override
  State<AddEditCatatanScreen> createState() => _AddEditCatatanScreenState();
}

class _AddEditCatatanScreenState extends State<AddEditCatatanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.catatan != null) {
      _judulController.text = widget.catatan!.judul;
      _isiController.text = widget.catatan!.isi;
      _selectedDate = widget.catatan!.tanggal;
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveCatatan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.catatan == null) {
        // Add new catatan
        final newCatatan = CatatanModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          judul: _judulController.text.trim(),
          isi: _isiController.text.trim(),
          tanggal: _selectedDate,
          createdAt: DateTime.now(),
        );
        await _firestoreService.addCatatan(user!.uid, newCatatan);
      } else {
        // Update existing catatan
        final updatedCatatan = widget.catatan!.copyWith(
          judul: _judulController.text.trim(),
          isi: _isiController.text.trim(),
          tanggal: _selectedDate,
        );
        await _firestoreService.updateCatatan(user!.uid, updatedCatatan);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.catatan == null
                ? 'Catatan berhasil ditambahkan'
                : 'Catatan berhasil diupdate'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Catatan' : 'Tambah Catatan',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul Field
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  hintText: 'Masukkan judul catatan',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Date Picker
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.teal),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Isi Field
              TextFormField(
                controller: _isiController,
                maxLines: 10,
                decoration: InputDecoration(
                  labelText: 'Isi Catatan',
                  hintText: 'Tulis catatan Anda di sini...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi catatan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Save Button
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveCatatan,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.save, color: Colors.white),
                  label: Text(
                    _isLoading ? 'Menyimpan...' : 'Simpan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}