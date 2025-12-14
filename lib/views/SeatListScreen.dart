import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../models/seat_model.dart';
import 'add_student_screen.dart';

class SeatListScreen extends StatefulWidget {
  final UserModel user;

  const SeatListScreen({super.key, required this.user});

  @override
  State<SeatListScreen> createState() => _SeatListScreenState();
}

class _SeatListScreenState extends State<SeatListScreen> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  // Generate seat list
  List<Seat> _getSeats() {
    final totalSeats = user.totalSeats ?? 0;
    return List.generate(
      totalSeats,
          (i) => Seat(id: i + 1, number: 'SEAT ${i + 1}'),
    );
  }

  // Refresh UI after adding student
  void _refreshSeatData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final seats = _getSeats();

    return Scaffold(
      appBar: AppBar(
        title: Text(user.readingRoomName),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _RoomHeaderCard(user: user),
          const SizedBox(height: 24),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: seats.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemBuilder: (_, i) {
              return _SeatTile(
                seat: seats[i],
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddStudentScreen(
                        libraryId: user.id,
                        seatNo: seats[i].number,
                      ),
                    ),
                  );

                  // ✅ refresh after student added
                  if (result == true) {
                    _refreshSeatData();
                  }
                },
              );
            },
          ),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.readingRoomName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text("Total Seats: ${user.totalSeats ?? 0}"),
            Text("Reserved: ${user.reservedSeatsCount ?? 0}"),
            Text("Unreserved: ${user.unreservedSeatsCount ?? 0}"),
            Text("Location: ${user.location ?? ''}"),
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
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SeatTile extends StatelessWidget {
  final Seat seat;
  final VoidCallback onTap;

  const _SeatTile({required this.seat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFB9F6CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.event_seat, size: 36),
            const SizedBox(height: 8),
            Text(
              seat.number,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

