import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/student_api_service.dart';

class AddStudentScreen extends StatefulWidget {
  final int libraryId;
  final String seatNo;

  const AddStudentScreen({
    super.key,
    required this.libraryId,
    required this.seatNo,
  });

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final educationCtrl = TextEditingController();
  final payMoneyCtrl = TextEditingController();
  final totalFeesCtrl = TextEditingController();

  DateTime? birthDate;
  DateTime? payDate;

  File? studentPhoto;
  File? documentPhoto;

  final api = StudentApiService();

  late AnimationController _animController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> pickDate(bool isBirth) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => isBirth ? birthDate = date : payDate = date);
    }
  }

  Future<void> pickImage(bool isStudent) async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() {
        isStudent ? studentPhoto = File(img.path) : documentPhoto = File(img.path);
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(email);
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.deepPurple,
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.event_seat, color: Colors.deepPurple),
                          const SizedBox(width: 10),
                          Text(
                            "Seat No: ${widget.seatNo}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: _input("Student Name", Icons.person),
                    validator: (v) => v!.isEmpty ? "Enter name" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: _input("Phone Number (+91)", Icons.phone)
                        .copyWith(prefixText: "+91 "),
                    validator: (v) =>
                    v!.length != 10 ? "Enter 10 digit number" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _input("Email", Icons.email),
                    validator: (v) =>
                    !isValidEmail(v!) ? "Invalid email" : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: educationCtrl,
                    decoration: _input("Education", Icons.school),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: payMoneyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _input("Pay Money", Icons.currency_rupee),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: totalFeesCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _input("Total Fees", Icons.account_balance_wallet),
                  ),
                  const SizedBox(height: 14),
                  _dateButton("Birth Date", birthDate, () => pickDate(true)),
                  _dateButton("Pay Date", payDate, () => pickDate(false)),
                  const SizedBox(height: 14),
                  _imagePicker("Student Photo", studentPhoto != null, () => pickImage(true)),
                  _imagePicker("Document Photo", documentPhoto != null, () => pickImage(false)),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.deepPurple, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;

                        // Show loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => const Center(child: CircularProgressIndicator()),
                        );

                        try {
                          await api.addStudent(
                            libraryId: widget.libraryId,
                            seatNo: widget.seatNo,
                            name: nameCtrl.text,
                            phone: phoneCtrl.text,
                            email: emailCtrl.text,
                            education: educationCtrl.text,
                            payMoney: payMoneyCtrl.text,
                            totalFees: totalFeesCtrl.text,
                            birthDate: birthDate,
                            payDate: payDate,
                            studentPhoto: studentPhoto,
                            documentPhoto: documentPhoto,
                          );

                          // Close loading dialog first
                          if (mounted) Navigator.pop(context);

                          // Then go back to SeatListScreen with success result
                          if (mounted) Navigator.pop(context, true);

                        } catch (e) {
                          // Close loading dialog
                          if (mounted) Navigator.pop(context);

                          // Show error message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: ${e.toString()}"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },

                      child: const Text("SAVE STUDENT",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateButton(String label, DateTime? date, VoidCallback onTap) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      leading: const Icon(Icons.calendar_today),
      title: Text(label),
      trailing: Text(date == null ? "Select" : date.toString().split(" ")[0]),
      onTap: onTap,
    );
  }

  Widget _imagePicker(String label, bool selected, VoidCallback onTap) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: Colors.white,
      leading: Icon(selected ? Icons.check_circle : Icons.image),
      title: Text(label),
      trailing: Text(selected ? "Selected" : "Optional"),
      onTap: onTap,
    );
  }
}
