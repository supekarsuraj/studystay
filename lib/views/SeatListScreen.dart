import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../models/seat_model.dart';

class SeatListScreen extends StatelessWidget {
  final UserModel user;

  const SeatListScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    int totalSeats = user.totalSeats ?? 0;

    // Generate dynamic seat list
    List<Seat> seats = List.generate(
      totalSeats,
          (i) => Seat(id: i + 1, number: 'SEAT ${i + 1}'),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text("${user.readingRoomName}"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // ROOM HEADER DETAILS
          _RoomHeaderCard(user: user),

          const SizedBox(height: 24),

          // GRID BASED ON TOTAL SEATS
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
            itemBuilder: (_, i) => _SeatTile(seat: seats[i]),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

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

            // TOP TITLE ROW
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.sensor_door, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    user.readingRoomName,
                    style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),

            const SizedBox(height: 12),

            // PRICE CHIPS
            Row(
              children: [
                _PriceChip(
                    label: 'Reserved ₹${user.reservedSeatFee ?? 0}',
                    color: Colors.deepPurple),
                const SizedBox(width: 8),
                _PriceChip(
                    label: 'Unreserved ₹${user.unreservedSeatFee ?? 0}',
                    color: Colors.grey),
              ],
            ),

            const SizedBox(height: 16),

            Text("Total Seats: ${user.totalSeats}", style: const TextStyle(fontSize: 16)),
            Text("Reserved: ${user.reservedSeatsCount}", style: const TextStyle(fontSize: 16)),
            Text("Unreserved: ${user.unreservedSeatsCount}", style: const TextStyle(fontSize: 16)),
            Text("Location: ${user.location}", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Room detailed view'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        style:
        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SeatTile extends StatelessWidget {
  final Seat seat;

  const _SeatTile({required this.seat});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFB9F6CA),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
