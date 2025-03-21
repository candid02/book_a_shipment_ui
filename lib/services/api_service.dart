import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService extends GetxService {
  final String shippoBaseUrl = 'https://api.goshippo.com/v1';
  final String shippoApiKey = 'shippo_test_c8d2d054f00966b82f4e9582bfde867b546944d9';

  // Corrected Authentication Header
  Map<String, String> get headers => {
    'Authorization': 'Shippo $shippoApiKey',
    'Content-Type': 'application/json',
  };

  // Fetch available shipping carriers
  Future<List<dynamic>> fetchCouriers() async {
    try {
      print("Fetching Couriers... Headers: \$headers");

      final response = await http.get(
        Uri.parse('$shippoBaseUrl/carrier_accounts'),
        headers: headers,
      );

      print("Fetch Couriers Response: \${response.statusCode} - \${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      } else {
        throw Exception('Failed to load couriers: \${response.body}');
      }
    } catch (e) {
      print("Error in fetchCouriers: \$e");
      throw Exception('Network error: \$e');
    }
  }

  // Calculate shipping rate
  Future<Map<String, dynamic>> calculateShippingRate({
    required String pickupAddress,
    required String deliveryAddress,
    required List<String> carrierAccountIds,
    required double distance,
    required String courierName,
  }) async {
    try {
      final body = {
        "address_from": {"street1": pickupAddress, "country": "IN"},
        "address_to": {"street1": deliveryAddress, "country": "IN"},
        "parcels": [
          {
            "length": "10",
            "width": "10",
            "height": "10",
            "distance_unit": "cm",
            "weight": "2",
            "mass_unit": "kg"
          }
        ],
        "carrier_accounts": carrierAccountIds,
        "extra": {
          "distance": distance.toString(),
          "courier_name": courierName,
        }
      };

      print("Calculate Shipping Rate Request: \$body");

      final response = await http.post(
        Uri.parse('$shippoBaseUrl/rates/'),
        headers: headers,
        body: json.encode(body),
      );

      print("Calculate Shipping Rate Response: \${response.statusCode} - \${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to calculate rate: \${response.body}');
      }
    } catch (e) {
      print("Error in calculateShippingRate: \$e");
      throw Exception('Network error: \$e');
    }
  }

  // Create a shipment using Shippo API
  Future<Map<String, dynamic>> saveShipment({
    required String pickupAddress,
    required String deliveryAddress,
    required List<String> carrierAccountIds,
    required double totalPrice,
    required double distance,
    required String courierName,
  }) async {
    try {
      final body = {
        "address_from": {"street1": pickupAddress, "country": "IN"},
        "address_to": {"street1": deliveryAddress, "country": "IN"},
        "parcels": [
          {
            "length": "10",
            "width": "10",
            "height": "10",
            "distance_unit": "cm",
            "weight": "2",
            "mass_unit": "kg"
          }
        ],
        "carrier_accounts": carrierAccountIds,
        "extra": {
          "total_price": totalPrice.toString(),
          "distance": distance.toString(),
          "courier_name": courierName,
        },
      };

      print("Save Shipment Request: \$body");

      final response = await http.post(
        Uri.parse('$shippoBaseUrl/transactions/'),
        headers: headers,
        body: json.encode(body),
      );

      print("Save Shipment Response: \${response.statusCode} - \${response.body}");

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to save shipment: \${response.body}');
      }
    } catch (e) {
      print("Error in saveShipment: \$e");
      throw Exception('Network error: \$e');
    }
  }
}