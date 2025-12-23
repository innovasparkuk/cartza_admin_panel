import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartza Admin',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Inter',
      ),
      home: const CategoryManagementPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Category {
  String id;
  String categoryName;
  String description;
  int productCount;
  String status;
  String parentId;
  int subcategoryCount;
  DateTime createdAt;
  String imageUrl;
  String? imagePath;

  Category({
    required this.id,
    required this.categoryName,
    required this.description,
    required this.productCount,
    required this.status,
    required this.parentId,
    required this.subcategoryCount,
    required this.createdAt,
    required this.imageUrl,
    this.imagePath,
  });
}

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({Key? key}) : super(key: key);

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}
// Custom Animated Icon Button Widget with Hover Effect
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const AnimatedIconButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 24,
  }) : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.3 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: _isHovered
                ? [BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2)]
                : [],
          ),
          child: IconButton(
            icon: Icon(widget.icon, color: widget.color, size: widget.size),
            onPressed: widget.onPressed,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}

// Custom Animated Button with Hover Effect for +Sub button
class AnimatedAddSubButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedAddSubButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<AnimatedAddSubButton> createState() => _AnimatedAddSubButtonState();
}

class _AnimatedAddSubButtonState extends State<AnimatedAddSubButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            boxShadow: _isHovered
                ? [BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)]
                : [],
            borderRadius: BorderRadius.circular(8),
          ),
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: const Size(0, 0),
              elevation: 0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text('Sub', style: TextStyle(fontSize: 11, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryManagementPageState extends State<CategoryManagementPage>
    with SingleTickerProviderStateMixin {
  List<Category> categories = [];
  Category? editingCategory;
  Category? _editingParentCategory;
  String? pendingDelete;
  Set<String> expandedCategories = {};
  bool showCategoryForm = false;
  String? showingSubcategoryForm;

  late AnimationController _taglineController;
  String selectedMenu = 'Categories';

  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _productCountController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _selectedStatus = 'Active';
  String _imageSource = 'url';
  String? _selectedImagePath;
  String? _selectedAssetImage;
  final ImagePicker _picker = ImagePicker();

  // Sample asset images
  final List<String> assetImages = [
    'assets/images/electronics.png',
    'assets/images/laptop.png',
    'assets/images/tablet.png',
    'assets/images/sports.png',
    'assets/images/books.png',
    'assets/images/toys.png',
  ];

  @override
  void initState() {
    super.initState();
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _loadSampleData();
  }

  void _loadSampleData() {
    categories = [



    // ================== Electronics ==================

    // 1. Tools & Home Improvement
      Category(
        id: '1',
        categoryName: 'Tools & Home Improvement',
        description: 'Tools and hardware',
        productCount: 850,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1581783342900-21e0d6c4e824',
      ),
      Category(
        id: '1-1',
        categoryName: 'Power Tools',
        description: 'Drills and saws',
        productCount: 200,
        status: 'Active',
        parentId: '1',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c',
      ),
      Category(
        id: '1-2',
        categoryName: 'Hand Tools',
        description: 'Hammers and wrenches',
        productCount: 180,
        status: 'Active',
        parentId: '1',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1530124566582-a618bc2615dc',
      ),
      Category(
        id: '1-3',
        categoryName: 'Hardware',
        description: 'Screws and nails',
        productCount: 250,
        status: 'Active',
        parentId: '1',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1565793298595-6a879b1d9492',
      ),
      Category(
        id: '1-4',
        categoryName: 'Home Repair',
        description: 'Repair kits',
        productCount: 220,
        status: 'Active',
        parentId: '1',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1581858809259-089f3d7782f5',
      ),

      // 2. Appliances
      Category(
        id: '2',
        categoryName: 'Appliances',
        description: 'Kitchen and home appliances',
        productCount: 620,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556911220-bff31c812dba',
      ),
      Category(
        id: '2-1',
        categoryName: 'Kitchen Appliances',
        description: 'Blenders and toasters',
        productCount: 280,
        status: 'Active',
        parentId: '2',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1585659722983-3a675dabf23d',
      ),
      Category(
        id: '2-2',
        categoryName: 'Small Appliances',
        description: 'Coffee makers',
        productCount: 190,
        status: 'Active',
        parentId: '2',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
      ),
      Category(
        id: '2-3',
        categoryName: 'Large Appliances',
        description: 'Refrigerators and washers',
        productCount: 150,
        status: 'Active',
        parentId: '2',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5',
      ),

      // 3. Office & School Supplies
      Category(
        id: '3',
        categoryName: 'Office & School Supplies',
        description: 'Stationery and supplies',
        productCount: 540,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b',
      ),
      Category(
        id: '3-1',
        categoryName: 'Writing Supplies',
        description: 'Pens and pencils',
        productCount: 150,
        status: 'Active',
        parentId: '3',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a',
      ),
      Category(
        id: '3-2',
        categoryName: 'Notebooks',
        description: 'Journals and notepads',
        productCount: 130,
        status: 'Active',
        parentId: '3',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1531346878377-a5be20888e57',
      ),
      Category(
        id: '3-3',
        categoryName: 'Office Equipment',
        description: 'Staplers and organizers',
        productCount: 140,
        status: 'Active',
        parentId: '3',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c',
      ),
      Category(
        id: '3-4',
        categoryName: 'School Backpacks',
        description: 'Student bags',
        productCount: 120,
        status: 'Active',
        parentId: '3',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',
      ),

      // 4. Health & Household
      Category(
        id: '4',
        categoryName: 'Health & Household',
        description: 'Health and cleaning products',
        productCount: 780,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571',
      ),
      Category(
        id: '4-1',
        categoryName: 'Personal Care',
        description: 'Hygiene products',
        productCount: 220,
        status: 'Active',
        parentId: '4',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556228852-80c74e6f93c0',
      ),
      Category(
        id: '4-2',
        categoryName: 'Cleaning Supplies',
        description: 'Detergents and cleaners',
        productCount: 260,
        status: 'Active',
        parentId: '4',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1563453392212-326f5e854473',
      ),
      Category(
        id: '4-3',
        categoryName: 'Health Products',
        description: 'Vitamins and supplements',
        productCount: 180,
        status: 'Active',
        parentId: '4',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72',
      ),
      Category(
        id: '4-4',
        categoryName: 'Household Items',
        description: 'Storage and organizers',
        productCount: 120,
        status: 'Active',
        parentId: '4',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556911220-bff31c812dba',
      ),

      // 5. Pet Supplies
      Category(
        id: '5',
        categoryName: 'Pet Supplies',
        description: 'Products for pets',
        productCount: 450,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1415369629372-26f2fe60c467',
      ),
      Category(
        id: '5-1',
        categoryName: 'Dog Supplies',
        description: 'Food and toys',
        productCount: 180,
        status: 'Active',
        parentId: '5',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1',
      ),
      Category(
        id: '5-2',
        categoryName: 'Cat Supplies',
        description: 'Litter and accessories',
        productCount: 160,
        status: 'Active',
        parentId: '5',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1573865526739-10c1d3a1f0cc',
      ),
      Category(
        id: '5-3',
        categoryName: 'Pet Accessories',
        description: 'Collars and beds',
        productCount: 110,
        status: 'Active',
        parentId: '5',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
      ),

      // 6. Cell Phones & Accessories
      Category(
        id: '6',
        categoryName: 'Cell Phones & Accessories',
        description: 'Phones and accessories',
        productCount: 920,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9',
      ),
      Category(
        id: '6-1',
        categoryName: 'Phone Cases',
        description: 'Protective cases',
        productCount: 350,
        status: 'Active',
        parentId: '6',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb',
      ),
      Category(
        id: '6-2',
        categoryName: 'Chargers & Cables',
        description: 'USB cables',
        productCount: 280,
        status: 'Active',
        parentId: '6',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0',
      ),
      Category(
        id: '6-3',
        categoryName: 'Screen Protectors',
        description: 'Tempered glass',
        productCount: 190,
        status: 'Active',
        parentId: '6',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556656793-08538906a9f8',
      ),
      Category(
        id: '6-4',
        categoryName: 'Phone Holders',
        description: 'Car mounts',
        productCount: 100,
        status: 'Active',
        parentId: '6',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
      ),

      // 7. Smart Home
      Category(
        id: '7',
        categoryName: 'Smart Home',
        description: 'Smart devices',
        productCount: 380,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1558002038-1055907df827',
      ),
      Category(
        id: '7-1',
        categoryName: 'Smart Lights',
        description: 'LED bulbs',
        productCount: 140,
        status: 'Active',
        parentId: '7',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1550439062-609e1531270e',
      ),
      Category(
        id: '7-2',
        categoryName: 'Smart Speakers',
        description: 'Voice assistants',
        productCount: 130,
        status: 'Active',
        parentId: '7',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1589492477829-5e65395b66cc',
      ),
      Category(
        id: '7-3',
        categoryName: 'Security Systems',
        description: 'Cameras and sensors',
        productCount: 110,
        status: 'Active',
        parentId: '7',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1557324232-b8917d3c3dcb',
      ),

      // 8. Musical Instruments
      Category(
        id: '8',
        categoryName: 'Musical Instruments',
        description: 'Music equipment',
        productCount: 290,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
      ),
      Category(
        id: '8-1',
        categoryName: 'Guitars',
        description: 'Acoustic and electric',
        productCount: 120,
        status: 'Active',
        parentId: '8',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1',
      ),
      Category(
        id: '8-2',
        categoryName: 'Keyboards',
        description: 'Digital pianos',
        productCount: 90,
        status: 'Active',
        parentId: '8',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
      ),
      Category(
        id: '8-3',
        categoryName: 'Accessories',
        description: 'Strings and picks',
        productCount: 80,
        status: 'Active',
        parentId: '8',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1519892300165-cb5542fb47c7',
      ),

      // 9. Furniture
      Category(
        id: '9',
        categoryName: 'Furniture',
        description: 'Home furniture',
        productCount: 680,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
      ),
      Category(
        id: '9-1',
        categoryName: 'Living Room',
        description: 'Sofas and tables',
        productCount: 220,
        status: 'Active',
        parentId: '9',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1567016432779-094069958ea5',
      ),
      Category(
        id: '9-2',
        categoryName: 'Bedroom',
        description: 'Beds and dressers',
        productCount: 200,
        status: 'Active',
        parentId: '9',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1560448204-603b3fc33ddc',
      ),
      Category(
        id: '9-3',
        categoryName: 'Office Furniture',
        description: 'Desks and chairs',
        productCount: 160,
        status: 'Active',
        parentId: '9',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36',
      ),
      Category(
        id: '9-4',
        categoryName: 'Storage',
        description: 'Shelves and cabinets',
        productCount: 100,
        status: 'Active',
        parentId: '9',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2',
      ),

      // 10. Beachwear
      Category(
        id: '10',
        categoryName: 'Beachwear',
        description: 'Swimwear and beach items',
        productCount: 320,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1519046904884-53103b34b206',
      ),
      Category(
        id: '10-1',
        categoryName: 'Swimsuits',
        description: 'One-piece and bikinis',
        productCount: 150,
        status: 'Active',
        parentId: '10',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1562089365-e9e79a2c8566',
      ),
      Category(
        id: '10-2',
        categoryName: 'Cover-ups',
        description: 'Beach dresses',
        productCount: 100,
        status: 'Active',
        parentId: '10',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1523359346063-d879354c0ea5',
      ),
      Category(
        id: '10-3',
        categoryName: 'Beach Accessories',
        description: 'Towels and bags',
        productCount: 70,
        status: 'Active',
        parentId: '10',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a',
      ),

      // 11. Books & Media
      Category(
        id: '11',
        categoryName: 'Books & Media',
        description: 'Books and media',
        productCount: 540,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
      ),
      Category(
        id: '11-1',
        categoryName: 'Books',
        description: 'Fiction and non-fiction',
        productCount: 280,
        status: 'Active',
        parentId: '11',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d',
      ),
      Category(
        id: '11-2',
        categoryName: 'Magazines',
        description: 'Periodicals',
        productCount: 130,
        status: 'Active',
        parentId: '11',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1517842645767-c639042777db',
      ),
      Category(
        id: '11-3',
        categoryName: 'Media Storage',
        description: 'Book stands',
        productCount: 130,
        status: 'Active',
        parentId: '11',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
      ),

      // 12. Food & Grocery
      Category(
        id: '12',
        categoryName: 'Food & Grocery',
        description: 'Food items',
        productCount: 890,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1543168256-8133cc8e3ee4',
      ),
      Category(
        id: '12-1',
        categoryName: 'Snacks',
        description: 'Chips and cookies',
        productCount: 280,
        status: 'Active',
        parentId: '12',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087',
      ),
      Category(
        id: '12-2',
        categoryName: 'Beverages',
        description: 'Drinks and juices',
        productCount: 240,
        status: 'Active',
        parentId: '12',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1546548970-71785318a17b',
      ),
      Category(
        id: '12-3',
        categoryName: 'Canned Goods',
        description: 'Preserved foods',
        productCount: 200,
        status: 'Active',
        parentId: '12',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1588964895597-cfccd6e2dbf9',
      ),
      Category(
        id: '12-4',
        categoryName: 'Fresh Produce',
        description: 'Fruits and vegetables',
        productCount: 170,
        status: 'Active',
        parentId: '12',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf',
      ),

      // 13. Featured
      Category(
        id: '13',
        categoryName: 'Featured',
        description: 'Featured products',
        productCount: 450,
        status: 'Active',
        parentId: '',
        subcategoryCount: 3,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
      ),
      Category(
        id: '13-1',
        categoryName: 'Best Sellers',
        description: 'Top products',
        productCount: 180,
        status: 'Active',
        parentId: '13',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da',
      ),
      Category(
        id: '13-2',
        categoryName: 'New Arrivals',
        description: 'Latest products',
        productCount: 150,
        status: 'Active',
        parentId: '13',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1555529902-5261145633bf',
      ),
      Category(
        id: '13-3',
        categoryName: 'Deals',
        description: 'Special offers',
        productCount: 120,
        status: 'Active',
        parentId: '13',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1607082349566-187342175e2f',
      ),

      // 14. Home & Kitchen
      Category(
        id: '14',
        categoryName: 'Home & Kitchen',
        description: 'Kitchen and home items',
        productCount: 760,
        status: 'Active',
        parentId: '',
        subcategoryCount: 4,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556911220-bff31c812dba',
      ),
      Category(
        id: '14-1',
        categoryName: 'Cookware',
        description: 'Pots and pans',
        productCount: 220,
        status: 'Active',
        parentId: '14',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136',
      ),
      Category(
        id: '14-2',
        categoryName: 'Dinnerware',
        description: 'Plates and bowls',
        productCount: 190,
        status: 'Active',
        parentId: '14',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d',
      ),
      Category(
        id: '14-3',
        categoryName: 'Kitchen Gadgets',
        description: 'Utensils and tools',
        productCount: 210,
        status: 'Active',
        parentId: '14',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d',
      ),
      Category(
        id: '14-4',
        categoryName: 'Home Decor',
        description: 'Decorative items',
        productCount: 140,
        status: 'Active',
        parentId: '14',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15',
      ),

      // 15. Women's Clothing
      Category(
        id: '15',
        categoryName: "Women's Clothing",
        description: 'Fashion for women',
        productCount: 1200,
        status: 'Active',
        parentId: '',
        subcategoryCount: 5,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
      ),
      Category(
        id: '15-1',
        categoryName: 'Dresses',
        description: 'Casual and formal',
        productCount: 320,
        status: 'Active',
        parentId: '15',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8',
      ),
      Category(
        id: '15-2',
        categoryName: 'Tops',
        description: 'Blouses and shirts',
        productCount: 280,
        status: 'Active',
        parentId: '15',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1564859228273-274232fdb516',
      ),
      Category(
        id: '15-3',
        categoryName: 'Bottoms',
        description: 'Pants and skirts',
        productCount: 250,
        status: 'Active',
        parentId: '15',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1',
      ),
      Category(
        id: '15-4',
        categoryName: 'Outerwear',
        description: 'Jackets and coats',
        productCount: 200,
        status: 'Active',
        parentId: '15',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
      ),
    Category(
    id: '15-5',
    categoryName: 'Activewear',
    description: 'Gym and sports',
    productCount: 150,
    status: 'Active',
    parentId: '15',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1518310952931-b1de897abd40',
    ),

    // 16. Women's Curve Clothing
    Category(
    id: '16',
    categoryName: "Women's Curve Clothing",
    description: 'Plus size fashion',
    productCount: 580,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1581044777550-4cfa60707c03',
    ),
    Category(
    id: '16-1',
    categoryName: 'Curve Dresses',
    description: 'Plus size dresses',
    productCount: 220,
    status: 'Active',
    parentId: '16',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1560243563-062bfc001d68',
    ),
    Category(
    id: '16-2',
    categoryName: 'Curve Tops',
    description: 'Plus size tops',
    productCount: 190,
    status: 'Active',
    parentId: '16',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a',
    ),
    Category(
    id: '16-3',
    categoryName: 'Curve Bottoms',
    description: 'Plus size pants',
    productCount: 170,
    status: 'Active',
    parentId: '16',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1',
    ),

    // 17. Women's Shoes
    Category(
    id: '17',
    categoryName: "Women's Shoes",
    description: 'Footwear for women',
    productCount: 680,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2',
    ),
    Category(
    id: '17-1',
    categoryName: 'Heels',
    description: 'High heels',
    productCount: 200,
    status: 'Active',
    parentId: '17',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae',
    ),
    Category(
    id: '17-2',
    categoryName: 'Flats',
    description: 'Casual flats',
    productCount: 180,
    status: 'Active',
    parentId: '17',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1603487742131-4160ec999306',
    ),
    Category(
    id: '17-3',
    categoryName: 'Sneakers',
    description: 'Athletic shoes',
    productCount: 170,
    status: 'Active',
    parentId: '17',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86',
    ),
    Category(
    id: '17-4',
    categoryName: 'Boots',
    description: 'Ankle and knee boots',
    productCount: 130,
    status: 'Active',
    parentId: '17',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1608256246200-53e635b5b65f',
    ),

    // 18. Women's Lingerie & Lounge
    Category(
    id: '18',
    categoryName: "Women's Lingerie & Lounge",
    description: 'Intimate apparel',
    productCount: 520,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1606306148533-e82d5d1e8abd',
    ),
    Category(
    id: '18-1',
    categoryName: 'Bras',
    description: 'All types of bras',
    productCount: 200,
    status: 'Active',
    parentId: '18',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1583009787198-f57c27ca2763',
    ),
    Category(
    id: '18-2',
    categoryName: 'Sleepwear',
    description: 'Pajamas and robes',
    productCount: 180,
    status: 'Active',
    parentId: '18',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1591408017367-0a5ad48221c8',
    ),
    Category(
    id: '18-3',
    categoryName: 'Loungewear',
    description: 'Comfortable clothing',
    productCount: 140,
    status: 'Active',
    parentId: '18',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1596870230751-ebdfce98ec42',
    ),

    // 19. Men's Clothing
    Category(
    id: '19',
    categoryName: "Men's Clothing",
    description: 'Fashion for men',
    productCount: 980,
    status: 'Active',
    parentId: '',
    subcategoryCount: 5,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1490578474895-699cd4e2cf59',
    ),
    Category(
    id: '19-1',
    categoryName: 'Shirts',
    description: 'Casual and dress shirts',
    productCount: 260,
    status: 'Active',
    parentId: '19',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf',
    ),
    Category(
    id: '19-2',
    categoryName: 'Pants',
    description: 'Jeans and trousers',
    productCount: 240,
    status: 'Active',
    parentId: '19',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a',
    ),
    Category(
    id: '19-3',
    categoryName: 'T-Shirts',
    description: 'Casual tees',
    productCount: 220,
    status: 'Active',
    parentId: '19',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab',
    ),
    Category(
    id: '19-4',
    categoryName: 'Jackets',
    description: 'Coats and blazers',
    productCount: 160,
    status: 'Active',
    parentId: '19',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5',
    ),
    Category(
    id: '19-5',
    categoryName: 'Suits',
    description: 'Formal wear',
    productCount: 100,
    status: 'Active',
    parentId: '19',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf',
    ),

    // 20. Men's Shoes
    Category(
    id: '20',
    categoryName: "Men's Shoes",
    description: 'Footwear for men',
    productCount: 560,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2',
    ),
    Category(
    id: '20-1',
    categoryName: 'Sneakers',
    description: 'Casual sneakers',
    productCount: 200,
    status: 'Active',
    parentId: '20',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    ),
    Category(
    id: '20-2',
    categoryName: 'Dress Shoes',
    description: 'Formal shoes',
    productCount: 150,
    status: 'Active',
    parentId: '20',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4',
    ),
    Category(
    id: '20-3',
    categoryName: 'Boots',
    description: 'Work and casual boots',
    productCount: 130,
    status: 'Active',
    parentId: '20',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1605812860427-4024433a70fd',
    ),
    Category(
    id: '20-4',
    categoryName: 'Sandals',
    description: 'Summer footwear',
    productCount: 80,
    status: 'Active',
    parentId: '20',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1603487742131-4160ec999306',
    ),

    // 21. Men's Big & Tall
    Category(
    id: '21',
    categoryName: "Men's Big & Tall",
    description: 'Extended sizes',
    productCount: 420,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1617127365659-c47fa864d8bc',
    ),
    Category(
    id: '21-1',
    categoryName: 'Big & Tall Shirts',
    description: 'Extended size shirts',
    productCount: 160,
    status: 'Active',
    parentId: '21',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf',
    ),
    Category(
    id: '21-2',
    categoryName: 'Big & Tall Pants',
    description: 'Extended size pants',
    productCount: 150,
    status: 'Active',
    parentId: '21',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a',
    ),
    Category(
    id: '21-3',
    categoryName: 'Big & Tall Outerwear',
    description: 'Extended size jackets',
    productCount: 110,
    status: 'Active',
    parentId: '21',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1551028719-00167b16eac5',
    ),

    // 22. Men's Underwear & Sleepwear
    Category(
    id: '22',
    categoryName: "Men's Underwear & Sleepwear",
    description: 'Intimate apparel',
    productCount: 380,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1614030424754-24d0eebd46b2',
    ),
    Category(
    id: '22-1',
    categoryName: 'Underwear',
    description: 'Boxers and briefs',
    productCount: 180,
    status: 'Active',
    parentId: '22',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1596755389378-c31d21fd1273',
    ),
    Category(
    id: '22-2',
    categoryName: 'Sleepwear',
    description: 'Pajamas',
    productCount: 120,
    status: 'Active',
    parentId: '22',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1578102718171-ec1f91680562',
    ),
    Category(
    id: '22-3',
    categoryName: 'Socks',
    description: 'Casual and dress socks',
    productCount: 80,
    status: 'Active',
    parentId: '22',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1586350977865-ae4e0ce3f4e3',
    ),

    // 23. Sports & Outdoors
    Category(
    id: '23',
    categoryName: 'Sports & Outdoors',
    description: 'Outdoor and sports gear',
    productCount: 740,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1452626038306-9aae5e071dd3',
    ),
    Category(
    id: '23-1',
    categoryName: 'Camping',
    description: 'Tents and sleeping bags',
    productCount: 220,
    status: 'Active',
    parentId: '23',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4',
    ),
    Category(
    id: '23-2',
    categoryName: 'Fitness Equipment',
    description: 'Weights and gear',
    productCount: 200,
    status: 'Active',
    parentId: '23',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
    ),
    Category(
    id: '23-3',
    categoryName: 'Outdoor Gear',
    description: 'Hiking equipment',
    productCount: 180,
    status: 'Active',
    parentId: '23',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1501555088652-021faa106b9b',
    ),
    Category(
    id: '23-4',
    categoryName: 'Sports Accessories',
    description: 'Balls and equipment',
    productCount: 140,
    status: 'Active',
    parentId: '23',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1461896836934-ffe607ba8211',
    ),

    // 24. Jewelry & Accessories
    Category(
    id: '24',
    categoryName: 'Jewelry & Accessories',
    description: 'Fashion accessories',
    productCount: 620,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908',
    ),
    Category(
    id: '24-1',
    categoryName: 'Necklaces',
    description: 'Chains and pendants',
    productCount: 180,
    status: 'Active',
    parentId: '24',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f',
    ),
    Category(
    id: '24-2',
    categoryName: 'Earrings',
    description: 'Studs and hoops',
    productCount: 170,
    status: 'Active',
    parentId: '24',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908',
    ),
    Category(
    id: '24-3',
    categoryName: 'Bracelets',
    description: 'Bangles and chains',
    productCount: 150,
    status: 'Active',
    parentId: '24',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a',
    ),
    Category(
    id: '24-4',
    categoryName: 'Watches',
    description: 'Fashion watches',
    productCount: 120,
    status: 'Active',
    parentId: '24',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314',
    ),

    // 25. Beauty & Health
    Category(
    id: '25',
    categoryName: 'Beauty & Health',
    description: 'Beauty products',
    productCount: 890,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348',
    ),
    Category(
    id: '25-1',
    categoryName: 'Skincare',
    description: 'Face and body care',
    productCount: 280,
    status: 'Active',
    parentId: '25',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881',
    ),
    Category(
    id: '25-2',
    categoryName: 'Makeup',
    description: 'Cosmetics',
    productCount: 260,
    status: 'Active',
    parentId: '25',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796',
    ),
    Category(
    id: '25-3',
    categoryName: 'Haircare',
    description: 'Shampoo and styling',
    productCount: 210,
    status: 'Active',
    parentId: '25',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1527799820374-dcf8d9d4a388',
    ),
    Category(
    id: '25-4',
    categoryName: 'Fragrance',
    description: 'Perfumes',
    productCount: 140,
    status: 'Active',
    parentId: '25',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1541643600914-78b084683601',
    ),

    // 26. Toys & Games
    Category(
    id: '26',
    categoryName: 'Toys & Games',
    description: 'Fun for all ages',
    productCount: 720,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1558060370-d644479cb6f7',
    ),
    Category(
    id: '26-1',
    categoryName: 'Action Figures',
    description: 'Collectible toys',
    productCount: 200,
    status: 'Active',
    parentId: '26',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3',
    ),
    Category(
    id: '26-2',
    categoryName: 'Board Games',
    description: 'Family games',
    productCount: 180,
    status: 'Active',
    parentId: '26',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1606167668584-78701c57f13d',
    ),
    Category(
    id: '26-3',
    categoryName: 'Puzzles',
    description: 'Jigsaw puzzles',
    productCount: 170,
    status: 'Active',
    parentId: '26',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1587731556938-38755b4803a6',
    ),
    Category(
    id: '26-4',
    categoryName: 'Educational Toys',
    description: 'Learning games',
    productCount: 170,
    status: 'Active',
    parentId: '26',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1587654780291-39c9404d746b',
    ),

    // 27. Automotive
    Category(
    id: '27',
    categoryName: 'Automotive',
    description: 'Car accessories',
    productCount: 560,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7',
    ),
    Category(
    id: '27-1',
    categoryName: 'Car Parts',
    description: 'Replacement parts',
    productCount: 180,
    status: 'Active',
    parentId: '27',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3',
    ),
    Category(
    id: '27-2',
    categoryName: 'Car Accessories',
    description: 'Interior items',
    productCount: 160,
    status: 'Active',
    parentId: '27',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d',
    ),
    Category(
    id: '27-3',
    categoryName: 'Car Care',
    description: 'Cleaning supplies',
    productCount: 130,
    status: 'Active',
    parentId: '27',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1601362840469-51e4d8d58785',
    ),
    Category(
    id: '27-4',
    categoryName: 'Tools',
    description: 'Automotive tools',
    productCount: 90,
    status: 'Active',
    parentId: '27',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1530124566582-a618bc2615dc',
    ),

    // 28. Kids' Fashion
    Category(
    id: '28',
    categoryName: "Kids' Fashion",
    description: 'Clothing for children',
    productCount: 680,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1514090458221-65bb69cf63e2',
    ),
    Category(
    id: '28-1',
    categoryName: 'Boys Clothing',
    description: 'Shirts and pants',
    productCount: 200,
    status: 'Active',
    parentId: '28',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2',
    ),
    Category(
    id: '28-2',
    categoryName: 'Girls Clothing',
    description: 'Dresses and tops',
    productCount: 220,
    status: 'Active',
    parentId: '28',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7',
    ),
    Category(
    id: '28-3',
    categoryName: 'Toddler Clothing',
    description: 'Outfits for toddlers',
    productCount: 160,
    status: 'Active',
    parentId: '28',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1519238263530-99bdd11df2ea',
    ),
    Category(
    id: '28-4',
    categoryName: 'School Uniforms',
    description: 'Uniform sets',
    productCount: 100,
    status: 'Active',
    parentId: '28',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9',
    ),

    // 29. Kids' Shoes
    Category(
    id: '29',
    categoryName: "Kids' Shoes",
    description: 'Footwear for children',
    productCount: 420,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1514090458221-65bb69cf63e2',
    ),
    Category(
    id: '29-1',
    categoryName: 'Sneakers',
    description: 'Kids sneakers',
    productCount: 170,
    status: 'Active',
    parentId: '29',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519',
    ),
    Category(
    id: '29-2',
    categoryName: 'Sandals',
    description: 'Summer shoes',
    productCount: 130,
    status: 'Active',
    parentId: '29',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1603808033192-082d6919d3e1',
    ),
    Category(
    id: '29-3',
    categoryName: 'Boots',
    description: 'Kids boots',
    productCount: 120,
    status: 'Active',
    parentId: '29',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1519378058457-4c29a0a2efac',
    ),

    // 30. Baby & Maternity
    Category(
    id: '30',
    categoryName: 'Baby & Maternity',
    description: 'Baby products',
    productCount: 760,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4',
    ),
    Category(
    id: '30-1',
    categoryName: 'Baby Clothing',
    description: 'Onesies and outfits',
    productCount: 220,
    status: 'Active',
    parentId: '30',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af',
    ),
    Category(
    id: '30-2',
    categoryName: 'Feeding',
    description: 'Bottles and bibs',
    productCount: 200,
    status: 'Active',
    parentId: '30',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4',
    ),
    Category(
    id: '30-3',
    categoryName: 'Nursery',
    description: 'Cribs and decor',
    productCount: 180,
    status: 'Active',
    parentId: '30',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af',
    ),
    Category(
    id: '30-4',
    categoryName: 'Maternity Wear',
    description: 'Pregnancy clothing',
    productCount: 160,
    status: 'Active',
    parentId: '30',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1459411552884-841db9b3cc2a',
    ),

    // 31. Bags & Luggage
    Category(
    id: '31',
    categoryName: 'Bags & Luggage',
    description: 'Travel and bags',
    productCount: 590,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',
    ),
    Category(
    id: '31-1',
    categoryName: 'Backpacks',
    description: 'Travel backpacks',
    productCount: 180,
    status: 'Active',
    parentId: '31',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',
    ),
    Category(
    id: '31-2',
    categoryName: 'Handbags',
    description: 'Purses and totes',
    productCount: 170,
    status: 'Active',
    parentId: '31',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7',
    ),
    Category(
    id: '31-3',
    categoryName: 'Suitcases',
    description: 'Rolling luggage',
    productCount: 140,
    status: 'Active',
    parentId: '31',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1565026057447-bc90a3dceb87',
    ),
    Category(
    id: '31-4',
    categoryName: 'Travel Accessories',
    description: 'Packing cubes',
    productCount: 100,
    status: 'Active',
    parentId: '31',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1530542033535-21b1d1d1f6b1',
    ),

    // 32. Patio, Lawn & Garden
    Category(
    id: '32',
    categoryName: 'Patio, Lawn & Garden',
    description: 'Outdoor living',
    productCount: 640,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b',
    ),
    Category(
    id: '32-1',
    categoryName: 'Garden Tools',
    description: 'Shovels and rakes',
    productCount: 180,
    status: 'Active',
    parentId: '32',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1617576683096-00fc8eecb3af',
    ),
    Category(
    id: '32-2',
    categoryName: 'Outdoor Furniture',
    description: 'Patio sets',
    productCount: 200,
    status: 'Active',
    parentId: '32',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1600210492493-0946911123ea',
    ),
    Category(
    id: '32-3',
    categoryName: 'Plants & Seeds',
    description: 'Gardening supplies',
    productCount: 160,
    status: 'Active',
    parentId: '32',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735',
    ),
    Category(
    id: '32-4',
    categoryName: 'Grills',
    description: 'BBQ equipment',
    productCount: 100,
    status: 'Active',
    parentId: '32',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1',
    ),

    // 33. Arts, Crafts & Sewing
    Category(
    id: '33',
    categoryName: 'Arts, Crafts & Sewing',
    description: 'Creative supplies',
    productCount: 520,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1452860606245-08befc0ff44b',
    ),
    Category(
    id: '33-1',
    categoryName: 'Painting',
    description: 'Paints and brushes',
    productCount: 160,
    status: 'Active',
    parentId: '33',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b',
    ),
    Category(
    id: '33-2',
    categoryName: 'Sewing',
    description: 'Fabric and thread',
    productCount: 150,
    status: 'Active',
    parentId: '33',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1597476660412-a5a0614d49b1',
    ),
    Category(
    id: '33-3',
    categoryName: 'Crafting Tools',
    description: 'Scissors and glue',
    productCount: 130,
    status: 'Active',
    parentId: '33',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1572372686325-0b2b779f5b3b',
    ),
    Category(
    id: '33-4',
    categoryName: 'Paper Crafts',
    description: 'Scrapbooking',
    productCount: 80,
    status: 'Active',
    parentId: '33',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1513364776144-60967b0f800f',
    ),

    // 34. Electronics
    Category(
    id: '34',
    categoryName: 'Electronics',
    description: 'Tech devices',
    productCount: 980,
    status: 'Active',
    parentId: '',
    subcategoryCount: 5,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1498049794561-7780e7231661',
    ),
    Category(
    id: '34-1',
    categoryName: 'Headphones',
    description: 'Wireless and wired',
    productCount: 240,
    status: 'Active',
    parentId: '34',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
    ),
    Category(
    id: '34-2',
    categoryName: 'Cameras',
    description: 'Digital cameras',
    productCount: 190,
    status: 'Active',
    parentId: '34',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32',
    ),
    Category(
    id: '34-3',
    categoryName: 'Tablets',
    description: 'Android and iOS',
    productCount: 200,
    status: 'Active',
    parentId: '34',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1561154464-82e9adf32764',
    ),
    Category(
    id: '34-4',
    categoryName: 'Laptops',
    description: 'Notebooks',
    productCount: 180,
    status: 'Active',
    parentId: '34',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853',
    ),
    Category(
    id: '34-5',
    categoryName: 'Smartwatches',
    description: 'Wearable tech',
    productCount: 170,
    status: 'Active',
    parentId: '34',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1579586337278-3befd40fd17a',
    ),

    // 35. Business, Industry & Science
    Category(
    id: '35',
    categoryName: 'Business, Industry & Science',
    description: 'Professional equipment',
    productCount: 440,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40',
    ),
    Category(
    id: '35-1',
    categoryName: 'Lab Equipment',
    description: 'Scientific tools',
    productCount: 160,
    status: 'Active',
    parentId: '35',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d',
    ),
    Category(
    id: '35-2',
    categoryName: 'Industrial Tools',
    description: 'Heavy equipment',
    productCount: 150,
    status: 'Active',
    parentId: '35',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1581092918484-8313e1f7e8c7',
    ),
    Category(
    id: '35-3',
    categoryName: 'Office Machines',
    description: 'Printers and copiers',
    productCount: 130,
    status: 'Active',
    parentId: '35',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1612815154858-60aa4c59eaa6',
    ),
    Category(
    id: '35-3',
    categoryName: 'Tools & Home Improvement',
    description: 'Tools and hardware',
    productCount: 850,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1581783342900-21e0d6c4e824',
    ),
    Category(
    id: '1-1',
    categoryName: 'Power Tools',
    description: 'Drills and saws',
    productCount: 200,
    status: 'Active',
    parentId: '1',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1504148455328-c376907d081c',
    ),
    Category(
    id: '1-2',
    categoryName: 'Hand Tools',
    description: 'Hammers and wrenches',
    productCount: 180,
    status: 'Active',
    parentId: '1',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1530124566582-a618bc2615dc',
    ),
    Category(
    id: '1-3',
    categoryName: 'Hardware',
    description: 'Screws and nails',
    productCount: 250,
    status: 'Active',
    parentId: '1',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1565793298595-6a879b1d9492',
    ),
    Category(
    id: '1-4',
    categoryName: 'Home Repair',
    description: 'Repair kits',
    productCount: 220,
    status: 'Active',
    parentId: '1',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1581858809259-089f3d7782f5',
    ),

    // 2. Appliances
    Category(
    id: '2',
    categoryName: 'Appliances',
    description: 'Kitchen and home appliances',
    productCount: 620,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556911220-bff31c812dba',
    ),
    Category(
    id: '2-1',
    categoryName: 'Kitchen Appliances',
    description: 'Blenders and toasters',
    productCount: 280,
    status: 'Active',
    parentId: '2',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1585659722983-3a675dabf23d',
    ),
    Category(
    id: '2-2',
    categoryName: 'Small Appliances',
    description: 'Coffee makers',
    productCount: 190,
    status: 'Active',
    parentId: '2',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
    ),
    Category(
    id: '2-3',
    categoryName: 'Large Appliances',
    description: 'Refrigerators and washers',
    productCount: 150,
    status: 'Active',
    parentId: '2',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1571175443880-49e1d25b2bc5',
    ),

    // 3. Office & School Supplies
    Category(
    id: '3',
    categoryName: 'Office & School Supplies',
    description: 'Stationery and supplies',
    productCount: 540,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b',
    ),
    Category(
    id: '3-1',
    categoryName: 'Writing Supplies',
    description: 'Pens and pencils',
    productCount: 150,
    status: 'Active',
    parentId: '3',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1455390582262-044cdead277a',
    ),
    Category(
    id: '3-2',
    categoryName: 'Notebooks',
    description: 'Journals and notepads',
    productCount: 130,
    status: 'Active',
    parentId: '3',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1531346878377-a5be20888e57',
    ),
    Category(
    id: '3-3',
    categoryName: 'Office Equipment',
    description: 'Staplers and organizers',
    productCount: 140,
    status: 'Active',
    parentId: '3',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c',
    ),
    Category(
    id: '3-4',
    categoryName: 'School Backpacks',
    description: 'Student bags',
    productCount: 120,
    status: 'Active',
    parentId: '3',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62',
    ),

    // 4. Health & Household
    Category(
    id: '4',
    categoryName: 'Health & Household',
    description: 'Health and cleaning products',
    productCount: 780,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571',
    ),
    Category(
    id: '4-1',
    categoryName: 'Personal Care',
    description: 'Hygiene products',
    productCount: 220,
    status: 'Active',
    parentId: '4',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556228852-80c74e6f93c0',
    ),
    Category(
    id: '4-2',
    categoryName: 'Cleaning Supplies',
    description: 'Detergents and cleaners',
    productCount: 260,
    status: 'Active',
    parentId: '4',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1563453392212-326f5e854473',
    ),
    Category(
    id: '4-3',
    categoryName: 'Health Products',
    description: 'Vitamins and supplements',
    productCount: 180,
    status: 'Active',
    parentId: '4',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1550572017-edd951aa8f72',
    ),
    Category(
    id: '4-4',
    categoryName: 'Household Items',
    description: 'Storage and organizers',
    productCount: 120,
    status: 'Active',
    parentId: '4',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556911220-bff31c812dba',
    ),

    // 5. Pet Supplies
    Category(
    id: '5',
    categoryName: 'Pet Supplies',
    description: 'Products for pets',
    productCount: 450,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1415369629372-26f2fe60c467',
    ),
    Category(
    id: '5-1',
    categoryName: 'Dog Supplies',
    description: 'Food and toys',
    productCount: 180,
    status: 'Active',
    parentId: '5',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1',
    ),
    Category(
    id: '5-2',
    categoryName: 'Cat Supplies',
    description: 'Litter and accessories',
    productCount: 160,
    status: 'Active',
    parentId: '5',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1573865526739-10c1d3a1f0cc',
    ),
    Category(
    id: '5-3',
    categoryName: 'Pet Accessories',
    description: 'Collars and beds',
    productCount: 110,
    status: 'Active',
    parentId: '5',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
    ),

    // 6. Cell Phones & Accessories
    Category(
    id: '6',
    categoryName: 'Cell Phones & Accessories',
    description: 'Phones and accessories',
    productCount: 920,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9',
    ),
    Category(
    id: '6-1',
    categoryName: 'Phone Cases',
    description: 'Protective cases',
    productCount: 350,
    status: 'Active',
    parentId: '6',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1601784551446-20c9e07cdbdb',
    ),
    Category(
    id: '6-2',
    categoryName: 'Chargers & Cables',
    description: 'USB cables',
    productCount: 280,
    status: 'Active',
    parentId: '6',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0',
    ),
    Category(
    id: '6-3',
    categoryName: 'Screen Protectors',
    description: 'Tempered glass',
    productCount: 190,
    status: 'Active',
    parentId: '6',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556656793-08538906a9f8',
    ),
    Category(
    id: '6-4',
    categoryName: 'Phone Holders',
    description: 'Car mounts',
    productCount: 100,
    status: 'Active',
    parentId: '6',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c',
    ),

    // 7. Smart Home
    Category(
    id: '7',
    categoryName: 'Smart Home',
    description: 'Smart devices',
    productCount: 380,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1558002038-1055907df827',
    ),
    Category(
    id: '7-1',
    categoryName: 'Smart Lights',
    description: 'LED bulbs',
    productCount: 140,
    status: 'Active',
    parentId: '7',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1550439062-609e1531270e',
    ),
    Category(
    id: '7-2',
    categoryName: 'Smart Speakers',
    description: 'Voice assistants',
    productCount: 130,
    status: 'Active',
    parentId: '7',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1589492477829-5e65395b66cc',
    ),
    Category(
    id: '7-3',
    categoryName: 'Security Systems',
    description: 'Cameras and sensors',
    productCount: 110,
    status: 'Active',
    parentId: '7',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1557324232-b8917d3c3dcb',
    ),

    // 8. Musical Instruments
    Category(
    id: '8',
    categoryName: 'Musical Instruments',
    description: 'Music equipment',
    productCount: 290,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d',
    ),
    Category(
    id: '8-1',
    categoryName: 'Guitars',
    description: 'Acoustic and electric',
    productCount: 120,
    status: 'Active',
    parentId: '8',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1510915361894-db8b60106cb1',
    ),
    Category(
    id: '8-2',
    categoryName: 'Keyboards',
    description: 'Digital pianos',
    productCount: 90,
    status: 'Active',
    parentId: '8',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
    ),
    Category(
    id: '8-3',
    categoryName: 'Accessories',
    description: 'Strings and picks',
    productCount: 80,
    status: 'Active',
    parentId: '8',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1519892300165-cb5542fb47c7',
    ),

    // 9. Furniture
    Category(
    id: '9',
    categoryName: 'Furniture',
    description: 'Home furniture',
    productCount: 680,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
    ),
    Category(
    id: '9-1',
    categoryName: 'Living Room',
    description: 'Sofas and tables',
    productCount: 220,
    status: 'Active',
    parentId: '9',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1567016432779-094069958ea5',
    ),
    Category(
    id: '9-2',
    categoryName: 'Bedroom',
    description: 'Beds and dressers',
    productCount: 200,
    status: 'Active',
    parentId: '9',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1560448204-603b3fc33ddc',
    ),
    Category(
    id: '9-3',
    categoryName: 'Office Furniture',
    description: 'Desks and chairs',
    productCount: 160,
    status: 'Active',
    parentId: '9',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1524758631624-e2822e304c36',
    ),
    Category(
    id: '9-4',
    categoryName: 'Storage',
    description: 'Shelves and cabinets',
    productCount: 100,
    status: 'Active',
    parentId: '9',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1595428774223-ef52624120d2',
    ),

    // 10. Beachwear
    Category(
    id: '10',
    categoryName: 'Beachwear',
    description: 'Swimwear and beach items',
    productCount: 320,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1519046904884-53103b34b206',
    ),
    Category(
    id: '10-1',
    categoryName: 'Swimsuits',
    description: 'One-piece and bikinis',
    productCount: 150,
    status: 'Active',
    parentId: '10',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1562089365-e9e79a2c8566',
    ),
    Category(
    id: '10-2',
    categoryName: 'Cover-ups',
    description: 'Beach dresses',
    productCount: 100,
    status: 'Active',
    parentId: '10',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1523359346063-d879354c0ea5',
    ),
    Category(
    id: '10-3',
    categoryName: 'Beach Accessories',
    description: 'Towels and bags',
    productCount: 70,
    status: 'Active',
    parentId: '10',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a',
    ),

    // 11. Books & Media
    Category(
    id: '11',
    categoryName: 'Books & Media',
    description: 'Books and media',
    productCount: 540,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
    ),
    Category(
    id: '11-1',
    categoryName: 'Books',
    description: 'Fiction and non-fiction',
    productCount: 280,
    status: 'Active',
    parentId: '11',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1495446815901-a7297e633e8d',
    ),
    Category(
    id: '11-2',
    categoryName: 'Magazines',
    description: 'Periodicals',
    productCount: 130,
    status: 'Active',
    parentId: '11',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1517842645767-c639042777db',
    ),
    Category(
    id: '11-3',
    categoryName: 'Media Storage',
    description: 'Book stands',
    productCount: 130,
    status: 'Active',
    parentId: '11',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f',
    ),

    // 12. Food & Grocery
    Category(
    id: '12',
    categoryName: 'Food & Grocery',
    description: 'Food items',
    productCount: 890,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1543168256-8133cc8e3ee4',
    ),
    Category(
    id: '12-1',
    categoryName: 'Snacks',
    description: 'Chips and cookies',
    productCount: 280,
    status: 'Active',
    parentId: '12',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087',
    ),
    Category(
    id: '12-2',
    categoryName: 'Beverages',
    description: 'Drinks and juices',
    productCount: 240,
    status: 'Active',
    parentId: '12',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1546548970-71785318a17b',
    ),
    Category(
    id: '12-3',
    categoryName: 'Canned Goods',
    description: 'Preserved foods',
    productCount: 200,
    status: 'Active',
    parentId: '12',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1588964895597-cfccd6e2dbf9',
    ),
    Category(
    id: '12-4',
    categoryName: 'Fresh Produce',
    description: 'Fruits and vegetables',
    productCount: 170,
    status: 'Active',
    parentId: '12',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf',
    ),

    // 13. Featured
    Category(
    id: '13',
    categoryName: 'Featured',
    description: 'Featured products',
    productCount: 450,
    status: 'Active',
    parentId: '',
    subcategoryCount: 3,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
    ),
    Category(
    id: '13-1',
    categoryName: 'Best Sellers',
    description: 'Top products',
    productCount: 180,
    status: 'Active',
    parentId: '13',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da',
    ),
    Category(
    id: '13-2',
    categoryName: 'New Arrivals',
    description: 'Latest products',
    productCount: 150,
    status: 'Active',
    parentId: '13',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1555529902-5261145633bf',
    ),
    Category(
    id: '13-3',
    categoryName: 'Deals',
    description: 'Special offers',
    productCount: 120,
    status: 'Active',
    parentId: '13',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1607082349566-187342175e2f',
    ),

    // 14. Home & Kitchen
    Category(
    id: '14',
    categoryName: 'Home & Kitchen',
    description: 'Kitchen and home items',
    productCount: 760,
    status: 'Active',
    parentId: '',
    subcategoryCount: 4,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556911220-bff31c812dba',
    ),
    Category(
    id: '14-1',
    categoryName: 'Cookware',
    description: 'Pots and pans',
    productCount: 220,
    status: 'Active',
    parentId: '14',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136',
    ),
    Category(
    id: '14-2',
    categoryName: 'Dinnerware',
    description: 'Plates and bowls',
    productCount: 190,
    status: 'Active',
    parentId: '14',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1578500494198-246f612d3b3d',
    ),
    Category(
    id: '14-3',
    categoryName: 'Kitchen Gadgets',
    description: 'Utensils and tools',
    productCount: 210,
    status: 'Active',
    parentId: '14',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1556909212-d5b604d0c90d',
    ),
    Category(
    id: '14-4',
    categoryName: 'Home Decor',
    description: 'Decorative items',
    productCount: 140,
    status: 'Active',
    parentId: '14',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1513506003901-1e6a229e2d15',
    ),

    // 15. Women's Clothing
    Category(
    id: '15',
    categoryName: "Women's Clothing",
    description: 'Fashion for women',
    productCount: 1200,
    status: 'Active',
    parentId: '',
    subcategoryCount: 5,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
    ),
    Category(
    id: '15-1',
    categoryName: 'Dresses',
    description: 'Casual and formal',
    productCount: 320,
    status: 'Active',
    parentId: '15',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8',
    ),
    Category(
    id: '15-2',
    categoryName: 'Tops',
    description: 'Blouses and shirts',
    productCount: 280,
    status: 'Active',
    parentId: '15',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1564859228273-274232fdb516',
    ),
    Category(
    id: '15-3',
    categoryName: 'Bottoms',
    description: 'Pants and skirts',
    productCount: 250,
    status: 'Active',
    parentId: '15',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1',
    ),
    Category(
    id: '15-4',
    categoryName: 'Outerwear',
    description: 'Jackets and coats',
    productCount: 200,
    status: 'Active',
    parentId: '15',
    subcategoryCount: 0,
    createdAt: DateTime.now(),
    imageUrl: 'https://images.unsplash.com/photo-1591047139829-d91aecb6caea',
    ),

    ];


  
    setState(() {});
  }

  List<Category> get mainCategories =>
      categories.where((cat) => cat.parentId.isEmpty).toList();

  int get totalProducts =>
      categories.fold(0, (sum, cat) => sum + cat.productCount);

  int get activeCount =>
      mainCategories.where((cat) => cat.status == 'Active').length;

  int get inactiveCount =>
      mainCategories.where((cat) => cat.status == 'Inactive').length;

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
        _imageUrlController.clear();
        _selectedAssetImage = null;
      });
    }
  }

  void _showAssetImagePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image from Assets'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: assetImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAssetImage = assetImages[index];
                    _selectedImagePath = null;
                    _imageUrlController.clear();
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          assetImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image, size: 40);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          assetImages[index].split('/').last,
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCategoryForm({Category? category, Category? parent}) {
    editingCategory = category;
    _editingParentCategory = parent;

    if (category != null) {
      _categoryNameController.text = category.categoryName;
      _descriptionController.text = category.description;
      _productCountController.text = category.productCount.toString();
      _selectedStatus = category.status;
      _imageUrlController.text = category.imageUrl;
      _selectedImagePath = category.imagePath;

      if (category.imagePath != null && category.imagePath!.startsWith('assets/')) {
        _selectedAssetImage = category.imagePath;
        _imageSource = 'system';
      } else if (category.imagePath != null && category.imagePath!.isNotEmpty) {
        _imageSource = 'system';
      } else {
        _imageSource = 'url';
      }
    } else {
      _categoryNameController.clear();
      _descriptionController.clear();
      _productCountController.text = '0';
      _selectedStatus = 'Active';
      _imageUrlController.clear();
      _selectedImagePath = null;
      _selectedAssetImage = null;
      _imageSource = 'url';
    }

    setState(() {
      showCategoryForm = true;
    });
  }

  void _hideCategoryForm() {
    setState(() {
      showCategoryForm = false;
      editingCategory = null;
      _editingParentCategory = null;
    });
  }

  void _showSubcategoryForm(String parentId) {
    setState(() {
      showingSubcategoryForm = parentId;
      expandedCategories.add(parentId);
      _categoryNameController.clear();
      _descriptionController.clear();
      _productCountController.text = '0';
      _selectedStatus = 'Active';
      _imageUrlController.clear();
      _selectedImagePath = null;
      _selectedAssetImage = null;
      _imageSource = 'url';
    });
  }

  void _hideSubcategoryForm() {
    setState(() {
      showingSubcategoryForm = null;
    });
  }

  void _saveCategory() {
    if (!_formKey.currentState!.validate()) return;

    if (editingCategory != null) {
      editingCategory!.categoryName = _categoryNameController.text.trim();
      editingCategory!.description = _descriptionController.text.trim();
      editingCategory!.productCount = int.parse(_productCountController.text);
      editingCategory!.status = _selectedStatus;
      if (_imageSource == 'url') {
        editingCategory!.imageUrl = _imageUrlController.text.trim();
        editingCategory!.imagePath = null;
      } else {
        editingCategory!.imagePath = _selectedAssetImage ?? _selectedImagePath;
        editingCategory!.imageUrl = '';
      }
      _showMessage('Category updated successfully!', true);
    } else {
      final newCategory = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        categoryName: _categoryNameController.text.trim(),
        description: _descriptionController.text.trim(),
        productCount: int.parse(_productCountController.text),
        status: _selectedStatus,
        parentId: _editingParentCategory?.id ?? '',
        subcategoryCount: 0,
        createdAt: DateTime.now(),
        imageUrl: _imageSource == 'url' ? _imageUrlController.text.trim() : '',
        imagePath: _imageSource == 'system' ? (_selectedAssetImage ?? _selectedImagePath) : null,
      );

      categories.add(newCategory);

      if (_editingParentCategory != null) {
        _editingParentCategory!.subcategoryCount += 1;
        expandedCategories.add(_editingParentCategory!.id);
        _showMessage('Subcategory added successfully!', true);
      } else {
        _showMessage('Category added successfully!', true);
      }
    }

    _hideCategoryForm();
    setState(() {});
  }

  void _saveSubcategory(String parentId) {
    if (_categoryNameController.text.trim().isEmpty) {
      _showMessage('Please enter subcategory name', false);
      return;
    }

    final newSubcategory = Category(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryName: _categoryNameController.text.trim(),
      description: _descriptionController.text.trim(),
      productCount: int.parse(_productCountController.text),
      status: _selectedStatus,
      parentId: parentId,
      subcategoryCount: 0,
      createdAt: DateTime.now(),
      imageUrl: _imageSource == 'url' ? _imageUrlController.text.trim() : '',
      imagePath: _imageSource == 'system' ? (_selectedAssetImage ?? _selectedImagePath) : null,
    );

    categories.add(newSubcategory);

    final parent = categories.firstWhere((c) => c.id == parentId);
    parent.subcategoryCount = categories.where((c) => c.parentId == parentId).length;

    _showMessage('Subcategory added successfully!', true);
    _hideSubcategoryForm();
    setState(() {});
  }

  void _deleteCategory(String id) {
    setState(() {
      pendingDelete = id;
    });
  }

  void _confirmDelete(String id) {
    final category = categories.firstWhere((cat) => cat.id == id);

    if (category.parentId.isEmpty) {
      categories.removeWhere((cat) => cat.id == id || cat.parentId == id);
    } else {
      categories.removeWhere((cat) => cat.id == id);
      final parent = categories.firstWhere((c) => c.id == category.parentId);
      parent.subcategoryCount = categories.where((c) => c.parentId == parent.id).length;
    }

    setState(() {
      pendingDelete = null;
    });

    _showMessage('Category deleted successfully!', true);
  }

  void _cancelDelete() {
    setState(() {
      pendingDelete = null;
    });
  }

  void _toggleCategory(String id) {
    setState(() {
      if (expandedCategories.contains(id)) {
        expandedCategories.remove(id);
      } else {
        expandedCategories.add(id);
      }
    });
  }

  void _showMessage(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(24),
      ),
    );
  }

  @override
  void dispose() {
    _taglineController.dispose();
    _categoryNameController.dispose();
    _descriptionController.dispose();
    _productCountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.8, end: 1.0),
                          duration: const Duration(seconds: 2),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/logo1.png',
                                  width: 110,
                                  height: 75,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 5),
                        Center(
                          child: AnimatedOpacity(
                            opacity: _taglineController.value,
                            duration: const Duration(milliseconds: 100),
                            child: const Text(
                              'Shop Smarter, Live Better',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.green),
                  _buildMenuCard(Icons.dashboard, 'Dashboard'),
                  _buildMenuCard(Icons.shopping_bag, 'Orders'),
                  _buildMenuCard(Icons.inventory, 'Products'),
                  _buildMenuCard(Icons.category, 'Categories'),
                  _buildMenuCard(Icons.people, 'Customers'),
                  _buildMenuCard(Icons.payment, 'Payments'),
                  _buildMenuCard(Icons.local_offer, 'Promotions'),
                  _buildMenuCard(Icons.star, 'Reviews'),
                  _buildMenuCard(Icons.analytics, 'Analytics'),
                  _buildMenuCard(Icons.settings, 'Settings'),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category Management',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage your product categories',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return GridView.count(
                        crossAxisCount: constraints.maxWidth > 600 ? 4 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.4,
                        children: [
                          _buildStatCard('📁', mainCategories.length.toString(), 'Total Categories', const Color(0xFFFF6B35)),
                          _buildStatCard('📦', totalProducts.toString(), 'Total Products', const Color(0xFF3B82F6)),
                          _buildStatCard('✅', activeCount.toString(), 'Active', const Color(0xFF10B981)),
                          _buildStatCard('⏸️', inactiveCount.toString(), 'Inactive', const Color(0xFFEF4444)),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFE5E7EB)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'All Categories',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _showCategoryForm(),
                                icon: const Icon(Icons.add, color: Colors.white),
                                label: const Text('Add New Category'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showCategoryForm) _buildCategoryForm(),
                        _buildCategoryTable(),
                      ],
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

  Widget _buildMenuCard(IconData icon, String title) {
    final bool isSelected = selectedMenu == title;

    return InkWell(
      onTap: () {
        setState(() {
          selectedMenu = title;
        });

        if (title == 'Categories') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CategoriesPage(),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.green.withOpacity(0.6),
              blurRadius: 14,
              spreadRadius: 3,
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter $label',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          validator: (value) {
            if (label != 'Image URL' && (value == null || value.isEmpty)) {
              return 'Please enter $label';
            }
            if (keyboardType == TextInputType.number && value != null && value.isNotEmpty && int.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategoryForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: _editingParentCategory != null
                        ? 'Subcategory Name'
                        : 'Category Name',
                    controller: _categoryNameController,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    label: 'Description',
                    controller: _descriptionController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Product Count',
                    controller: _productCountController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                 SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        items: ['Active', 'Inactive']
                            .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Image Source',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('URL'),
                        value: 'url',
                        groupValue: _imageSource,
                        onChanged: (value) {
                          setState(() {
                            _imageSource = value!;
                            _selectedImagePath = null;
                            _selectedAssetImage = null;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('System'),
                        value: 'system',
                        groupValue: _imageSource,
                        onChanged: (value) {
                          setState(() {
                            _imageSource = value!;
                            _imageUrlController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_imageSource == 'url')
              _buildTextField(
                label: 'Image URL',
                controller: _imageUrlController,
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showAssetImagePicker,
                        icon: const Icon(Icons.folder),
                        label: const Text('Assets Folder'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: _pickImageFromGallery,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (_selectedAssetImage != null || _selectedImagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _selectedAssetImage != null
                                  ? Image.asset(
                                _selectedAssetImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image);
                                },
                              )
                                  : Image.file(
                                File(_selectedImagePath!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedAssetImage?.split('/').last ?? _selectedImagePath!.split('/').last,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _hideCategoryForm,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: mainCategories.map((category) {
          final subcategories = categories.where((cat) => cat.parentId == category.id).toList();
          final isExpanded = expandedCategories.contains(category.id);
          final isDeleting = pendingDelete == category.id;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _buildImageWidget(category),
                    const SizedBox(width: 7),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          if (subcategories.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                isExpanded ? Icons.expand_less : Icons.expand_more,
                                size: 20,
                              ),
                              onPressed: () => _toggleCategory(category.id),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          Expanded(
                            child: Text(
                              category.categoryName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      flex: 2,
                      child: Text(
                        category.description,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 60,
                      child: Text(
                        category.productCount.toString(),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    SizedBox(width: 10),
                    _buildStatusBadge(category.status),
                     SizedBox(width: 14),
                    isDeleting
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Confirm?',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _confirmDelete(category.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: const Text('Yes', style: TextStyle(fontSize: 11)),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: _cancelDelete,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green ,
                            side:  BorderSide(color: Colors.green),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                          ),
                          child: const Text('No', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    )

                        :Wrap(
                      spacing: 28,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showCategoryForm(category: category),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3F4F6),
                            foregroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.green,
                            size: 20,
                          ),

                        ),
                        ElevatedButton(
                          onPressed: () => _deleteCategory(category.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child:  Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),

                        ),
                        ElevatedButton(
                          onPressed: () => _showSubcategoryForm(category.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: const Size(0, 0),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.add,
                                color: Colors.white, // White plus icon
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Sub',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white, // Make text white too if needed
                                ),
                              ),
                            ],
                          ),


                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (showingSubcategoryForm == category.id)
                Container(
                  margin: const EdgeInsets.only(left: 30, bottom: 12),
                  child: _buildSubcategoryFormInline(category.id),
                ),
              if (isExpanded)
                ...subcategories.map((sub) {
                  final isSubDeleting = pendingDelete == sub.id;
                  return Container(
                    margin: const EdgeInsets.only(left: 30, bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        _buildImageWidget(sub),
                         SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              const Text('└─ ', style: TextStyle(color: Colors.orange)),
                              Expanded(
                                child: Text(
                                  sub.categoryName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                         SizedBox(width: 48),
                        Expanded(
                          flex: 2,
                          child: Text(
                            sub.description,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                         SizedBox(width: 18),
                        SizedBox(
                          width: 60,
                          child: Text(
                            sub.productCount.toString(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildStatusBadge(sub.status, small: true),
                        const SizedBox(width: 8),
                        Flexible(
                          child: isSubDeleting
                              ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Delete?',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 14),
                              ElevatedButton(
                                onPressed: () => _confirmDelete(sub.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  elevation: 0,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('Yes', style: TextStyle(fontSize: 10)),
                              ),
                               SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: _cancelDelete,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  side: const BorderSide(color: Colors.green),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text('No', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          )

                              : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 30,),
                              ElevatedButton(
                                onPressed: () => _showCategoryForm(category: sub, parent: category),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF3F4F6),
                                  foregroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  minimumSize: const Size(8, 14),
                                  elevation: 0,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 20,
                                ),

                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _deleteCategory(sub.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  minimumSize: const Size(0, 0),
                                  elevation: 0,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child:  Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),

                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageWidget(Category category) {
    Widget imageWidget;

    if (category.imagePath != null && category.imagePath!.startsWith('assets/')) {
      imageWidget = Image.asset(
        category.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 25);
        },
      );
    } else if (category.imagePath != null && category.imagePath!.isNotEmpty) {
      imageWidget = Image.file(
        File(category.imagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 25);
        },
      );
    } else if (category.imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        category.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.broken_image, size: 25);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        },
      );
    } else {
      imageWidget = const Icon(Icons.image, color: Colors.grey, size: 25);
    }

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: imageWidget,
      ),
    );
  }

  Widget _buildStatusBadge(String status, {bool small = false}) {
    final isActive = status == 'Active';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: isActive ? const Color(0xFF059669) : const Color(0xFFDC2626),
          fontSize: small ? 10 : 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSubcategoryFormInline(String parentId) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '➕ Add Subcategory',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Subcategory Name',
                  controller: _categoryNameController,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  label: 'Description',
                  controller: _descriptionController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  label: 'Product Count',
                  controller: _productCountController,
                  keyboardType: TextInputType.number,
                ),
              ),
               SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      items: ['Active', 'Inactive']
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: 'url',
                    groupValue: _imageSource,
                    onChanged: (value) => setState(() {
                      _imageSource = value!;
                      _selectedImagePath = null;
                      _selectedAssetImage = null;
                    }),
                  ),
                  const Text('URL'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'system',
                    groupValue: _imageSource,
                    onChanged: (value) => setState(() {
                      _imageSource = value!;
                      _imageUrlController.clear();
                    }),
                  ),
                  const Text('System'),
                ],
              ),
              if (_imageSource == 'url')
                _buildTextField(
                  label: 'Image URL',
                  controller: _imageUrlController,
                )
              else
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showAssetImagePicker,
                      icon: const Icon(Icons.folder, size: 16),
                      label: const Text('Assets', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library, size: 16),
                      label: const Text('Gallery', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    if (_selectedAssetImage != null || _selectedImagePath != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: _selectedAssetImage != null
                              ? Image.asset(
                            _selectedAssetImage!,
                            fit: BoxFit.cover,
                          )
                              : Image.file(
                            File(_selectedImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _saveSubcategory(parentId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text('Save'),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: _hideSubcategoryForm,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}