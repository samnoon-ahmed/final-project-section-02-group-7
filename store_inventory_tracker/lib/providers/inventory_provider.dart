import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';

class InventoryProvider extends ChangeNotifier {
  final _productsCollection = FirebaseFirestore.instance.collection('products');

  List<Product> _products = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';

  InventoryProvider() {
    _listenToProducts();
  }

  List<Product> get allProducts => _products;

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<Product> get filteredProducts {
    return _products.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch =
      p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _listenToProducts() {
    _productsCollection.snapshots().listen((snapshot) {
      _products = snapshot.docs
          .map((doc) => Product.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    await _productsCollection.add(product.toMap());
  }

  Future<void> updateProduct(Product product) async {
    await _productsCollection.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct(String id) async {
    await _productsCollection.doc(id).delete();
  }

  int get totalQuantity =>
      _products.fold(0, (sum, p) => sum + p.quantity);

  int get totalProducts => _products.length;
}
