import 'package:flutter/material.dart';
import '../services/api_service.dart';

// Manages stateful basket page
class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  // Set API service and loading parameters
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  bool _isCheckingOut = false;

  @override
  void initState() {
    super.initState();
    _loadBasket();
  }

  // Get tickets from API
  Future<void> _loadBasket() async {
    final data = await _apiService.getBasket();
    setState(() {
      _items = data;
      _isLoading = false;
    });
  }

  // Remove tickets from basket
  Future<void> _removeItem(int basketId) async {
    final success = await _apiService.removeFromBasket(basketId);
    if (success) {
      _loadBasket();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to remove ticket from basket')),
      );
    }
  }

  // Handle basket checkout process
  Future<void> _handleCheckout() async {
    setState(() => _isCheckingOut = true);
    final success = await _apiService.checkoutBasket(_items);
    setState(() => _isCheckingOut = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Checkout initiated, complete in browser.')),
      );
      await _loadBasket();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Checkout failed')),
      );
    }
  }

  // Build basket page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Basket')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? const Center(child: Text('🧺 Your basket is empty.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text('🎟️ Seat: ${item['seat']}'),
                    subtitle: Text(
                      '📅 Added: ${item['created_at'] ?? 'Unknown'}\n📍 Event ID: ${item['event_id']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _removeItem(item['basket_id'] as int),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 10),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Seats: ${_items.length}',
                  style: const TextStyle(fontSize: 18),
                ),
                ElevatedButton(
                  onPressed: _items.isEmpty || _isCheckingOut
                      ? null
                      : _handleCheckout,
                  child: _isCheckingOut
                      ? const CircularProgressIndicator()
                      : const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}