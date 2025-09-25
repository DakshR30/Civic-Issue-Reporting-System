// lib/screens/report_step_2_details.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garudx_app/screens/report_step_3_confirmation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // <-- Import Storage

class ReportDetailsScreen extends StatefulWidget {
  final XFile imageFile;
  final Position currentPosition;
  const ReportDetailsScreen({super.key, required this.imageFile, required this.currentPosition});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String? _currentAddress;
  String? _selectedCategory;
  bool _isSubmitting = false;
  final List<String> _categories = [
    'Waste Management', 
    'Road Repair', 
    'Streetlight Issue',
    'Water Supply Issue',
    'Traffic Signal Issue',
    ];

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.currentPosition.latitude,
        widget.currentPosition.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.street}, ${place.locality}, ${place.postalCode}";
      });
    } catch (e) {
      setState(() { _currentAddress = "Could not fetch address."; });
    }
  }

  // --- NEW: Function to upload the image ---
  Future<String> _uploadImage(File image) async {
    String fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child('reports/$fileName');
    UploadTask uploadTask = storageRef.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // --- UPDATED: Submit report function ---
  void _submitReport() async {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a category.")));
      return;
    }
    setState(() { _isSubmitting = true; });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      // 1. Upload the image
      File imageFile = File(widget.imageFile.path);
      String imageUrl = await _uploadImage(imageFile);

      // 2. Determine suggested department
      String suggestedDept = 'N/A';
       switch (_selectedCategory) {
          case 'Waste Management': suggestedDept = 'Sanitation Dept.'; break;
          case 'Road Repair': suggestedDept = 'Public Works Dept.'; break;
          case 'Streetlight Issue': suggestedDept = 'Electrical Dept.'; break;
          case 'Water Supply Issue': suggestedDept = 'Water Supply Dept.'; break;
          case 'Traffic Signal Issue': suggestedDept = 'Traffic Dept.'; break;
        }

      // 3. Add the report data (including the image URL) to Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'category': _selectedCategory,
        'description': _descriptionController.text,
        'location': GeoPoint(widget.currentPosition.latitude, widget.currentPosition.longitude),
        'address': _currentAddress,
        'status': 'New',
        'reportedAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
        'imageUrl': imageUrl, // <-- Save the image URL
        'upvotes': 0,
        'suggestedDept': suggestedDept,
        'priority': 85, // Dummy priority
      });

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmationScreen()));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Submission failed: ${e.toString()}")));
      }
    } finally {
      if (mounted) {
        setState(() { _isSubmitting = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Details'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(widget.imageFile.path), height: 250, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.indigo.withAlpha(15), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.indigo),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_currentAddress ?? "Fetching location...", style: const TextStyle(fontSize: 14))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              hint: const Text('Select a Category'),
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), prefixIcon: const Icon(Icons.category_outlined)),
              onChanged: (String? newValue) { setState(() { _selectedCategory = newValue; }); },
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Short Description (Optional)',
                hintText: 'e.g., Large pothole near the bus stop',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.description_outlined),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitReport,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              child: _isSubmitting ? const CircularProgressIndicator(color: Colors.white) : const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}