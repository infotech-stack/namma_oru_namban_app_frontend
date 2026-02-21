import 'package:get/get.dart';
import 'package:userapp/features/booking/presentation/widget/booking_model_widget.dart';

class MyBookingController extends GetxController {
  final booking = Rx<BookingModel>(
    BookingModel(
      bookingId: '#BK20260217',
      vehicleName: 'Container Truck',
      driverName: 'Sudarsan',
      vehicleNumber: 'TN 22 AB 4589',
      pickup: 'Phase 2, Anna Nagar,\nChennai – 600040',
      drop: 'Ambattur Industrial Estate,\nChennai – 600058',
      date: '17 Feb',
      time: '2:30 PM',
      eta: '15 mins',
      paymentMethod: 'Cash Payment',
      paymentNote: 'Pay on Arrival',
      totalAmount: '₹4,250',
    ),
  );

  void onCallDriver() {
    // TODO: launch phone call
  }
}
