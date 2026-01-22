import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingScreen extends StatefulWidget {
  final String doctorName;
  final String specialty;

  const BookingScreen({
    super.key, 
    required this.doctorName, 
    required this.specialty
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
  String selectedTimeSlot = "10:00 AM";

  final List<String> timeSlots = [
    "09:00 AM", "10:00 AM", "11:00 AM", 
    "02:00 PM", "03:00 PM", "04:00 PM"
  ];

  Future<void> _confirmBooking() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('appointments').add({
        'patientId': user.uid,
        'doctorName': widget.doctorName,
        'specialty': widget.specialty,
        'date': "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
        'time': selectedTimeSlot,
        'status': 'Confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
            content: const Text(
              "Appointment Booked Successfully!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to List
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue[50],
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(widget.doctorName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(widget.specialty),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                    const Icon(Icons.calendar_today, color: Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text("Available Time Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: timeSlots.map((time) {
                return ChoiceChip(
                  label: Text(time),
                  selected: selectedTimeSlot == time,
                  onSelected: (bool selected) {
                    setState(() => selectedTimeSlot = time);
                  },
                  selectedColor: Colors.blue[800],
                  labelStyle: TextStyle(
                    color: selectedTimeSlot == time ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
                onPressed: _confirmBooking,
                child: const Text("Confirm Booking", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}