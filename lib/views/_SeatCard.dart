import 'package:flutter/material.dart';
class _SeatCard extends StatelessWidget {
  final String seatName;

  const _SeatCard({required this.seatName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chair, size: 34, color: Colors.black87),
          const SizedBox(height: 6),
          Text(
            seatName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
