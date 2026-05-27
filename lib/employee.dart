import 'package:flutter/material.dart';
import 'services/employee_service.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EmployeePage(),
  ));
}

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();

  // Function: Inaad shaqaale cusub ku darto
  void _addNewEmployee() async {
    if (_nameController.text.isEmpty) return;
    try {
      Map<String, dynamic> data = {
        "name": _nameController.text,
        "position": _positionController.text,
        "phone": _phoneController.text,
        "district": _districtController.text,
      };
      await EmployeeService.createEmployee(data);
      _clearControllers();
      setState(() {});
      _showSnackBar("Shaqaalaha si guul leh ayaa loo kaydiyay", Colors.green);
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  // Function: Edit Employee (Cusub)
  void _editEmployee(Map<String, dynamic> emp) {
    _nameController.text = emp['name'];
    _positionController.text = emp['position'] ?? "";
    _phoneController.text = emp['phone'] ?? "";
    _districtController.text = emp['district'] ?? "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Wax ka bedel xogta"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(_nameController, "Magaca", Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(_positionController, "Booska", Icons.work_outline),
              const SizedBox(height: 10),
              _buildTextField(_phoneController, "Telefoonka", Icons.phone_android_outlined),
              const SizedBox(height: 10),
              _buildTextField(_districtController, "Degmada", Icons.location_on_outlined),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () { _clearControllers(); Navigator.pop(context); }, child: const Text("Ka noqo")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8E2DE2)),
            onPressed: () async {
              Map<String, dynamic> updatedData = {
                "name": _nameController.text,
                "position": _positionController.text,
                "phone": _phoneController.text,
                "district": _districtController.text,
              };
              await EmployeeService.updateEmployee(emp['id'], updatedData);
              _clearControllers();
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Function: Delete Alert (Cusub)
  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Digniin!"),
        content: Text("Ma hubtaa inaad tirtirto shaqaalaha: $name?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Maya")),
          TextButton(
            onPressed: () {
              _deleteEmployee(id);
              Navigator.pop(context);
            },
            child: const Text("Yes, Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(int id) async {
    try {
      await EmployeeService.deleteEmployee(id);
      setState(() {});
    } catch (e) {
      _showSnackBar("Error: $e", Colors.red);
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _positionController.clear();
    _phoneController.clear();
    _districtController.clear();
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        title: const Text("Employees Management", 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Row(
        children: [
          // QAYBTA BIDIX: FORM-KA
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Diwaangalinta Shaqaalaha", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF8E2DE2))),
                    const SizedBox(height: 30),
                    _buildTextField(_nameController, "Magaca oo dhammaystiran", Icons.person_outline),
                    const SizedBox(height: 15),
                    _buildTextField(_positionController, "Booska Shaqada", Icons.work_outline),
                    const SizedBox(height: 15),
                    _buildTextField(_phoneController, "Telefoonka", Icons.phone_android_outlined, keyboard: TextInputType.phone),
                    const SizedBox(height: 15),
                    _buildTextField(_districtController, "Degmada / District", Icons.location_on_outlined),
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: _addNewEmployee,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8E2DE2), Color(0xFFF00000)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(color: const Color(0xFF8E2DE2).withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
                          ],
                        ),
                        child: const Center(
                          child: Text("Add New Employee", 
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // QAYBTA MIDIG: LIISKA SHAQAALAHA
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Liiska Shaqaalaha Diwaangashan", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueGrey)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: EmployeeService.getAllEmployees(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Color(0xFF8E2DE2)));
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text("Ma jiro wax shaqaale ah."));
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) => _employeeCard(snapshot.data![index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF8E2DE2)),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8E2DE2), width: 1.5),
        ),
      ),
    );
  }

  Widget _employeeCard(Map<String, dynamic> emp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF8E2DE2).withOpacity(0.1),
            child: Text(emp['name'][0].toString().toUpperCase(), 
              style: const TextStyle(color: Color(0xFF8E2DE2), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: InkWell(
              onTap: () => _showPopUp(emp['name'], emp['position'], emp['phone'], emp['district']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(emp['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(emp['position'] ?? "N/A", style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_square, color: Colors.blueGrey, size: 20),
            onPressed: () => _editEmployee(emp),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: () => _confirmDelete(emp['id'], emp['name']),
          ),
        ],
      ),
    );
  }

  void _showPopUp(String name, String role, String phone, String district) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: Container(
            padding: const EdgeInsets.all(25),
            width: 340,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF8E2DE2),
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 15),
                Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Text(role, style: const TextStyle(color: Color(0xFF8E2DE2), fontSize: 16)),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 15),
                _infoDetail(Icons.phone, "Phone:", phone),
                const SizedBox(height: 10),
                _infoDetail(Icons.location_on, "District:", district),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8E2DE2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Xidh", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoDetail(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}