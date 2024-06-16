import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EventCard({
    Key? key,
    required this.title,
    required this.date,
    required this.description,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate = DateTime.tryParse(date) ?? DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy, h:mm a').format(parsedDate);

    return Card(
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.5),
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(imageUrl,
                height: 200, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(description, style: GoogleFonts.poppins(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
            child: Text('Date: $formattedDate',
                style:
                    GoogleFonts.poppins(color: Colors.grey[600], fontSize: 14)),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            buttonPadding: EdgeInsets.zero,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text('EDIT',
                    style: GoogleFonts.poppins(color: Colors.white)),
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
              ),
              SizedBox(width: 8), // Spacing between buttons
              ElevatedButton.icon(
                icon: Icon(Icons.delete, color: Colors.white),
                label: Text('DELETE',
                    style: GoogleFonts.poppins(color: Colors.white)),
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
