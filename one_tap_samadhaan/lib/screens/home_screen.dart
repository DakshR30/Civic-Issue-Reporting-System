import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garudx_app/screens/nearby_map_screen.dart';
import 'package:garudx_app/screens/profile_screen.dart';
import 'package:garudx_app/screens/report_step_1_camera.dart';
import 'package:garudx_app/widgets/summary_card.dart';
import 'package:garudx_app/widgets/recent_report_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> reportsStream = FirebaseFirestore.instance
        .collection('reports')
        .orderBy('reportedAt', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Image.asset('assets/images/logo.png', height: 40),
          const SizedBox(width: 10),
          const Text("One Tap Samadhaan", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold)),
        ]),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: Colors.grey[100], // Overall background color
      body: StreamBuilder<QuerySnapshot>(
        stream: reportsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Something went wrong'));
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());

          final reports = snapshot.data!.docs;

          return ListView(
            children: [
              // --- Group 1: Main Actions in a white container ---
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt_outlined, size: 24),
                      label: const Text('Report New Issue'),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportCameraScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF4338CA),
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SummaryCard(title: 'Submitted', count: reports.where((r) => r['status'] == 'New').length.toString(), icon: Icons.inbox_outlined, color: const Color(0xFF5A6ACF)),
                        const SizedBox(width: 12),
                        SummaryCard(title: 'In Progress', count: reports.where((r) => r['status'] == 'In Progress').length.toString(), icon: Icons.sync_outlined, color: const Color(0xFFF59E0B)),
                        const SizedBox(width: 12),
                        SummaryCard(title: 'Resolved', count: reports.where((r) => r['status'] == 'Resolved').length.toString(), icon: Icons.check_circle_outlined, color: const Color(0xFF10B981)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.map_outlined),
                      label: const Text("View Nearby Problems"),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NearbyMapScreen()));
                      },
                       style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.indigo,
                          side: BorderSide(color: Colors.indigo.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              
              // --- Group 2: Recent Reports ---
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Recent Reports", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        var reportData = reports[index].data() as Map<String, dynamic>;
                        
                        return RecentReportTile(
                          reportId: reports[index].id,
                          reportData: reportData,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}