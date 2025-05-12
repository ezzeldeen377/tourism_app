import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:new_flutter/features/Componants/custom_button.dart';
import 'package:new_flutter/features/Data/hotels/payment_screen.dart';
import 'package:new_flutter/features/Reservations/models/reservation_model.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> reservationData;

  const BookingScreen({Key? key, required this.reservationData})
      : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Date selection
  DateTime? checkInDate;
  DateTime? checkOutDate;

  // Base price extracted from string
  double basePrice = 0.0;

  // Guest information
  int adults = 1;
  int children = 0;
  List<int> childrenAges = [];

  // Room information
  int numberOfRooms = 1;
  String roomType = 'Single';
  String roomCategory = 'Standard';
  String mealPlan = 'Breakfast Only';
  String viewType = 'Normal View';
  String bedType = 'Twin Beds';

  // Price calculation
  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    // Extract base price from the string format
    extractBasePrice();
    calculateTotalPrice();
  }

  void extractBasePrice() {
    // Get the price string from reservation data
    String priceString = widget.reservationData['hotel_price'] as String;

    // Extract the first price using RegExp
    RegExp regExp = RegExp(r'(\d{1,3}(,\d{3})+)');
    Match? match = regExp.firstMatch(priceString);

    if (match != null && match.group(1) != null) {
      // Remove commas and convert to double
      String priceWithoutCommas = match.group(1)!.replaceAll(',', '');
      setState(() {
        basePrice = double.parse(priceWithoutCommas);
        print(basePrice);
      });
    } else {
      // Fallback to a default price if extraction fails
      setState(() {
        basePrice = 1000.0; // Default price
      });
    }
  }

  void calculateTotalPrice() {
    double price = basePrice;

    // Calculate number of nights
    int nights = 1;
    if (checkInDate != null && checkOutDate != null) {
      nights = checkOutDate!.difference(checkInDate!).inDays;
      if (nights < 1) nights = 1;
    }

    // Room type percentage additions
    Map<String, double> roomTypePercentages = {
      'Single': 0.0,
      'Double': 5.0, // 15% increase
      'Triple': 10.0, // 30% increase
    };

    // Room category percentage additions
    Map<String, double> roomCategoryPercentages = {
      'Standard': 0.0,
      'Duplex': 15.0, // 50% increase
      'Half Duplex': 10.0, // 30% increase
      'Suite': 30.0, // 100% increase
    };

    // Meal plan percentage additions
    Map<String, double> mealPlanPercentages = {
      'Breakfast Only': 0.0,
      'Breakfast and Dinner': 10.0, // 30% increase
      'Breakfast and Lunch': 10.0, // 30% increase
      'Lunch and Dinner': 10.0, // 30% increase
      'Lunch Only': 5.0, // 10% increase
      'Dinner Only': 5.0, // 10% increase
      'Full Board': 15.0, // 50% increase
    };

    // View type percentage additions
    Map<String, double> viewTypePercentages = {
      'Normal View': 0.0,
      'Garden View': 3.0, // 10% increase
      'Pool View': 5.0, // 20% increase
      'Mountain View': 8.0, // 30% increase
      'Sea View': 10.0, // 50% increase
    };

    // Bed type percentage additions
    Map<String, double> bedTypePercentages = {
      'Twin Beds': 0.0,
      'Queen Bed': 1.0, // 10% increase
      'King Bed': 3.0, // 20% increase
      'Sofa Bed': -2.0, // 10% discount
    };

    // Apply percentage additions
    price += basePrice * (roomTypePercentages[roomType] ?? 0.0) / 100;
    price += basePrice * (roomCategoryPercentages[roomCategory] ?? 0.0) / 100;
    price += basePrice * (mealPlanPercentages[mealPlan] ?? 0.0) / 100;
    price += basePrice * (viewTypePercentages[viewType] ?? 0.0) / 100;
    price += basePrice * (bedTypePercentages[bedType] ?? 0.0) / 100;

    // Additional charges for guests (as percentage of base price)
    price += (adults > 2
        ? (adults - 2) * basePrice * 0.20
        : 0); // 20% per additional adult
    price += (children * basePrice * 0.10); // 10% per child

    // Multiply by number of rooms and nights
    double totalForOneNight = price;
    price *= numberOfRooms;
    price *= nights;

    setState(() {
      totalPrice = price;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? (checkInDate ?? DateTime.now())
          : (checkOutDate ??
              (checkInDate?.add(const Duration(days: 1)) ??
                  DateTime.now().add(const Duration(days: 1)))),
      firstDate: isCheckIn ? DateTime.now() : (checkInDate ?? DateTime.now()),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kMainColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          // If check-out date is before check-in date, update it
          if (checkOutDate != null && checkOutDate!.isBefore(checkInDate!)) {
            checkOutDate = checkInDate!.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
        calculateTotalPrice();
      });
    }
  }

  void _updateChildrenAges() {
    if (childrenAges.length < children) {
      // Add ages for new children
      while (childrenAges.length < children) {
        childrenAges.add(0);
      }
    } else if (childrenAges.length > children) {
      // Remove ages for removed children
      childrenAges = childrenAges.sublist(0, children);
    }
    calculateTotalPrice();
  }

  Widget _buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: kMainColor),
                  elevation: 2,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    onChanged(newValue);
                    calculateTotalPrice();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter({
    required String title,
    required int value,
    required Function() onIncrement,
    required Function() onDecrement,
    int min = 0,
    int max = 10,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: value > min ? onDecrement : null,
                color: kMainColor,
              ),
              Text(
                value.toString(),
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: value < max ? onIncrement : null,
                color: kMainColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String title,
    required DateTime? date,
    required Function() onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onSelect,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date != null
                        ? DateFormat('MMM dd, yyyy').format(date)
                        : 'Select Date',
                    style: TextStyle(
                      color: date != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  const Icon(Icons.calendar_today, color: kMainColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.reservationData['hotel_name']}'),
        backgroundColor: Colors.grey[200],
        centerTitle: true,
        iconTheme: const IconThemeData(color: kMainColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dates Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(
                          title: 'Check-in',
                          date: checkInDate,
                          onSelect: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateSelector(
                          title: 'Check-out',
                          date: checkOutDate,
                          onSelect: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Guests Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCounter(
                    title: 'Adults',
                    value: adults,
                    min: 1,
                    onIncrement: () {
                      setState(() {
                        adults++;
                        calculateTotalPrice();
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        adults--;
                        calculateTotalPrice();
                      });
                    },
                  ),
                  _buildCounter(
                    title: 'Children',
                    value: children,
                    onIncrement: () {
                      setState(() {
                        children++;
                        _updateChildrenAges();
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        children--;
                        _updateChildrenAges();
                      });
                    },
                  ),

                  // Children ages
                  if (children > 0) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Children Ages',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        children,
                        (index) => Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            value: childrenAges[index],
                            isExpanded: true,
                            underline: Container(),
                            items: List.generate(18, (i) => i).map((int age) {
                              return DropdownMenuItem<int>(
                                value: age,
                                child: Text('$age'),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                childrenAges[index] = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Room Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCounter(
                    title: 'Number of Rooms',
                    value: numberOfRooms,
                    min: 1,
                    onIncrement: () {
                      setState(() {
                        numberOfRooms++;
                        calculateTotalPrice();
                      });
                    },
                    onDecrement: () {
                      setState(() {
                        numberOfRooms--;
                        calculateTotalPrice();
                      });
                    },
                  ),
                  _buildDropdown(
                    title: 'Room Type',
                    value: roomType,
                    items: const ['Single', 'Double', 'Triple'],
                    onChanged: (newValue) {
                      setState(() {
                        roomType = newValue!;
                      });
                    },
                  ),
                  _buildDropdown(
                    title: 'Room Category',
                    value: roomCategory,
                    items: const ['Standard', 'Duplex', 'Half Duplex', 'Suite'],
                    onChanged: (newValue) {
                      setState(() {
                        roomCategory = newValue!;
                      });
                    },
                  ),
                  _buildDropdown(
                    title: 'Meal Plan',
                    value: mealPlan,
                    items: const [
                      'Breakfast Only',
                      'Breakfast and Dinner',
                      'Breakfast and Lunch',
                      'Lunch and Dinner',
                      'Lunch Only',
                      'Dinner Only',
                      'Full Board'
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        mealPlan = newValue!;
                      });
                    },
                  ),
                  _buildDropdown(
                    title: 'View Type',
                    value: viewType,
                    items: const [
                      'Pool View',
                      'Sea View',
                      'Mountain View',
                      'Garden View',
                      'Normal View'
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        viewType = newValue!;
                      });
                    },
                  ),
                  _buildDropdown(
                    title: 'Bed Type',
                    value: bedType,
                    items: const [
                      'King Bed',
                      'Queen Bed',
                      'Twin Beds',
                      'Sofa Bed'
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        bedType = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Price Summary Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${totalPrice.toStringAsFixed(0)} EGP',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kMainColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (checkInDate != null && checkOutDate != null)
                    Text(
                      'for ${checkOutDate!.difference(checkInDate!).inDays} night(s)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
            Center(
              child: CustomButton(
                text: 'Confirm Booking',
                onPressed: () {
                  // Create reservation object
                  if (checkOutDate != null && checkInDate != null) {
                    ReservationModel reservation = createReservation();

                    // Navigate to payment screen with reservation data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaymentScreen(reservation: reservation),
                      ),
                    );
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select check-in and check-out dates'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to create reservation object
  ReservationModel createReservation() {
    return ReservationModel(
      userId: FirebaseAuth.instance.currentUser!.uid,
      hotelName: widget.reservationData['hotel_name'] ?? '',
      hotelPrice: widget.reservationData['hotel_price'] ?? '',
      hotelId: widget.reservationData['hotel_id'] ?? '',
      imageUrl:
          (widget.reservationData['images'] as List<dynamic>).firstOrNull ?? '',
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      adults: adults,
      children: children,
      childrenAges: childrenAges,
      numberOfRooms: numberOfRooms,
      roomType: roomType,
      roomCategory: roomCategory,
      mealPlan: mealPlan,
      viewType: viewType,
      bedType: bedType,
      totalPrice: totalPrice,
      reservationDate: DateTime.now(),
      status: 'Confirmed',
    );
  }
}
