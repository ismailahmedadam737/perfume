import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

// ===================== PRODUCT SERVICE =====================
class ProductService {
static const String baseUrl = 'https://perfume-api-hr26.onrender.com/api/products';
  static Future<bool> saveProduct({
    required String name,
    required String brand,
    required String costPrice,
    required String sellPrice,
    required String quantity,
    required String gender,
    Uint8List? imageBytes,
  }) async {
    try {
      String? base64Image;
      if (imageBytes != null) {
        base64Image = base64Encode(imageBytes);
      }

      final Map<String, dynamic> productData = {
        "name": name,
        "brand": brand,
        "costPrice": double.tryParse(costPrice) ?? 0.0,
        "sellPrice": double.tryParse(sellPrice) ?? 0.0,
        "quantity": int.tryParse(quantity) ?? 0,
        "gender": gender,
        "image": base64Image,
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(productData),
      );

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("❌ Cillad xiriir: $e");
      return false;
    }
  }

  // CUSUB: Function-ka cusboonaysiinta (Update)
  static Future<bool> updateProduct(int id, {
    required String name,
    required String brand,
    required String costPrice,
    required String sellPrice,
    required String quantity,
    required String gender,
    Uint8List? imageBytes,
  }) async {
    try {
      String? base64Image;
      if (imageBytes != null) {
        base64Image = base64Encode(imageBytes);
      }

      final Map<String, dynamic> productData = {
        "name": name,
        "brand": brand,
        "costPrice": double.tryParse(costPrice) ?? 0.0,
        "sellPrice": double.tryParse(sellPrice) ?? 0.0,
        "quantity": int.tryParse(quantity) ?? 0,
        "gender": gender,
        "image": base64Image,
      };

      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(productData),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error updating: $e");
      return false;
    }
  }

  static Future<List<dynamic>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print("❌ Error fetching: $e");
      return [];
    }
  }

  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error deleting: $e");
      return false;
    }
  }

  static Future<Object?> fetchSales() async {}
}

// ===================== MAIN APP =====================
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProductRegistrationPage(),
  ));
}

class Product {
  final int? id;
  final String name;
  final String brand;
  final String costPrice;
  final String sellPrice;
  final String quantity;
  final String gender;
  final Uint8List? image;

  Product({
    this.id,
    required this.name,
    required this.brand,
    required this.costPrice,
    required this.sellPrice,
    required this.quantity,
    required this.gender,
    this.image,
  });
}

class ProductRegistrationPage extends StatefulWidget {
  const ProductRegistrationPage({super.key});

  @override
  State<ProductRegistrationPage> createState() => _ProductRegistrationPageState();
}

class _ProductRegistrationPageState extends State<ProductRegistrationPage> {
  Uint8List? _selectedImageBytes;
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _quantityController = TextEditingController();

  String _selectedGender = 'Men';
  final List<String> _genderOptions = ['Men', 'Women', 'Unisex'];
  List<Product> _products = [];
  bool _isLoading = false;
  int? _editingProductId; // Track haddii wax la bedelayo

  @override
  void initState() {
    super.initState();
    _loadProductsFromDatabase();
  }

  Future<void> _loadProductsFromDatabase() async {
    final data = await ProductService.fetchProducts();
    setState(() {
      _products = data.map((item) {
        Uint8List? imgBytes;
        if (item['image'] != null && item['image'].toString().isNotEmpty) {
          try {
            imgBytes = base64Decode(item['image']);
          } catch (e) {
            print("Error decoding image: $e");
          }
        }
        return Product(
          id: item['id'],
          name: item['name'] ?? '',
          brand: item['brand'] ?? '',
          costPrice: item['costPrice']?.toString() ?? '0',
          sellPrice: item['sellPrice']?.toString() ?? '0',
          quantity: item['quantity']?.toString() ?? '0',
          gender: item['gender'] ?? 'Men',
          image: imgBytes,
        );
      }).toList();
    });
  }

