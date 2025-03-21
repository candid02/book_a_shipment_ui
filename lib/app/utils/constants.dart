class ApiConstants {
  static const String baseUrl = 'https://api.goshippo.com';
  static const String apiKey = 'shippo_test_6bc559810ecb5533a921a193977af9e9ba7342c6'; // Store securely!
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Shippo shippo_test_6bc559810ecb5533a921a193977af9e9ba7342c6',
  };

  static const String fetchCarriersEndpoint = '/carriers/';
  static const String createShipmentEndpoint = '/shipments/';
  static const String createTransactionEndpoint = '/transactions/';
}
