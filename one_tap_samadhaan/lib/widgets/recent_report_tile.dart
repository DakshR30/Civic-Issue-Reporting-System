import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garudx_app/screens/report_detail_screen.dart';

class RecentReportTile extends StatefulWidget {
  final String reportId;
  final Map<String, dynamic> reportData;

  const RecentReportTile({
    super.key,
    required this.reportId,
    required this.reportData,
  });

  @override
  State<RecentReportTile> createState() => _RecentReportTileState();
}

class _RecentReportTileState extends State<RecentReportTile> {
  late int _currentUpvotes;
  bool _isUpvoted = false; // To track if the user has upvoted in this session

  @override
  void initState() {
    super.initState();
    _currentUpvotes = widget.reportData['upvotes'] ?? 0;
  }

  void _handleUpvote() {
    // Only allow upvoting once per session
    if (!_isUpvoted) {
      setState(() {
        _currentUpvotes++;
        _isUpvoted = true;
      });

      // Update the count in Firestore
      FirebaseFirestore.instance
          .collection('reports')
          .doc(widget.reportId)
          .update({'upvotes': FieldValue.increment(1)});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract data with fallbacks for safety
    final String title = widget.reportData['category'] ?? 'No Title';
    final String status = widget.reportData['status'] ?? 'New';
    final String description = widget.reportData['description'] ?? 'No description provided.';
    
    Color statusColor;
    switch (status) {
      case 'In Progress': statusColor = const Color(0xFFF59E0B); break;
      case 'Resolved': statusColor = const Color(0xFF10B981); break;
      default: statusColor = const Color(0xFF5A6ACF);
    }
    
    // This is the new Card-based design
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailsScreen(
                reportId: widget.reportId,
                reportData: widget.reportData,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    onTap: _handleUpvote,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Icon(
                            _isUpvoted ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                            color: _isUpvoted ? Colors.indigo : Colors.grey[600],
                            size: 20
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _currentUpvotes.toString(),
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800], fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

