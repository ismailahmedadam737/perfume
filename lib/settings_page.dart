import 'dart:async';
import 'dart:convert'; // Loogu talagalay base64Decode
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
// Hubi in magaca file-ka service-kaagu uu yahay kan:
import 'package:perfume/services/settings_service.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final PageController _pageController = PageController(viewportFraction: 0.35);
  int _currentPage = 0;
  bool _forward = true;
  Timer? _timer;

  // Xogta Dukaanka
  String shopName = "";
  String currencyName = "";
  String phone = "";
  String webLink = "";
  String social = "";
  bool isRegistered = false;

  Uint8List? _webImage;

  // --- API FUNCTIONS ---

  @override
  void initState() {
    super.initState();
    _loadDataFromServer(); // Soo qaado xogta marka page-ka la furo
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_pageController.hasClients) {
        if (_forward) {
          if (_currentPage < _promoCards.length - 1) {
            _currentPage++;
          } else {
            _forward = false;
            _currentPage--;
          }
        } else {
          if (_currentPage > 0) {
            _currentPage--;
          } else {
            _forward = true;
            _currentPage++;
          }
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Function-ka soo akhrinaya xogta Database-ka
  Future<void> _loadDataFromServer() async {
    final data = await SettingsService.fetchSettings();
    if (data != null) {
      setState(() {
        shopName = data['shopName'] ?? "";
        currencyName = data['currencyName'] ?? "";
        phone = data['phone'] ?? "";
        webLink = data['webLink'] ?? "";
        social = data['social'] ?? "";
        isRegistered = data['isRegistered'] ?? false;
        if (data['logoData'] != null && data['logoData'].toString().isNotEmpty) {
          _webImage = base64Decode(data['logoData']);
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _webImage = bytes;
      });
    }
  }

  // --- UI DATA & LOGIC ---

  final List<Map<String, dynamic>> _promoCards = [
    {"text": "Ku Soo Dhawaada!", "color": Colors.pinkAccent},
    {"text": "Tayada waa Hadafkayaga", "color": Colors.blueAccent},
    {"text": "Qiimo Dhimis 20%", "color": Colors.orangeAccent},
    {"text": "Alaab Cusub!", "color": Colors.greenAccent},
    {"text": "Adeeg Degdeg ah", "color": Colors.purpleAccent},
    {"text": "Codso Hadda", "color": Colors.redAccent},
    {"text": "Dammaanad Buuxda", "color": Colors.tealAccent},
    {"text": "Mahadsanid!", "color": Colors.indigoAccent},
  ];

  Future<void> _launchURL(String url) async {
    if (url.isEmpty || url == "Website" || url == "Social") return;
    String formattedUrl = url;
    if (!url.startsWith('http')) {
      formattedUrl = 'https://$url';
    }
    final Uri uri = Uri.parse(formattedUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Ma furi karo link-gan: $e");
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber == "Phone") return;
    final Uri uri = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _showRegistrationForm() {
    final nameCtrl = TextEditingController(text: shopName);
    final currCtrl = TextEditingController(text: currencyName);
    final phoneCtrl = TextEditingController(text: phone);
    final webCtrl = TextEditingController(text: webLink);
    final socialCtrl = TextEditingController(text: social);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Diiwaangeli Macluumaadka"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupField("Shop Name", Icons.store, nameCtrl),
              _buildPopupField("Currency", Icons.monetization_on, currCtrl),
              _buildPopupField("Phone", Icons.phone, phoneCtrl),
              _buildPopupField("Website", Icons.language, webCtrl),
              _buildPopupField("Social Link", Icons.link, socialCtrl),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // KEYDINTA XOGTA EE DATABASE-KA
                  bool success = await SettingsService.saveSettings(
                    shopName: nameCtrl.text,
                    currencyName: currCtrl.text,
                    phone: phoneCtrl.text,
                    webLink: webCtrl.text,
                    social: socialCtrl.text,
                    logoBytes: _webImage,
                    isRegistered: true,
                  );

                  if (success) {
                    setState(() {
                      shopName = nameCtrl.text;
                      currencyName = currCtrl.text;
                      phone = phoneCtrl.text;
                      webLink = webCtrl.text;
                      social = socialCtrl.text;
                      isRegistered = true;
                    });
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text("Keydi Xogta", style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
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
            const Text("Settings", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            SizedBox(
              height: 75,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _promoCards.length,
                padEnds: false,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      bottom: BorderSide(
                        color: _promoCards[index]["color"], 
                        width: 3
                      )
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _promoCards[index]["text"], 
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildCardContainer(
                      title: "Shop Information",
                      children: [
                        const Text("Shop Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        _buildDisplayTextField(isRegistered ? shopName : "Shop Name", Icons.store),
                        const SizedBox(height: 15),
                        const Text("Currency Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        _buildDisplayTextField(isRegistered ? currencyName : "Currency", Icons.monetization_on),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildCardContainer(
                      title: "Shop Logo",
                      topRightWidget: ElevatedButton.icon(
                        onPressed: _showRegistrationForm,
                        icon: const Icon(Icons.add, color: Colors.white, size: 14),
                        label: const Text("Diiwaangeli", style: TextStyle(color: Colors.white, fontSize: 11)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(horizontal: 10)),
                      ),
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: InkWell(
                            onTap: _pickImage, 
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 125,
                              height: 125,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFF5F6FA),
                                border: Border.all(color: Colors.pinkAccent.withOpacity(0.2), width: 4),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                              ),
                              child: _webImage != null 
                                ? Image.memory(_webImage!, fit: BoxFit.cover) 
                                : Icon(
                                    isRegistered ? Icons.add_a_photo : Icons.store,
                                    size: 50,
                                    color: isRegistered ? Colors.pinkAccent : Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("Contact Channels", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildContactBox(Icons.location_on, "Hargeisa, Somaliland", onTap: () {
                  _launchURL("https://www.google.com/maps/search/Hargeisa");
                }),
                _buildContactBox(Icons.phone, isRegistered ? phone : "Phone", onTap: () {
                  if(isRegistered) _makeCall(phone);
                }),
                _buildContactBox(Icons.language, isRegistered ? webLink : "Website", onTap: () {
                  if(isRegistered) _launchURL(webLink);
                }),
                _buildContactBox(Icons.share, isRegistered ? social : "Social", onTap: () {
                  if(isRegistered) _launchURL(social);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- HELPERS (KEEP UI THE SAME) ---

  Widget _buildCardContainer({required String title, required List<Widget> children, Widget? topRightWidget}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (topRightWidget != null) topRightWidget,
            ],
          ),
          const Divider(height: 20),
          Expanded(child: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children))),
        ],
      ),
    );
  }

  Widget _buildDisplayTextField(String hint, IconData icon) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFFF5F6FA), borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(hint, style: const TextStyle(color: Colors.black54, fontSize: 13), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildContactBox(IconData icon, String text, {VoidCallback? onTap}) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Expanded(
          child: MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isHovered ? const Color(0xFFFFEBF2) : Colors.white, 
                  borderRadius: BorderRadius.circular(12), 
                  border: Border.all(color: isHovered ? Colors.pinkAccent : Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: Colors.pinkAccent),
                    const SizedBox(width: 8),
                    Expanded(child: Text(text, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildPopupField(String label, IconData icon, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.pinkAccent, size: 20),
          labelText: label,
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}