import 'package:flutter/material.dart';
import '../models/ReadingRoom.dart';

class SeatListScreen extends StatelessWidget {
  final ReadingRoom room;

  const SeatListScreen({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: room.totalSeats,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (_, index) {
          return _SeatCard(
            seatName: "SEAT ${index + 1}",
          );
        },
      ),
    );
  }
}

class _SeatCard extends StatelessWidget {
  final String seatName;

  const _SeatCard({required this.seatName});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.deepPurple.shade100,
      child: Center(
        child: Text(
          seatName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