  void _prepareUpdate(Product product) {
    setState(() {
      _editingProductId = product.id;
      _nameController.text = product.name;
      _brandController.text = product.brand;
      _costPriceController.text = product.costPrice;
      _sellPriceController.text = product.sellPrice;
      _quantityController.text = product.quantity;
      _selectedGender = product.gender;
      _selectedImageBytes = product.image;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_nameController.text.isNotEmpty && _sellPriceController.text.isNotEmpty) {
      setState(() => _isLoading = true);

      bool success;
      if (_editingProductId == null) {
        success = await ProductService.saveProduct(
          name: _nameController.text,
          brand: _brandController.text,
          costPrice: _costPriceController.text,
          sellPrice: _sellPriceController.text,
          quantity: _quantityController.text,
          gender: _selectedGender,
          imageBytes: _selectedImageBytes,
        );
      } else {
        success = await ProductService.updateProduct(
          _editingProductId!,
          name: _nameController.text,
          brand: _brandController.text,
          costPrice: _costPriceController.text,
          sellPrice: _sellPriceController.text,
          quantity: _quantityController.text,
          gender: _selectedGender,
          imageBytes: _selectedImageBytes,
        );
      }

      if (success) {
        await _loadProductsFromDatabase();
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Guul baa lagu fuliyey!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Fashil baa dhacay!")));
      }
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _brandController.clear();
    _costPriceController.clear();
    _sellPriceController.clear();
    _quantityController.clear();
    setState(() {
      _selectedGender = 'Men';
      _selectedImageBytes = null;
      _editingProductId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(50),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("DIWAANGELI CADAR", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    const SizedBox(height: 40),
                    _buildInput("Magaca Cadarka", Icons.local_offer_outlined, _nameController),
                    const SizedBox(height: 20),
                    _buildInput("Brand-ka", Icons.auto_awesome_outlined, _brandController),
                    const SizedBox(height: 20),
                    _buildInput("Cost Price (\$)", Icons.shopping_cart_outlined, _costPriceController),
                    const SizedBox(height: 20),
                    _buildInput("Sell Price (\$)", Icons.attach_money, _sellPriceController),
                    const SizedBox(height: 20),
                    _buildInput("Quantity", Icons.inventory_2_outlined, _quantityController),
                    const SizedBox(height: 20),
                    const Text("Gender", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          isExpanded: true,
                          items: _genderOptions.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
                          onChanged: (newValue) => setState(() => _selectedGender = newValue!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _isLoading ? const Center(child: CircularProgressIndicator()) : _buildSaveButton(),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    _buildImagePickerSection(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("LIISKA ALAABTA", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: _products.isEmpty
                        ? const Center(child: Text("Ma jirto wax alaab ah oo diwaangashan."))
                        : ListView.builder(
                            itemCount: _products.length,
                            itemBuilder: (context, index) => _buildSlimCard(context, _products[index], index),
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

  Widget _buildInput(String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.amber.shade700),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _saveProduct,
      style: ElevatedButton.styleFrom(
        backgroundColor: _editingProductId == null ? Colors.amber.shade700 : Colors.brown,
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(_editingProductId == null ? "SAVE" : "UPDATE", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Sawirka Cadarka", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: _selectedImageBytes != null
                ? Padding(padding: const EdgeInsets.all(8.0), child: Image.memory(_selectedImageBytes!, fit: BoxFit.contain))
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Riix si aad sawir u doorato", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlimCard(BuildContext context, Product product, int index) {
    return GestureDetector(
      onTap: () => _showProductDetails(context, product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
        ),
        child: Row(
          children: [
            const Icon(Icons.inventory_2_outlined, color: Colors.amber, size: 20),
            const SizedBox(width: 15),
            Text(product.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text("Qty: ${product.quantity}", style: const TextStyle(color: Colors.grey)),
            IconButton(
              icon: const Icon(Icons.edit_note, color: Colors.blueAccent), 
              onPressed: () => _prepareUpdate(product)
            ),
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Xaqiiji"),
                    content: const Text("Ma hubtaa inaad tirtirto alaabtan?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Maya")),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          if (product.id != null) {
                            bool deleted = await ProductService.deleteProduct(product.id!);
                            if (deleted) {
                              setState(() => _products.removeAt(index));
                            }
                          }
                        }, 
                        child: const Text("Haa, Tirtir", style: TextStyle(color: Colors.red))
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: const Color(0xFF2D3436), borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(icon: const Icon(Icons.close, color: Colors.white54), onPressed: () => Navigator.pop(context)),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20)),
                  child: product.image != null
                      ? Padding(padding: const EdgeInsets.all(10.0), child: Image.memory(product.image!, fit: BoxFit.contain))
                      : const Icon(Icons.image_not_supported_outlined, color: Colors.white24, size: 50),
                ),
                const SizedBox(height: 20),
                Text(product.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text("Brand: ${product.brand} | For: ${product.gender}", style: const TextStyle(color: Colors.amber)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _detailText("Cost: \$${product.costPrice}", Colors.white70),
                    _detailText("Qty: ${product.quantity}", Colors.white70),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Udgoon qaali ah oo loogu talagalay dadka jecel inay markasta u muuqdaan kuwo heer sare ah. .",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                Text("\$${product.sellPrice}", style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailText(String text, Color color) => Text(text, style: TextStyle(color: color, fontSize: 14));
}