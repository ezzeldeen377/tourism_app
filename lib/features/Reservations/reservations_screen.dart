import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:new_flutter/features/Reservations/models/reservation_model.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({Key? key}) : super(key: key);

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  bool isLoading = true;
  List<ReservationModel> reservations = [];

  @override
  void initState() {
    super.initState();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Get reference to Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      
      // Get all reservations for current user
      final QuerySnapshot querySnapshot = await firestore
          .collection('reservations')
          .where('userId', isEqualTo: userId)
          .get();

      // Process each reservation
      final List<ReservationModel> fetchedReservations = [];
      final List<Future<void>> updateTasks = [];

      for (var doc in querySnapshot.docs) {
        var reservation = ReservationModel.fromMap( doc.data() as Map<String, dynamic>);
        
        // Convert Firestore data to ReservationModel
      
        // Check if reservation is completed but status not updated
        if (reservation.checkOutDate!.isBefore(DateTime.now()) && 
            reservation.status != 'Completed') {
          // Update status in Firestore
          updateTasks.add(
            firestore
                .collection('reservations')
                .doc(doc.id)
                .update({'status': 'Completed'})
          );
          
          // Update status in local data
          reservation=reservation.copyWith(status: 'Completed');
        }

        fetchedReservations.add(reservation);
      }

      // Wait for all updates to complete
      await Future.wait(updateTasks);

      setState(() {
        reservations = fetchedReservations;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching reservations: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Reservations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kMainColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: kMainColor),
      ),
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: kMainColor,
              ),
            )
          : reservations.isEmpty
              ? _buildEmptyState()
              : _buildReservationsList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hotel_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Reservations Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your first hotel to see reservations here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ActionButton(
            text: 'Explore Hotels',
            color: kMainColor,
            width: 200,
            onTap: () {
              Navigator.pop(context);
            },
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildReservationsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Upcoming reservations section
        _buildSectionHeader('Upcoming Reservations', Icons.upcoming),
        const SizedBox(height: 12),
        ...reservations
            .where((res) => res.checkOutDate!.isAfter(DateTime.now()) && res.status != 'Completed')
            .map((res) => _buildReservationCard(res))
            .toList(),
        
        const SizedBox(height: 24),
        
        // Past reservations section
        _buildSectionHeader('Past Reservations', Icons.history),
        const SizedBox(height: 12),
        ...reservations
            .where((res) => res.checkOutDate!.isBefore(DateTime.now()) || res.status == 'Completed')
            .map((res) => _buildReservationCard(res))
            .toList(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: kMainColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildReservationCard(ReservationModel reservation) {
    final checkInDate = DateFormat('MMM dd, yyyy').format(reservation.checkInDate!);
    final checkOutDate = DateFormat('MMM dd, yyyy').format(reservation.checkOutDate!);
    
    Color statusColor;
    IconData statusIcon;
    
    switch (reservation.status) {
      case 'Confirmed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case 'Completed':
        statusColor = Colors.blue;
        statusIcon = Icons.done_all;
        break;
      case 'Cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hotel image and status banner
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: reservation.imageUrl.isNotEmpty
                    ? Image.network(
                        reservation.imageUrl,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 120,
                          width: double.infinity,
                          color: kMainColor.withOpacity(0.2),
                          child: Icon(
                            Icons.hotel,
                            size: 60,
                            color: kMainColor.withOpacity(0.5),
                          ),
                        ),
                      )
                    : Container(
                        height: 120,
                        width: double.infinity,
                        color: kMainColor.withOpacity(0.2),
                        child: Icon(
                          Icons.hotel,
                          size: 60,
                          color: kMainColor.withOpacity(0.5),
                        ),
                      ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        reservation.status??'',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Reservation details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        reservation.hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${reservation.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kMainColor,
                      ),
                    ),
                  ],
                ),
              
                const SizedBox(height: 16),
                
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
                const SizedBox(height: 16),
                
                // Stay details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        'Check-In',
                        checkInDate,
                        Icons.login,
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 1,
                      color: Colors.grey[200],
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        'Check-Out',
                        checkOutDate,
                        Icons.logout,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Show reservation details in bottom sheet
                          _showReservationDetails(context, reservation);
                        },
                        icon: const Icon(Icons.visibility, size: 18),
                        label: const Text('View Details'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kMainColor,
                          side: const BorderSide(color: kMainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: reservation.status == 'Completed' || reservation.status == 'Cancelled'
                            ? null
                            : () {
                                _cancelReservation(reservation.reservationId!);
                              },
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: kMainColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Add this new method to show the bottom sheet with reservation details
  void _showReservationDetails(BuildContext context, ReservationModel reservation) {
    final checkInDate = DateFormat('EEEE, MMM dd, yyyy').format(reservation.checkInDate!);
    final checkOutDate = DateFormat('EEEE, MMM dd, yyyy').format(reservation.checkOutDate!);
    
    // Calculate number of nights
    final nights = reservation.checkOutDate!.difference(reservation.checkInDate!).inDays;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            
            // Header with hotel name and status
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
              decoration: BoxDecoration(
                color: kMainColor.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          reservation.hotelName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(reservation.status??''),
                    ],
                  ),
                
                ],
              ),
            ),
            
            // Reservation details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Booking ID
                    _buildDetailSection(
                      title: 'Booking ID',
                      content: Text(
                        '#${reservation.reservationId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      icon: Icons.confirmation_number,
                    ),
                    
                    const Divider(height: 30),
                    
                    // Dates section
                    _buildDetailSection(
                      title: 'Stay Details',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDateRow(
                            label: 'Check-in',
                            date: checkInDate,
                            icon: Icons.login,
                          ),
                          const SizedBox(height: 12),
                          _buildDateRow(
                            label: 'Check-out',
                            date: checkOutDate,
                            icon: Icons.logout,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            label: 'Duration',
                            value: '$nights ${nights > 1 ? 'nights' : 'night'}',
                            icon: Icons.nightlight_round,
                          ),
                        ],
                      ),
                      icon: Icons.date_range,
                    ),
                    
                    const Divider(height: 30),
                    
                    // Room details
                    _buildDetailSection(
                      title: 'Room Details',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            label: 'Room Type',
                            value: reservation.roomType,
                            icon: Icons.meeting_room,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            label: 'Room Category',
                            value: reservation.roomCategory,
                            icon: Icons.category,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            label: 'Number of Rooms',
                            value: '${reservation.numberOfRooms}',
                            icon: Icons.door_front_door,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            label: 'Bed Type',
                            value: reservation.bedType,
                            icon: Icons.bed,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            label: 'View',
                            value: reservation.viewType,
                            icon: Icons.visibility,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            label: 'Meal Plan',
                            value: reservation.mealPlan,
                            icon: Icons.restaurant,
                          ),
                        ],
                      ),
                      icon: Icons.hotel,
                    ),
                    
                    const Divider(height: 30),
                    
                    // Guest details
                    _buildDetailSection(
                      title: 'Guest Details',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            label: 'Adults',
                            value: '${reservation.adults}',
                            icon: Icons.person,
                          ),
                          if (reservation.children > 0) ...[
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              label: 'Children',
                              value: '${reservation.children}',
                              icon: Icons.child_care,
                            ),
                          ],
                        ],
                      ),
                      icon: Icons.people,
                    ),
                    
                    const Divider(height: 30),
                    
                    // Payment details
                    _buildDetailSection(
                      title: 'Payment Details',
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            label: 'Total Amount',
                            value: '${reservation.totalPrice.toStringAsFixed(0)} EGP',
                            icon: Icons.attach_money,
                            valueStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kMainColor,
                            ),
                          ),
                        ],
                      ),
                      icon: Icons.payment,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Cancel button (if not completed)
                    if (reservation.status != 'Completed' && reservation.status != 'Cancelled')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _cancelReservation(reservation.reservationId!);
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Cancel Reservation'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;
    
    switch (status) {
      case 'Confirmed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Pending':
        color = Colors.orange;
        icon = Icons.pending;
        break;
      case 'Completed':
        color = Colors.blue;
        icon = Icons.done_all;
        break;
      case 'Cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required Widget content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: kMainColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: content,
        ),
      ],
    );
  }

  Widget _buildDateRow({
    required String label,
    required String date,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: kMainColor,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: kMainColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: valueStyle ?? const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Add this method to handle reservation cancellation
  Future<void> _cancelReservation(String reservationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({'status': 'Cancelled'});
      
      // Refresh the reservations list
      fetchReservations();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation cancelled successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error cancelling reservation: $e')),
      );
    }
  }
}