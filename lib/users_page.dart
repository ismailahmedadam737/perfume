import 'package:flutter/material.dart';
import 'package:perfume/services/user_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await UserService.fetchUsers();
    
    if (mounted) {
      setState(() {
        // Halkan ayaan ku xaqiijinaynaa in xogta ay tahay List
        users = (data is List) ? data : [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: const Color(0xFF1E1E2D),
        foregroundColor: Colors.white,
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : users.isEmpty 
          ? const Center(child: Text("No users found."))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final String role = (user['role'] ?? 'User').toString();
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.purpleAccent,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(user['name'] ?? "Unknown"),
                    subtitle: Text(user['email'] ?? "No email provided"),
                    trailing: Chip(
                      label: Text(role.toUpperCase()),
                      backgroundColor: role.toLowerCase() == 'admin' 
                          ? Colors.red[100] 
                          : Colors.blue[100],
                    ),
                  ),
                );
              },
            ),
    );
  }
}