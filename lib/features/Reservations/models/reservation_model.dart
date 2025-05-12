// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class ReservationModel {
  final String hotelName;
  final String hotelPrice;
  final String hotelId;
  final String imageUrl;
  final String userId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int adults;
  final int children;
  final List<int> childrenAges;
  final int numberOfRooms;
  final String roomType;
  final String roomCategory;
  final String mealPlan;
  final String viewType;
  final String bedType;
  final double totalPrice;
  final String? reservationId;
  final DateTime? reservationDate;
  final String? status;

  ReservationModel({
    required this.hotelName,
    required this.hotelPrice,
    required this.hotelId,
    required this.imageUrl,
    required this.userId,
    this.checkInDate,
    this.checkOutDate,
    required this.adults,
    required this.children,
    required this.childrenAges,
    required this.numberOfRooms,
    required this.roomType,
    required this.roomCategory,
    required this.mealPlan,
    required this.viewType,
    required this.bedType,
    required this.totalPrice,
    this.reservationId,
    this.reservationDate,
    this.status = 'Pending',
  });

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'hotelName': hotelName,
      'hotelPrice': hotelPrice,
      'hotelId': hotelId,
      'imageUrl': imageUrl,
      'userId': userId,
      'checkInDate': checkInDate != null ? DateFormat('yyyy-MM-dd').format(checkInDate!) : null,
      'checkOutDate': checkOutDate != null ? DateFormat('yyyy-MM-dd').format(checkOutDate!) : null,
      'adults': adults,
      'children': children,
      'childrenAges': childrenAges,
      'numberOfRooms': numberOfRooms,
      'roomType': roomType,
      'roomCategory': roomCategory,
      'mealPlan': mealPlan,
      'viewType': viewType,
      'bedType': bedType,
      'totalPrice': totalPrice,
      'reservationId': reservationId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'reservationDate': reservationDate != null ? DateFormat('yyyy-MM-dd').format(reservationDate!) : DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'status': status,
    };
  }

  // Create from Map for database retrieval
  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      hotelName: map['hotelName'] ?? '',
      hotelPrice: map['hotelPrice'] ?? '',
      hotelId: map['hotelId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      userId: map['userId'] ?? '',
      checkInDate: map['checkInDate'] != null ? DateFormat('yyyy-MM-dd').parse(map['checkInDate']) : null,
      checkOutDate: map['checkOutDate'] != null ? DateFormat('yyyy-MM-dd').parse(map['checkOutDate']) : null,
      adults: map['adults'] ?? 1,
      children: map['children'] ?? 0,
      childrenAges: List<int>.from(map['childrenAges'] ?? []),
      numberOfRooms: map['numberOfRooms'] ?? 1,
      roomType: map['roomType'] ?? 'Single',
      roomCategory: map['roomCategory'] ?? 'Standard',
      mealPlan: map['mealPlan'] ?? 'Breakfast Only',
      viewType: map['viewType'] ?? 'Normal View',
      bedType: map['bedType'] ?? 'Twin Beds',
      totalPrice: map['totalPrice'] ?? 0.0,
      reservationId: map['reservationId'],
      reservationDate: map['reservationDate'] != null ? DateFormat('yyyy-MM-dd').parse(map['reservationDate']) : null,
      status: map['status'] ?? 'Pending',
    );
  }

  ReservationModel copyWith({
    String? hotelName,
    String? hotelPrice,
    String? hotelId,
    String? imageUrl,
    String? userId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? adults,
    int? children,
    List<int>? childrenAges,
    int? numberOfRooms,
    String? roomType,
    String? roomCategory,
    String? mealPlan,
    String? viewType,
    String? bedType,
    double? totalPrice,
    String? reservationId,
    DateTime? reservationDate,
    String? status,
  }) {
    return ReservationModel(
      hotelName: hotelName ?? this.hotelName,
      hotelPrice: hotelPrice ?? this.hotelPrice,
      hotelId: hotelId ?? this.hotelId,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      adults: adults ?? this.adults,
      children: children ?? this.children,
      childrenAges: childrenAges ?? this.childrenAges,
      numberOfRooms: numberOfRooms ?? this.numberOfRooms,
      roomType: roomType ?? this.roomType,
      roomCategory: roomCategory ?? this.roomCategory,
      mealPlan: mealPlan ?? this.mealPlan,
      viewType: viewType ?? this.viewType,
      bedType: bedType ?? this.bedType,
      totalPrice: totalPrice ?? this.totalPrice,
      reservationId: reservationId ?? this.reservationId,
      reservationDate: reservationDate ?? this.reservationDate,
      status: status ?? this.status,
    );
  }
}
