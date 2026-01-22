import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final patientCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  void book() async {
    final message = await ApiService.bookAppointment(
      patientCtrl.text,
      dateCtrl.text,
      timeCtrl.text,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
                controller: patientCtrl,
                decoration:
                    const InputDecoration(labelText: "Patient Name")),
            TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(
                    labelText: "Date (YYYY-MM-DD)")),
            TextField(
                controller: timeCtrl,
                decoration:
                    const InputDecoration(labelText: "Time (10:30 AM)")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: book, child: const Text("Book")),
          ],
        ),
      ),
    );
  }
}
