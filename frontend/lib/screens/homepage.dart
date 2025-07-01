import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'add_product_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Product Management',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.indigo.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    context,
                    icon: Icons.list_alt_rounded,
                    label: 'View Products',
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListScreen(mode: 'view'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    context,
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Add Product',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    context,
                    icon: Icons.edit_note_rounded,
                    label: 'Update Product',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductListScreen(mode: 'edit'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    context,
                    icon: Icons.delete_forever_outlined,
                    label: 'Delete Product',
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProductListScreen(mode: 'delete'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 26),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(60),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onTap,
    );
  }
}
