import 'package:flutter/material.dart';
import 'package:perfume/ExpensesPage.dart';
import 'package:perfume/GeneralReportPage.dart';
import 'package:perfume/PurchasePage.dart';
import 'package:perfume/SalaryPage.dart';
import 'package:perfume/SalesPage.dart' hide GeneralTransactionService;
import 'package:perfume/SuppliersPage.dart';
import 'package:perfume/SystemGuidePage%20.dart';

import 'dashboard.dart';
import 'product_registration.dart';
import 'employee.dart';
import 'users_page.dart';
import 'login_page.dart';
import 'sales_history_page.dart';
import 'customers_page.dart';
import 'settings_page.dart';

void main() => runApp(const PerfumeSystem());

class PerfumeSystem extends StatelessWidget {
  const PerfumeSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
      ),
      home: const LoginPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String role; 
  const HomePage({super.key, this.role = "User"});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 1; 
  final ScrollController _sideBarController = ScrollController();
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() {
    _pages = [
      const GeneralReportPage(),        // 0
      DashboardPage(onCardTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      }),                               // 1
      const CustomersPage(),            // 2
      const ProductRegistrationPage(),  // 3
      const EmployeePage(),             // 4
      const SalesPage(),                // 5
      const SalesHistoryPage(),         // 6
      const ExpensesPage(),             // 7
      const PurchasePage(),             // 8
      const SuppliersPage(),            // 9
      const UsersPage(),                // 10
      const SettingsPage(),             // 11
      EmployeeSalaryPage(),             // 12
      const SystemGuidePage(),          // 13
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.role.toLowerCase() == 'admin';

    return Scaffold(
      body: Row(
        children: [
          // --- SIDEBAR ---
          Container(
            width: 260,
            color: const Color(0xFF1E1E2D),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "PERFUME STORE",
                      style: TextStyle(
                        color: Colors.pinkAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: RawScrollbar(
                    controller: _sideBarController,
                    thumbColor: Colors.white.withOpacity(0.3),
                    thickness: 5,
                    radius: const Radius.circular(10),
                    thumbVisibility: true,
                    child: ListView(
                      controller: _sideBarController,
                      padding: EdgeInsets.zero,
                      children: [
                        _sideBarItem(Icons.grid_view_rounded, "Dashboard", 1),
                        _sideBarItem(Icons.people_alt_outlined, "Customers", 2),
                        _sideBarItem(Icons.shopping_bag_outlined, "Products", 3),
                        _sideBarItem(Icons.people_outline, "Employees", 4),

                        if (isAdmin) ...[
                          _sideBarItem(Icons.monetization_on_outlined, "Salary Management", 12),
                          _sideBarItem(Icons.history_rounded, "Sales History", 6),
                          _sideBarItem(Icons.shopping_cart_checkout, "Purchases", 8),
                          _sideBarItem(Icons.manage_accounts_outlined, "Users Management", 10),
                          _sideBarItem(Icons.analytics_outlined, "General Report", 0),
                          _sideBarItem(Icons.auto_stories_rounded, "System User Guide", 13),
                        ],

                        _sideBarItem(Icons.calendar_month_outlined, "Sales products", 5),
                        _sideBarItem(Icons.payments_outlined, "Expenses", 7),
                        _sideBarItem(Icons.local_shipping_outlined, "Suppliers", 9),
                        _sideBarItem(Icons.settings_outlined, "Settings", 11),
                      ],
                    ),
                  ),
                ),
                const Divider(color: Colors.white10),
                _sideBarItem(Icons.logout, "Log Out", -1),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // --- MAIN CONTENT (Halkan waxaa lagu daray hubinta safety-ga) ---
          Expanded(
            child: (selectedIndex >= 0 && selectedIndex < _pages.length)
                ? _pages[selectedIndex]
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _sideBarItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        if (index == -1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        } else {
          setState(() {
            selectedIndex = index;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
          border: isSelected ? const Border(left: BorderSide(color: Colors.pinkAccent, width: 4)) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.pinkAccent : Colors.grey[400], size: 22),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sideBarController.dispose();
    super.dispose();
  }
}