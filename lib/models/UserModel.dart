class UserModel {
  final int id;
  final String name;
  final String phone;
  final String password;
  final String type;
  final String readingRoomName;
  final int? totalSeats;
  final int? reservedSeatsCount;
  final int? unreservedSeatsCount;
  final int? reservedSeatFee;
  final int? unreservedSeatFee;
  final String? location;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
    required this.type,
    this.readingRoomName = "",
    this.totalSeats,
    this.reservedSeatsCount,
    this.unreservedSeatsCount,
    this.reservedSeatFee,
    this.unreservedSeatFee,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"],
      phone: json["phone"],
      password: json["password"],
      type: json["type"],
      readingRoomName: json["readingRoomName"] ?? "",
      totalSeats: json["totalSeats"],
      reservedSeatsCount: json["reservedSeatsCount"],
      unreservedSeatsCount: json["unreservedSeatsCount"],
      reservedSeatFee: (json["reservedSeatFee"] as num?)?.toInt(),
      unreservedSeatFee: (json["unreservedSeatFee"] as num?)?.toInt(),
      location: json["location"],
    );
  }
}
