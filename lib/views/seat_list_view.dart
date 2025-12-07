import 'package:flutter/material.dart';
import 'package:studystay/models/ReadingRoom.dart';
import '../models/seat_model.dart';

class SeatListScreen extends StatelessWidget {
  const SeatListScreen({super.key, required ReadingRoom room});

  // -----------------------------------------------------------------
  // Dummy data – replace with real data / API later
  // -----------------------------------------------------------------
  static const List<Seat> _seats = [
    Seat(id: 1, number: 'SEAT1'),
    Seat(id: 2, number: 'SEAT2'),
    Seat(id: 3, number: 'SEAT3'),
    Seat(id: 4, number: 'SEAT4'),
    Seat(id: 5, number: 'SEAT5'),
    Seat(id: 6, number: 'SEAT6'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Seat List'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ------------------- ROOM HEADER CARD -------------------
          _RoomHeaderCard(),
          const SizedBox(height: 24),

          // ------------------- SEAT GRID -------------------
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _seats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) => _SeatTile(seat: _seats[i]),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Room header (price, type, capacity, facilities)
// ------------------------------------------------------------
class _RoomHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.sensor_door, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'RC 3 ROOM 1',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _PriceChip(label: '₹0', color: Colors.blue),
                const SizedBox(width: 8),
                _PriceChip(label: '₹0', color: Colors.grey.shade400),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Type', style: TextStyle(color: Colors.grey)),
            const Text('Capacity', style: TextStyle(color: Colors.grey)),
            const Text('Facilities', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Room detailed view – coming soon!')),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Room detailed view'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small price chip
class _PriceChip extends StatelessWidget {
  final String label;
  final Color color;
  const _PriceChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ------------------------------------------------------------
// Individual seat tile (green card)
// ------------------------------------------------------------
class _SeatTile extends StatelessWidget {
  final Seat seat;
  const _SeatTile({required this.seat});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFB9F6CA), // light‑green like the screenshot
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${seat.number} tapped')),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_seat, size: 36, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              seat.number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}