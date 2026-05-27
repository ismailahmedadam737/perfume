import 'package:flutter/material.dart';

class SystemGuidePage extends StatefulWidget {
  const SystemGuidePage({super.key});

  @override
  State<SystemGuidePage> createState() => _SystemGuidePageState();
}

class _SystemGuidePageState extends State<SystemGuidePage> {
  int _selectedSection = 0;

  final List<Map<String, dynamic>> _sections = [
    {
      "title": "1. Bogga Soo Gelidda (Login)",
      "subtitle": "Albaabka laga galo nidaamka",
      "icon": Icons.login_rounded,
      "description": "Si aad u gasho nidaamka, waa inaad isticmaashaa iimeelka iyo furaha sirta ah (Password) ee uu kuu xooray maamuluhu (Admin). Boggan wuxuu hubinayaa amniga xogta shirkadda.",
      "steps": ["Geli Iimeelkaaga rasmiga ah.", "Ku qor furahaaga sirta ah (Password).", "Riix badhanka 'Login' si aad ugu gudubto Dashboard-ka."],
      "image_url": "https://static.vecteezy.com/system/resources/previews/037/004/913/non_2x/login-form-icon-login-form-page-illustration-vector.jpg",
      "color": Colors.blue,
    },
    {
      "title": "2. Dashboard-ka Guud",
      "subtitle": "Muuqaalka guud ee ganacsigaaga",
      "icon": Icons.grid_view_rounded,
      "description": "Kani waa xog-baahiyaha ugu weyn ee nidaamka. Wuxuu si toos ah u xisaabinayaa dakhliga soo xarooday, tirada alaabta hortaala, iyo dhaqdhaqaaqa iibka ee u dambeeyey.",
      "steps": ["Fiiri wadarta dakhliga (Total Revenue) oo si toos ah loo xisaabiyey.", "La soco tirada guud ee alaabta kaydka ku jirta.", "Eeg garaafyada muujinaya kor u kaca iyo hoos u dhaca iibka.", "Guji card-yada sare si ay kuugu geeyaan bogagga kale si dhakhso ah."],
      "image_url": "https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=800&q=80",
      "color": Colors.deepPurple,
    },
    {
      "title": "3. Macamiisha (Customers)",
      "subtitle": "Maamulka iyo diiwaanka macaamiisha",
      "icon": Icons.people_alt_outlined,
      "description": "Boggan waxaa lagu kaydiyaa xogta macaamiisha joogtada ah ee iibsada uunsiyaadka iyo cadarrada. Waxay ka caawinaysaa shirkadda inay ogaato macaamiisha ugu iibsiga badan.",
      "steps": ["Diiwaangeli macamiil cusub (Magaca iyo Taleefanka).", "U samee raadin (Search) si aad u hesho macamiil hore u jiray.", "La soco taariikhda iibka ee macamiil kasta."],
      "image_url": "https://images.unsplash.com/photo-1556742044-3c52d6e88c62?auto=format&fit=crop&w=800&q=80",
      "color": Colors.teal,
    },
    {
      "title": "4. Diiwaangelinta Alaabta (Products)",
      "subtitle": "Ku darista cadarrada cusub ee kaydka",
      "icon": Icons.shopping_bag_outlined,
      "description": "Halkan waxaa lagu maamulaa dhammaan uunsiyaadka iyo cadarrada (Perfumes) ay shirkaddu iibiso. Waxaad ku qeexaysaa qiimaha iibka, qiimaha iibsiga, iyo tirada bakhaarka ku jirta.",
      "steps": ["Geli magaca cadarka iyo noociisa.", "Ku dar qiimaha jumlada (Purchase Price) iyo qiimaha tafaariiqda (Sales Price).", "Save garee si uu ugu dhex darmo liiska inventory-ga."],
      "image_url": "https://images.unsplash.com/photo-1523293182086-7651a899d37f?auto=format&fit=crop&w=800&q=80",
      "color": Colors.orange,
    },
    {
      "title": "5. Shaqaalaha (Employees)",
      "subtitle": "Maamulka macluumaadka shaqaalaha",
      "icon": Icons.people_outline,
      "description": "Boggan wuxoo u gaar yahay diiwaangelinta shaqaalaha ka shaqeeya dukaanka. Waxaad ku kaydin kartaa teleefankooda, jagada ay hayaan (Role), iyo xogtooda gaarka ah.",
      "steps": ["Diiwaangeli shaqaalaha cusub ee ku soo biira shirkadda.", "U qoondee qaybta ama booska uu qofku ka shaqeeyo.", "Ka edit garee xogta shaqaalaha haddii ay isbeddelato."],
      "image_url": "https://tse1.mm.bing.net/th/id/OIP.-uSUMt51ystamsNiExu4HgHaE8?w=2000&h=1334&rs=1&pid=ImgDetMain&o=7&rm=3",
      "color": Colors.amber,
    },
    {
      "title": "6. Iibinta Alaabta (Sales Products)",
      "subtitle": "Halkaan ka samee iib kasta oo cusub",
      "icon": Icons.calendar_month_outlined,
      "description": "Kani waa bogga POS (Point of Sale) ee shaqaaluhu adeegsadaan marka ay cadar iibinayaan. Wuxuu si fudud u xisaabiyaa wadarta lacagta iyo hadhaaga (Change) loo celinayo macamiilka.",
      "steps": ["Dooro cadarka uu macamiilku doonayo.", "Geli tirada (Quantity) la iibinayo.", "Nidaamku wuxuu si toos ah u dhalinayaa Invoice (Xisaab-ari)."],
      "image_url": "https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?auto=format&fit=crop&w=800&q=80",
      "color": Colors.green,
    },
    {
      "title": "7. Taariikhda Iibka (Sales History)",
      "subtitle": "Eegista dhammaan iibihii hore u dhacay",
      "icon": Icons.history_rounded,
      "description": "Boggan wuxuu u oggolaanayaa maamulaha (Admin) inuu dib u eego dhammaan iibiyadii dhacay maanta, shalay, ama taariikh kasta oo hore. Waxaa lagu baari karaa taariikhda ama iimeelka shaqaalaha.",
      "steps": ["Eeg liiska invoice-yada la iibiyey ee maalinle ah.", "Guji invoice kasta si aad u aragto alaabihii ku dhex jiray.", "La soco wadarta guud ee dakhliga iibka ka soo xarooday."],
      "image_url": "https://tse2.mm.bing.net/th/id/OIP.ZYkJ-7lcXvZsBvVB3Q8bqQHaEK?rs=1&pid=ImgDetMain&o=7&rm=3",
      "color": Colors.indigo,
    },
    {
      "title": "8. Kharashyada (Expenses)",
      "subtitle": "Diiwaangelinta kharashyada dukaanka",
      "icon": Icons.payments_outlined,
      "description": "Si loo ogaado faa'iidada rasmiga ah, nidaamku wuxuu leeyahay qayb lagu qoro kharashyada baxay sida: korontada, kirada dukaanka, gaadiidka, iyo wixii la mid ah.",
      "steps": ["Riix 'Add Expense' si aad u qorto kharash cusub.", "Dooro nooca kharashka (Category) iyo lacagta baxday.", "Kharashkan wuxuu si toos ah uga go'ayaa faa'iidada guud ee General Report-ka."],
      "image_url": "https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?auto=format&fit=crop&w=800&q=80",
      "color": Colors.redAccent,
    },
    {
      "title": "9. Iibsashada (Purchases)",
      "subtitle": "La socoshada alaabta aad adigu soo iibsatay",
      "icon": Icons.shopping_cart_checkout,
      "description": "Boggan waxaa lagu diiwaangeliyaa marka aad alaab cusub ka soo iibsato shirkadaha kale ee keenayaasha ah ee ku yaalla Dubai. Waxay kordhisaa tirada kaydka (Stock Quantity) ee alaabta.",
      "steps": ["Dooro shirkaddii alaabta kuu keentay (Supplier-ka Dubai).", "Geli tirada cadarrada jumlada ah ee ku soo kordhay bakhaarka.", "Hubi in nidaamku si toos ah u cusboonaysiiyey stock-ka iyo xisaabta shirkadda."],
      "image_url": "https://tse1.mm.bing.net/th/id/OIP.jyGGk1PnCuIRvJte2lmyggHaFj?rs=1&pid=ImgDetMain&o=7&rm=3",
      "color": Colors.cyan,
    },
    {
      "title": "10. Keenayaasha (Suppliers)",
      "subtitle": "Maamulka shirkadaha alaabta kuu keena",
      "icon": Icons.local_shipping_outlined,
      "description": "Boggan wuxuu kuu sahlayaa inaad maamusho dhammaan shirkadaha aad alaabta ka iibsato. Waxaad kaydin kartaa magacooda, taleefankooda, iyo hantida ay kugu leeyihiin (Balance).",
      "steps": ["Diiwaangeli shirkad cusub oo kuu keenta Perfumes.", "La soco hadhaaga lacageed ee ay kugu leeyihiin (Supplier Balance).", "U samee update xogtooda mar kasta oo aad lacag bixiso."],
      "image_url": "https://tse3.mm.bing.net/th/id/OIP.zAnph6XklX6ASQFHw2HLVwHaE7?pid=ImgDet&w=194&h=129&c=7&o=7&rm=3",
      "color": Colors.purple,
    },
    {
      "title": "11. Maamulka Users-ka (Users Management)",
      "subtitle": "Xakamaynta awoodaha shaqaalaha",
      "icon": Icons.manage_accounts_outlined,
      "description": "Halkan waxaad ku maamulaysaa dadka xaquuqda u leh inay nidaamka isticmaalaan. Waxaad u kala qaybin kartaa Admin (Maamule awood buuxda leh) iyo User (Shaqaale awood xaddidan leh).",
      "steps": ["Buuxi foomka sare (Magaca, Iimeelka, iyo Password-ka).", "Dooro 'Access Role' (Admin ama User).", "Guji magaca qofka si aad u aragto faahfaahintiisa (User Details Pop-up)."],
      "image_url": "https://tse1.mm.bing.net/th/id/OIP.oMzvu_QyZ1jGhU1vqWuY9wHaE8?w=626&h=418&rs=1&pid=ImgDetMain&o=7&rm=3",
      "color": Colors.pink,
    },
    {
      "title": "12. Warbixinta Guud (General Report)",
      "subtitle": "Xisaabinta Faa'iidada iyo Loss-ka",
      "icon": Icons.analytics_outlined,
      "description": "Kani waa bogga ugu muhiimsan Admin-ka. Wuxuu isku xiraa Wadarta Iibka, Wadarta Iibsashada, iyo Kharashyada si uu kuu siiyo Faa'iidada saafiga ah (Net Profit).",
      "steps": ["Eeg wadarta guud ee faa'iidada muddadii aad doorato.", "La soco shaxda maaliyadeed ee u dhaxeysa kharashka iyo dakhliga.", "Daabaco ama u beddel PDF warbixinta maaliyadeed."],
      "image_url": "https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=800&q=80",
      "color": Colors.blueGrey,
    },
    {
      "title": "13. Mushaharka Shaqaalaha (Salary)",
      "subtitle": "Bixinta iyo maamulka mushaharka",
      "icon": Icons.monetization_on_outlined,
      "description": "Boggan waxaa lagu maamulaa mushaharka shaqaalaha dukaanka. Waxaad ka bixin kartaa mushaharka bishii, waxaadna u qori kartaa advance (horumar) ama gunno haddii ay u qalmaan.",
      "steps": ["Dooro shaqaalaha aad mushaharka u qorayso.", "Geli wadarta mushaharkiisa iyo haddii uu jiro dhimis (Deduction).", "Save garee taariikhda mushaharka la bixiyey."],
      "image_url": "https://images.unsplash.com/photo-1559526324-4b87b5e36e44?auto=format&fit=crop&w=800&q=80",
      "color": Colors.lightGreen,
    },
    {
      "title": "14. Dejinta Nidaamka (Settings)",
      "subtitle": "Habaynta dukaanka iyo kaxamayn",
      "icon": Icons.settings_outlined,
      "description": "Boggan waxaa loogu talagalay in lagu beddelo macluumaadka dukaanka sida magaca shirkadda, taleefanka, lacagta la isticmaalayo (Currency), iyo beddelista profile-ka qofka galay nidaamka.",
      "steps": ["Beddel magaca dukaanka ee ku daabacmaya invoice-ka.", "Cusboonaysii password-kaaga gaarka ah si aad u sugto amniga.", "Dooro luuqadda ama nidaamka midabka ee app-ka."],
      "image_url": "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=800&q=80",
      "color": Colors.grey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentSection = _sections[_selectedSection];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Row(
        children: [
          Container(
            width: 330,
            color: const Color(0xFF1E1E2D),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.pinkAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.auto_stories_rounded, color: Colors.pinkAccent),
                      ),
                      const SizedBox(width: 15),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("System Manual", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Perfume ERP v1.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final item = _sections[index];
                      bool isSelected = _selectedSection == index;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Material(
                          color: isSelected ? Colors.white.withOpacity(0.05) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => setState(() => _selectedSection = index),
                            child: ListTile(
                              dense: true,
                              leading: Icon(item['icon'], color: isSelected ? item['color'] : Colors.grey[400], size: 20),
                              title: Text(item['title'], style: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("© 2026 Perfume Inc. Manual System", style: TextStyle(color: Colors.white30, fontSize: 11)),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(currentSection['icon'], size: 35, color: currentSection['color']),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentSection['title'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1E1E2D))),
                          Text(currentSection['subtitle'], style: const TextStyle(fontSize: 15, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Ujeeddada Boggan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                  const SizedBox(height: 10),
                                  Text(currentSection['description'], style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.6)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15)]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Sida loo isticmaalo (Tallaabooyinka)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                                  const SizedBox(height: 15),
                                  ...(currentSection['steps'] as List<String>).map((step) {
                                    int stepIndex = (currentSection['steps'] as List<String>).indexOf(step) + 1;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(radius: 12, backgroundColor: currentSection['color'].withOpacity(0.1), child: Text(stepIndex.toString(), style: TextStyle(color: currentSection['color'], fontSize: 12, fontWeight: FontWeight.bold))),
                                          const SizedBox(width: 15),
                                          Expanded(child: Text(step, style: const TextStyle(fontSize: 14, color: Colors.black, height: 1.4))),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 520,
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 25, offset: const Offset(0, 10))]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.network(currentSection['image_url'], fit: BoxFit.cover, width: double.infinity, height: double.infinity, key: ValueKey(currentSection['image_url'])),
                                Positioned(
                                  top: 15, right: 15,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(color: currentSection['color'], borderRadius: BorderRadius.circular(30)),
                                    child: const Text("LIVE VIEW", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}