// ignore_for_file: unnecessary_this

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shipping_app/services/api_service.dart';

class BookShipmentController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Controllers for user input
  final pickupAddressController = TextEditingController();
  final deliveryAddressController = TextEditingController();

  // Selected courier
  final selectedCourier = 'Delhivery'.obs;

  // Pricing parameters
  final price = 0.0.obs;
  final distance = 50.0.obs; // Default distance in km
  final pricePerKm = 5.0.obs;
  final packagingCost = 20.0.obs;

  // Loading and state management
  final isLoading = false.obs;
  final isRealTimeData = false.obs;
  var lastApiCallTime = DateTime.now();
  final List<String> carrierAccountIds = []; // Store carrier account IDs

  // Courier list
  final couriers = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    calculatePrice(); // Initialize with local calculation
    fetchCouriers(); // Fetch from API
  }

  Future<void> fetchCouriers() async {
    try {
      isLoading.value = true;
      final courierData = await _apiService.fetchCouriers();

      if (courierData.isNotEmpty) {
        couriers.assignAll(courierData.map((c) => c['name'].toString()).toList());

        if (!couriers.contains(selectedCourier.value) && couriers.isNotEmpty) {
          selectedCourier.value = couriers.first;
        }
        await fetchShippingRate();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load couriers: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100);
      calculatePrice();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchShippingRate() async {
    if (DateTime.now().difference(lastApiCallTime).inMilliseconds < 300) return;
    lastApiCallTime = DateTime.now();

    if (pickupAddressController.text.isEmpty || deliveryAddressController.text.isEmpty) {
      isRealTimeData.value = false;
      calculatePrice();
      return;
    }

    try {
      isLoading.value = true;
      final result = await _apiService.calculateShippingRate(
        pickupAddress: pickupAddressController.text,
        deliveryAddress: deliveryAddressController.text,
        distance: distance.value,
        courierName: selectedCourier.value,
        carrierAccountIds: carrierAccountIds,
      );

      if (result.containsKey('total_price')) {
        packagingCost.value = double.parse(result['packaging_cost'].toString());
        pricePerKm.value = double.parse(result['price_per_km'].toString());
        price.value = double.parse(result['total_price'].toString());
        isRealTimeData.value = true;
      } else {
        fallbackToLocalCalculation();
      }
    } catch (e) {
      fallbackToLocalCalculation();
      Get.snackbar('Notice', 'Using local calculation. API error: $e',
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2));
    } finally {
      isLoading.value = false;
    }
  }

  void calculatePrice() {
    const basePrices = {
      'Delhivery': 100.0,
      'DTDC': 80.0,
      'Bluedart': 130.0,
      'FedEx': 180.0,
      'Ecom Express': 90.0,
    };

    const pricePerKmRates = {
      'Delhivery': 5.0,
      'DTDC': 4.5,
      'Bluedart': 6.0,
      'FedEx': 7.0,
      'Ecom Express': 4.75,
    };

    pricePerKm.value = pricePerKmRates[selectedCourier.value] ?? 5.0;
    double basePrice = basePrices[selectedCourier.value] ?? 80.0;
    double distanceCost = distance.value * pricePerKm.value;
    packagingCost.value = 20.0;
    price.value = basePrice + distanceCost + packagingCost.value;
  }

  void fallbackToLocalCalculation() {
    isRealTimeData.value = false;
    calculatePrice();
  }

  double get distanceCost => distance.value * pricePerKm.value;
  double get basePrice => price.value - packagingCost.value - distanceCost;

  void onAddressChanged() {
    if (pickupAddressController.text.isNotEmpty && deliveryAddressController.text.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500), () => fetchShippingRate());
    } else {
      fallbackToLocalCalculation();
    }
  }

  void updateDistance(double newDistance) {
    distance.value = newDistance;
    isRealTimeData.value ? fetchShippingRate() : calculatePrice();
  }

  void updateCourier(String? newValue) {
    if (newValue != null) {
      selectedCourier.value = newValue;
      isRealTimeData.value ? fetchShippingRate() : calculatePrice();
    }
  }

  Future<void> processPayment() async {
    isLoading.value = true;
    try {
      final result = await _apiService.saveShipment(
        pickupAddress: pickupAddressController.text,
        deliveryAddress: deliveryAddressController.text,
        distance: distance.value,
        courierName: selectedCourier.value,
        totalPrice: price.value,
        carrierAccountIds: carrierAccountIds,
      );

      Get.snackbar('Success', 'Shipment booked with ID: ${result['id']}',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green.shade100, duration: const Duration(seconds: 3));
    } catch (e) {
      Get.snackbar('Error', 'Failed to process payment: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red.shade100);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    pickupAddressController.dispose();
    deliveryAddressController.dispose();
    super.onClose();
  }
}
