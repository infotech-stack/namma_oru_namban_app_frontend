class BookingModel {
  final String bookingId;
  final String vehicleName;
  final String driverName;
  final String vehicleNumber;
  final String pickup;
  final String drop;
  final String date;
  final String time;
  final String eta;
  final String paymentMethod;
  final String paymentNote;
  final String totalAmount;
  final String? imagePath;

  BookingModel({
    required this.bookingId,
    required this.vehicleName,
    required this.driverName,
    required this.vehicleNumber,
    required this.pickup,
    required this.drop,
    required this.date,
    required this.time,
    required this.eta,
    required this.paymentMethod,
    required this.paymentNote,
    required this.totalAmount,
    this.imagePath,
  });
}
