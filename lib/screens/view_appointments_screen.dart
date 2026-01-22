import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ViewAppointmentsScreen extends StatelessWidget {
  const ViewAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Appointments")),
      body: FutureBuilder(
        future: ApiService.getAppointments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data as List<dynamic>;

          if (data.isEmpty) {
            return const Center(child: Text("No appointments"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final appt = data[index];
              return Card(
                child: ListTile(
                  title: Text(appt["patientName"]),
                  subtitle: Text("${appt["date"]} at ${appt["time"]}"),
                  trailing: Text(appt["status"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
