import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/inventory_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late String _category;
  late int _quantity;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _category = widget.product?.category ?? '';
    _quantity = widget.product?.quantity ?? 0;
    _imageUrl = widget.product?.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.read<InventoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _name = value!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
                onSaved: (value) => _category = value!.trim(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _quantity.toString(),
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Enter a number';
                  return null;
                },
                onSaved: (value) => _quantity = int.parse(value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _imageUrl,
                decoration:
                const InputDecoration(labelText: 'Image URL (optional)'),
                onSaved: (value) {
                  if (value == null || value.trim().isEmpty) {
                    _imageUrl = null;
                  } else {
                    _imageUrl = value.trim();
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  if (widget.product == null) {
                    final product = Product(
                      id: '',
                      name: _name,
                      quantity: _quantity,
                      category: _category,
                      imageUrl: _imageUrl,
                    );
                    await inventory.addProduct(product);
                  } else {
                    final updated = widget.product!;
                    updated.name = _name;
                    updated.category = _category;
                    updated.quantity = _quantity;
                    updated.imageUrl = _imageUrl;
                    await inventory.updateProduct(updated);
                  }

                  if (mounted) Navigator.of(context).pop();
                },
                child: Text(
                    widget.product == null ? 'Add Product' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
