import 'package:flutter/material.dart';
import 'package:studystay/models/ReadingRoom.dart';
import '../models/seat_model.dart';
import '../models/UserModel.dart';
import 'add_student_screen.dart';

class SeatListScreen extends StatelessWidget {
  final ReadingRoom room;
  final UserModel user;

  const SeatListScreen({
    super.key,
    required this.room,
    required this.user,
  });

  // Generate seats dynamically based on user's totalSeats
  List<Seat> _generateSeats() {
    final int totalSeats = user.totalSeats ?? 0;
    return List.generate(
      totalSeats,
          (index) => Seat(
        id: index + 1,
        number: 'SEAT${index + 1}',
        isBooked: false, // You can set this based on real data later
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final seats = _generateSeats();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Seat List'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ------------------- ROOM HEADER CARD -------------------
          _RoomHeaderCard(user: user),
          const SizedBox(height: 24),

          // ------------------- SEAT GRID -------------------
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, i) => _SeatTile(seat: seats[i], libraryId: user.id,),
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
  final UserModel user;

  const _RoomHeaderCard({required this.user});

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
                  child: const Icon(Icons.menu_book, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.readingRoomName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
            const SizedBox(height: 12),

            // Price chips
            Row(
              children: [
                _PriceChip(
                  label: '₹${user.reservedSeatFee?.toStringAsFixed(0) ?? "0"}',
                  labelText: 'Reserved',
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _PriceChip(
                  label: '₹${user.unreservedSeatFee?.toStringAsFixed(0) ?? "0"}',
                  labelText: 'Unreserved',
                  color: Colors.orange,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Room Details
            _InfoRow(
              label: 'Location',
              value: user.location ?? 'N/A',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Total Capacity',
              value: '${user.totalSeats ?? 0} seats',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Reserved Seats',
              value: '${user.reservedSeatsCount ?? 0} seats',
            ),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Unreserved Seats',
              value: '${user.unreservedSeatsCount ?? 0} seats',
            ),
            const SizedBox(height: 16),

            // Detailed view button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Room detailed view – coming soon!'),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Room detailed view'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
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

// Info row widget
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Price chip with label
class _PriceChip extends StatelessWidget {
  final String label;
  final String labelText;
  final Color color;

  const _PriceChip({
    required this.label,
    required this.labelText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            labelText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// Individual seat tile (green card)
// ------------------------------------------------------------
class _SeatTile extends StatelessWidget {
  final Seat seat;
  final int libraryId;   // 👈 ADD THIS

  const _SeatTile({
    required this.seat,
    required this.libraryId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: seat.isBooked
          ? Colors.red.shade100
          : const Color(0xFFB9F6CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddStudentScreen(
                libraryId: libraryId,   // ✅ NOW VALID
                seatNo: seat.number,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_seat, size: 36),
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
