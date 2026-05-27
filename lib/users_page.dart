import 'package:flutter/material.dart';
import 'package:perfume/services/user_service.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // 1. Liiska hadda wuxuu xogta ka keeni doonaa API-ga
  List<dynamic> users = [];
  bool isLoading = true;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String selectedRole = 'User';

  @override
  void initState() {
    super.initState();
    _fetchData(); // Soo ridi xogta marka bogga la furo
  }

  // Function-ka xogta ka soo akhrinaya API-ga
  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    final data = await UserService.fetchUsers();
    setState(() {
      users = data;
      isLoading = false;
    });
  }

  // 2. Function-ka lagu darayo xogta (Hadda wuxuu isticmaalayaa UserService)
  void _addUser() async {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      final userData = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "role": selectedRole,
      };

      bool success = await UserService.addUser(userData);

      if (success) {
        _fetchData(); // Dib u soo aqri xogta database-ka
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Isticmaalaha waa la diwaangeliyey!"),
            backgroundColor: Colors.purple,
          ),
        );
      }
    }
  }

  // 3. Function-ka Pop-up Card-ka soo saaraya
  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(
          child: Text("User Details", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(),
            _detailRow(Icons.person, "Name:", user['name'] ?? ""),
            _detailRow(Icons.email, "Email:", user['email'] ?? ""),
            _detailRow(Icons.lock, "Password:", user['password'] ?? "N/A"),
            _detailRow(Icons.security, "Role:", user['role'] ?? ""),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Xidho", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "User Management",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D)),
            ),
            const SizedBox(height: 20),
            
            // --- QAYBTA INPUT-KA (FORM) ---
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(_nameController, "Full Name", Icons.person_rounded),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildInput(_emailController, "Email Address", Icons.email_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInput(_passwordController, "Password", Icons.lock_rounded, isPass: true),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedRole,
                          decoration: InputDecoration(
                            labelText: "Access Role",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: ['Admin', 'User'].map((role) {
                            return DropdownMenuItem(value: role, child: Text(role));
                          }).toList(),
                          onChanged: (val) => setState(() => selectedRole = val!),
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                      // BADHANKA GRADIENT-KA AH
                      InkWell(
                        onTap: _addUser,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 55,
                          width: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Colors.pinkAccent, Colors.purple],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(color: Colors.pinkAccent.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "Add User",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              "Registered Users (Click name to see details)",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 15),

            // --- QAYBTA LIISKA (ATTRACTIVE USER CARDS) ---
            Expanded(
              child: isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.purple))
                : users.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _buildUserCard(user, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget-ka Card-ka ee User-ka
  Widget _buildUserCard(Map<String, dynamic> user, int index) {
    bool isAdmin = user['role'] == 'Admin';
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: isAdmin ? Colors.red[50] : Colors.blue[50],
            child: Text(
              (user['name'] ?? "U")[0].toUpperCase(),
              style: TextStyle(color: isAdmin ? Colors.red : Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(width: 20),
          
          // Magaca (Marka lariixo wuxuu soo saaraa Pop-up)
          Expanded(
            child: InkWell(
              onTap: () => _showUserDetails(user),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user['name'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF1E1E2D))),
                  Text(user['email'] ?? "", style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
          ),
          
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isAdmin ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              user['role'] ?? "User",
              style: TextStyle(color: isAdmin ? Colors.red : Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          
          const SizedBox(width: 20),
          
          // Delete Action
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            ),
            onPressed: () async {
              bool success = await UserService.deleteUser(user['id']);
              if (success) _fetchData();
            },
          ),
        ],
      ),
    );
  }

  // Helper Input Field
  Widget _buildInput(TextEditingController controller, String label, IconData icon, {bool isPass = false}) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.purple[300]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_alt_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("No users found. Start by adding one!", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}