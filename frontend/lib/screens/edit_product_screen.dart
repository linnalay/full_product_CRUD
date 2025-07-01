import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../providers/message_util.dart';
import '../providers/product_api_service.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  const EditProductScreen({required this.product, Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _stockCtrl;

  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product.productname);
    _priceCtrl = TextEditingController(text: widget.product.price.toString());
    _stockCtrl = TextEditingController(text: widget.product.stock.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _stockCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.of(context).pop(_changed);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(_changed),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          ),
          title: const Text(
            "Edit Product",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildNameField(),
            const SizedBox(height: 12),
            _buildPriceField(),
            const SizedBox(height: 12),
            _buildStockField(),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameCtrl,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.label),
        border: OutlineInputBorder(),
        hintText: "Product Name",
      ),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Product name is required";
        }
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceCtrl,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.attach_money),
        border: OutlineInputBorder(),
        hintText: "Price",
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Price is required";
        }
        final value = double.tryParse(text);
        if (value == null || value <= 0) {
          return "Enter a valid price";
        }
        return null;
      },
    );
  }

  Widget _buildStockField() {
    return TextFormField(
      controller: _stockCtrl,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.storage),
        border: OutlineInputBorder(),
        hintText: "Stock",
      ),
      keyboardType: TextInputType.number,
      validator: (text) {
        if (text == null || text.trim().isEmpty) {
          return "Stock is required";
        }
        final value = int.tryParse(text);
        if (value == null || value < 0) {
          return "Enter a valid stock quantity";
        }
        return null;
      },
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _onSavePressed,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Text("Save Changes", style: TextStyle(fontSize: 16)),
      ),
    );
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = ProductModel(
        productid: widget.product.productid,
        productname: _nameCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
        stock: int.parse(_stockCtrl.text.trim()),
      );

      ProductApiService().update(updatedProduct).then((success) {
        if (success) {
          showMessage(context, "Updated successfully");
          _changed = true;
        }
      }).onError((error, stack) {
        showMessage(context, "Error: $error");
      });
    }
  }
}
