import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;
  final String reportId;

  const ReportDetailsScreen({
    super.key,
    required this.reportData,
    required this.reportId,
  });

  @override
  Widget build(BuildContext context) {
    // Extract data with fallbacks for safety
    final String category = reportData['category'] ?? 'No Category';
    final String imageUrl = reportData['imageUrl'] ?? '';
    final String description = reportData['description'] ?? 'No description.';
    final String address = reportData['address'] ?? 'No address provided.';
    final int upvotes = reportData['upvotes'] ?? 0;
    final GeoPoint location = reportData['location'] ?? const GeoPoint(18.5204, 73.8567);
    final LatLng reportPosition = LatLng(location.latitude, location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Image Card
          if (imageUrl.isNotEmpty)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                imageUrl,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null ? child : const Center(heightFactor: 4, child: CircularProgressIndicator());
                },
              ),
            ),
          const SizedBox(height: 16),

          // Details Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                  const Divider(height: 32),
                  _buildDetailRow(Icons.location_on_outlined, "Address", address),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.thumb_up_alt_outlined, "Upvotes", upvotes.toString()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Map Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              height: 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: reportPosition,
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(reportId),
                    position: reportPosition,
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.indigo, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }
}
