import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Text("Agrima", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Reg No: 24BIT0253", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Medical Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _infoTile("Blood Group", "B+", Icons.bloodtype, Colors.red),
            _infoTile("Date of Birth", "15 May 2004", Icons.cake, Colors.orange),
            _infoTile("Height / Weight", "165cm / 60kg", Icons.monitor_weight, Colors.green),
            _infoTile("Emergency Contact", "+91 9876543210", Icons.emergency, Colors.blue),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // Edit profile logic
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black)),
    );
  }
}