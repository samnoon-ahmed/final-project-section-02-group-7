import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/inventory_provider.dart';
import '../screens/add_edit_product_screen.dart';

class ProductItemTile extends StatelessWidget {
  final Product product;

  const ProductItemTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final inventory = context.read<InventoryProvider>();
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Category: ${product.category}'),
                    Text('Quantity: ${product.quantity}'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.edit_rounded),
                            label: const Text('Edit'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddEditProductScreen(
                                    product: product,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.delete_rounded),
                            label: const Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              await inventory.deleteProduct(product.id);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            foregroundColor: theme.colorScheme.primary,
            child: Text(
              product.quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          title: Text(
            product.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Text(
            product.category,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }
}
