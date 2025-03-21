import 'package:get/get.dart';
import '../controllers/book_shipment_controller.dart';

class BookShipmentBinding extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut<BookShipmentController>(
      () => BookShipmentController(),
    );
  }
}
