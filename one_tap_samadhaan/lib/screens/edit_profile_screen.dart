// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields with existing user data
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
      if (doc.exists) {
        _nameController.text = doc.data()?['name'] ?? '';
        _emailController.text = doc.data()?['email'] ?? '';
      }
    });
  }

  void _updateProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
    });
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Profile Picture editing can be added here
          const SizedBox(height: 32),
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Full Name")),
          const SizedBox(height: 16),
          TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email Address")),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: _updateProfile, child: const Text("Save Changes")),
        ],
      ),
    );
  }
}