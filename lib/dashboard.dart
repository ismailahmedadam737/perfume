import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:perfume/login_page.dart';
import 'package:perfume/services/dashboard_service.dart'; // Hubi in magacani sax yahay

class DashboardPage extends StatefulWidget {
  final Function(int)? onCardTap; 
  const DashboardPage({super.key, this.onCardTap});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController _floatingController;

  // --- XOGTA DATABASE-KA ---
  Map<String, dynamic> _stats = {
    "products": "0",
    "employees": "0",
    "customers": "0",
    "settings": "0"
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _loadDashboardStats(); // Soo qaad xogta marka boggu kaco
  }

  // --- FUNCTION-KA XOGTA SOO JIIDAYA ---
  Future<void> _loadDashboardStats() async {
    try {
      final data = await DashboardService.fetchDashboardStats();
      if (mounted) {
        setState(() {
          // Waxaan halkan ku daray 'Null Safety' si uusan TypeError u dhicin
          _stats = {
            "products": (data['products'] ?? 0).toString(),
            "employees": (data['employees'] ?? 0).toString(),
            "customers": (data['customers'] ?? 0).toString(),
            "settings": (data['settings'] ?? 0).toString(),
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Dashboard Error: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 30),

            // 1. Animated Cards (Halkan xogta dhabta ah ayaa lagu muujiyey)
            Row(
              children: [
                _buildModernFloatingCard(
                  "Products", 
                  _isLoading ? "..." : _stats['products'], 
                  const Color(0xFF9C27B0), () {
                    widget.onCardTap?.call(3); 
                }),
                const SizedBox(width: 20),
                _buildModernFloatingCard(
                  "Employees", 
                  _isLoading ? "..." : _stats['employees'], 
                  const Color(0xFFE91E63), () {
                    widget.onCardTap?.call(4); 
                }),
                const SizedBox(width: 20),
                _buildModernFloatingCard(
                  "Customers", 
                  _isLoading ? "..." : _stats['customers'], 
                  const Color(0xFF673AB7), () {
                    widget.onCardTap?.call(2); 
                }),
                const SizedBox(width: 20),
                _buildModernFloatingCard(
                  "Settings", 
                  "Info", // Waxaad u beddeli kartaa _stats['settings'] haddii loo baahdo
                  const Color(0xFFF06292), () {
                    widget.onCardTap?.call(11); 
                }),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Charts Section
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildChartContainer("Performance Analytics", const ModernPerformanceChart()),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 1,
                    child: _buildChartContainer("Category Distribution", const ModernCircleChart()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS (SIDII AY AHAAYEEN) ---

  Widget _buildModernFloatingCard(String title, String value, Color accentColor, VoidCallback onTap) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _floatingController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingController.value * 10 - 5),
            child: child,
          );
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border(
                  bottom: BorderSide(color: accentColor, width: 5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: accentColor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Dashboard Overview", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1A1D21))),
        _buildProfileWidget(),
      ],
    );
  }

  Widget _buildProfileWidget() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 5, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 12, 
            backgroundColor: Colors.purpleAccent, 
            child: Icon(Icons.person, size: 14, color: Colors.white)
          ),
          const SizedBox(width: 10),
          const Text("Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          
          PopupMenuButton<String>(
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
            offset: const Offset(0, 45),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onSelected: (value) {
              if (value == 'logout') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent, size: 18),
                    SizedBox(width: 10),
                    Text("Logout", style: TextStyle(color: Colors.redAccent, fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, spreadRadius: 5)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1D21))),
          const SizedBox(height: 25),
          Expanded(child: chart),
        ],
      ),
    );
  }
}

// --- CHARTS (SIDII AY AHAAYEEN) ---

class ModernPerformanceChart extends StatelessWidget {
  const ModernPerformanceChart({super.key});
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.withOpacity(0.05))),
        titlesData: const FlTitlesData(rightTitles: AxisTitles(), topTitles: AxisTitles()),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [FlSpot(0, 3), FlSpot(2, 7), FlSpot(4, 4), FlSpot(6, 8), FlSpot(8, 5), FlSpot(10, 9)],
            isCurved: true,
            color: const Color(0xFF6C5DD3),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [const Color(0xFF6C5DD3).withOpacity(0.2), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          LineChartBarData(
            spots: const [FlSpot(0, 2), FlSpot(2, 4), FlSpot(4, 3), FlSpot(6, 6), FlSpot(8, 4), FlSpot(10, 7)],
            isCurved: true,
            color: const Color(0xFF00C4DF),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}

class ModernCircleChart extends StatelessWidget {
  const ModernCircleChart({super.key});
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 5,
        centerSpaceRadius: 50,
        startDegreeOffset: -90,
        sections: [
          PieChartSectionData(color: const Color(0xFF6C5DD3), value: 40, title: '40%', radius: 20, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(color: const Color(0xFF00C4DF), value: 30, title: '30%', radius: 20, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(color: const Color(0xFFFFAB2D), value: 20, title: '20%', radius: 20, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          PieChartSectionData(color: const Color(0xFFE91E63), value: 10, title: '10%', radius: 20, titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}