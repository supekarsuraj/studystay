class Seat {
  final int id;
  final String number;   // e.g. "SEAT1"
  final bool isBooked;   // you can toggle later

  const Seat({
    required this.id,
    required this.number,
    this.isBooked = false,
  });
}