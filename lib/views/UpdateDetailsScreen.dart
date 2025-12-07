import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_view.dart';

class UpdateDetailsScreen extends StatefulWidget {
  final String phone;
  final String selectedType;

  const UpdateDetailsScreen({
    super.key,
    required this.phone,
    required this.selectedType,
  });

  @override
  State<UpdateDetailsScreen> createState() => _UpdateDetailsScreenState();
}

class _UpdateDetailsScreenState extends State<UpdateDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final readingRoomNameController = TextEditingController();
  final totalSeatsController = TextEditingController();
  final reservedSeatsController = TextEditingController();
  final unreservedSeatsController = TextEditingController();
  final reservedSeatFeeController = TextEditingController();
  final unreservedSeatFeeController = TextEditingController();
  final locationController = TextEditingController();

  List<String> types = ["READING_ROOM", "HOSTEL", "MESS", "LIBRARY"];
  List<String> selectedTypes = [];

  @override
  void initState() {
    super.initState();
    selectedTypes.add(widget.selectedType);
  }

  Future<void> updateDetails() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse(
        "http://10.226.84.50:8080/user/update-details/${widget.phone}");

    final body = {
      "readingRoomName": readingRoomNameController.text.trim(),
      "totalSeats": int.parse(totalSeatsController.text.trim()),
      "reservedSeatsCount": int.parse(reservedSeatsController.text.trim()),
      "unreservedSeatsCount": int.parse(unreservedSeatsController.text.trim()),
      "reservedSeatFee": double.parse(reservedSeatFeeController.text.trim()),
      "unreservedSeatFee": double.parse(unreservedSeatFeeController.text.trim()),
      "location": locationController.text.trim(),
      "types": selectedTypes
    };

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Details Updated Successfully")),
      //
      //
      // );

      // Navigator.pushReplacement(// some time
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomeView()),
      // );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.body)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Update Details",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ---------- ACCOUNT TYPE CHECKBOXES ----------
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Select Account Types",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...types.map((t) {
                        return CheckboxListTile(
                          activeColor: Colors.deepPurple,
                          title: Text(
                            t.replaceAll("_", " "),
                            style: const TextStyle(fontSize: 15),
                          ),
                          value: selectedTypes.contains(t),
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                selectedTypes.add(t);
                              } else {
                                selectedTypes.remove(t);
                              }
                            });
                          },
                        );
                      }),

                      const SizedBox(height: 20),

                      buildInput(readingRoomNameController,
                          "Reading Room Name", Icons.business),
                      buildInput(totalSeatsController, "Total Seats",
                          Icons.event_seat, true),
                      buildInput(reservedSeatsController,
                          "Reserved Seats Count", Icons.chair, true),
                      buildInput(unreservedSeatsController,
                          "Unreserved Seats Count", Icons.chair_alt, true),
                      buildInput(reservedSeatFeeController,
                          "Reserved Seat Fee", Icons.currency_rupee, true),
                      buildInput(unreservedSeatFeeController,
                          "Unreserved Seat Fee", Icons.attach_money, true),
                      buildInput(locationController, "Location",
                          Icons.location_on_outlined),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: updateDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "SUBMIT DETAILS",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController controller, String label,
      IconData icon, [bool isNumber = false]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (v) =>
        v!.isEmpty ? "Please enter $label".toLowerCase() : null,
      ),
    );
  }
}
