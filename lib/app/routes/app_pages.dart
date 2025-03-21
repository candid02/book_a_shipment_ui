import 'package:get/get.dart';
import '../modules/book_shipment/bindings/book_shipment_binding.dart';
import '../modules/book_shipment/views/book_shipment_screen.dart';


class AppPages {
  AppPages._();

  static const initial = Routes.bookShipment;

  static final routes = [
    //GetPage(
      //name: Routes.home,
      //page: () => const HomeView(),
      //binding: HomeBinding(),
    //),
    GetPage(
      name: Routes.bookShipment,
      page: () => const BookShipmentScreen(),
      binding: BookShipmentBinding(),
    ),
  ];
}

abstract class Routes {
  Routes._();
  static const home = '/home';
  static const bookShipment = '/book-shipment';
}