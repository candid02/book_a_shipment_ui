import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_shipment_controller.dart';

class BookShipmentScreen extends StatelessWidget {
  const BookShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BookShipmentController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book a Shipment',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Color.fromARGB(255, 1, 39, 3),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() => controller.isLoading.value
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.deepOrange),
                SizedBox(height: 16),
                Text('Loading shipping rates...', style: TextStyle(color: Colors.indigo)),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Shipment Icon
                    const Center(
                      child: Image(
                        image: AssetImage('assets/images/shipping_icon.png'),
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Pickup Address
                    const Text(
                      'Pickup Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: controller.pickupAddressController,
                      decoration: InputDecoration(
                        hintText: 'Enter pickup address',
                        prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.deepOrange, size: 24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orange.shade200),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pickup address';
                        }
                        return null;
                      },
                      onChanged: (value) => controller.onAddressChanged(),
                    ),
                    const SizedBox(height: 12),
                    
                    // Delivery Address
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: controller.deliveryAddressController,
                      decoration: InputDecoration(
                        hintText: 'Enter delivery address',
                        prefixIcon: const Icon(Icons.home_outlined, color: Colors.deepOrange, size: 24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orange.shade200),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter delivery address';
                        }
                        return null;
                      },
                      onChanged: (value) => controller.onAddressChanged(),
                    ),
                    const SizedBox(height: 12),
                    
                    // Courier Selection
                    const Text(
                      'Select Courier',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: controller.selectedCourier.value,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: [
                            'Select Courier',
                            'Delhivery',
                            'DTDC',
                            'Bluedart',
                            'Ecom Express',
                          ].map((String courier) {
                            return DropdownMenuItem<String>(
                              value: courier,
                              child: Row(
                                children: [
                                  const Icon(Icons.local_shipping, size: 20, color: Colors.deepOrange),
                                  const SizedBox(width: 12),
                                  Text(
                                    courier,
                                    style: const TextStyle(color: Colors.indigo),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: controller.updateCourier,
                        ),
                      ),
                    )),
                    const SizedBox(height: 12),
                    
                    // Total Distance
                    const Text(
                      'Total Distance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.indigo),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.route, color: Colors.deepOrange, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${controller.distance.value.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Slider(
                            value: controller.distance.value,
                            min: 1.0,
                            max: 100.0,
                            divisions: 99,
                            activeColor: Colors.deepOrange,
                            inactiveColor: Colors.orange.shade100,
                            onChanged: controller.updateDistance,
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                    
                    // Price Card
                    Obx(() => Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Price Breakdown',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.green),
                                    SizedBox(width: 4),
                                    Text(
                                      'Real-time',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                '₹${controller.price.value.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 16),
                    
                    // Payment Button
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controller.processPayment();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Payment',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}