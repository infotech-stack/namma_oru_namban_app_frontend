// lib/features/booking_details/presentation/widget/booking_details_model_widget.dart

class BookingDetailsModel {
  final String vehicleName;
  final String vehicleImagePath;
  final String pricePerKm;
  final String eta;
  final String capacity;
  final String driverName;
  final double driverRating;

  final String pickupAddress;
  final String dropAddress;
  final String distance;
  final String time;

  final String scheduleDate;
  final String scheduleTime;
  final bool isBookNow;

  // 'km' or 'hour'
  final String selectedRateType;

  final bool addLoadingHelper;
  final bool addUnloadingHelper;
  final bool insuranceCoverage;
  final bool returnTripRequired;
  final String specialInstructions;

  final String baseFare;
  final String distanceFare;
  final String distanceFareLabel;
  final String platformFee;
  final String gst;
  final String totalEstimate;

  final String promoCode;
  final String promoMessage;
  final bool promoApplied;

  final String selectedPayment;

  BookingDetailsModel({
    required this.vehicleName,
    required this.vehicleImagePath,
    required this.pricePerKm,
    required this.eta,
    required this.capacity,
    required this.driverName,
    required this.driverRating,
    required this.pickupAddress,
    required this.dropAddress,
    required this.distance,
    required this.time,
    required this.scheduleDate,
    required this.scheduleTime,
    this.isBookNow = true,
    this.selectedRateType = 'km',
    this.addLoadingHelper = false,
    this.addUnloadingHelper = true,
    this.insuranceCoverage = false,
    this.returnTripRequired = false,
    this.specialInstructions = '',
    required this.baseFare,
    required this.distanceFare,
    required this.distanceFareLabel,
    required this.platformFee,
    required this.gst,
    required this.totalEstimate,
    this.promoCode = '',
    this.promoMessage = '',
    this.promoApplied = false,
    this.selectedPayment = 'UPI',
  });

  BookingDetailsModel copyWith({
    bool? isBookNow,
    String? selectedRateType,
    bool? addLoadingHelper,
    bool? addUnloadingHelper,
    bool? insuranceCoverage,
    bool? returnTripRequired,
    String? specialInstructions,
    String? scheduleDate,
    String? scheduleTime,
    String? promoCode,
    String? promoMessage,
    bool? promoApplied,
    String? selectedPayment,
  }) {
    return BookingDetailsModel(
      vehicleName: vehicleName,
      vehicleImagePath: vehicleImagePath,
      pricePerKm: pricePerKm,
      eta: eta,
      capacity: capacity,
      driverName: driverName,
      driverRating: driverRating,
      pickupAddress: pickupAddress,
      dropAddress: dropAddress,
      distance: distance,
      time: time,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      scheduleTime: scheduleTime ?? this.scheduleTime,
      isBookNow: isBookNow ?? this.isBookNow,
      selectedRateType: selectedRateType ?? this.selectedRateType,
      addLoadingHelper: addLoadingHelper ?? this.addLoadingHelper,
      addUnloadingHelper: addUnloadingHelper ?? this.addUnloadingHelper,
      insuranceCoverage: insuranceCoverage ?? this.insuranceCoverage,
      returnTripRequired: returnTripRequired ?? this.returnTripRequired,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      baseFare: baseFare,
      distanceFare: distanceFare,
      distanceFareLabel: distanceFareLabel,
      platformFee: platformFee,
      gst: gst,
      totalEstimate: totalEstimate,
      promoCode: promoCode ?? this.promoCode,
      promoMessage: promoMessage ?? this.promoMessage,
      promoApplied: promoApplied ?? this.promoApplied,
      selectedPayment: selectedPayment ?? this.selectedPayment,
    );
  }
}
