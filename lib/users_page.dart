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
        users = data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              // Si aan u hubino in 'role' uu jiro
              String role = (user['role'] ?? 'User').toString();
              
              return ListTile(
                title: Text(user['name'] ?? "Unknown"),
                subtitle: Text(user['email'] ?? ""),
                trailing: Chip(
                  label: Text(role),
                  backgroundColor: role.toLowerCase() == 'admin' ? Colors.red[100] : Colors.blue[100],
                ),
              );
            },
          ),
    );
  }
}