import 'package:flutter/material.dart';
import 'package:new_flutter/core/widgets/contants.dart';
import 'package:new_flutter/features/Componants/buttons.dart';
import 'package:intl/intl.dart';
import 'package:new_flutter/features/Componants/custom_button.dart';
import 'package:new_flutter/features/Reservations/models/reservation_model.dart';
import 'package:new_flutter/features/Screens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_flutter/start_app/start_page.dart';

class ConfirmationScreen extends StatefulWidget {
   ReservationModel reservation;

   ConfirmationScreen({Key? key, required this.reservation}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _simulateLoading() {
    setState(() {
      isLoading = true;
    });

    // Upload data to Firestore
    _uploadReservationToFirestore().then((_) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        
        // Show payment success dialog
        _showPaymentSuccessDialog();
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        // Show error dialog
        _showErrorDialog(error.toString());
      }
    });
  }
  
  Future<void> _uploadReservationToFirestore() async {
    try {
      // Get current user ID
      final String? userId = _auth.currentUser?.uid;
      
      if (userId == null) {
        throw Exception('User not logged in');
      }
      
      // Generate a unique reservation ID if not already set
  
      // Add to Firestore
      final docref= _firestore.collection('reservations').doc();
      widget.reservation=widget.reservation.copyWith(reservationId: docref.id);
      docref.set(widget.reservation.toMap());
      // Add artificial delay to simulate processing
      await Future.delayed(const Duration(seconds: 2));
    } catch (e) {
      print('Error uploading reservation: $e');
      rethrow;
    }
  }
  
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to save reservation: $errorMessage'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void _showPaymentSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              SizedBox(height: 16),
              Text(
                'Payment Successful!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kMainColor,
                ),
              ),
            ],
          ),
          content: Text(
            'Your payment of ${widget.reservation.totalPrice.toStringAsFixed(2)} EGP has been processed successfully.',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: CustomButton(
                text: 'Continue',
                width: 200,
                onPressed: () {
                  // Close dialog
                  Navigator.pop(context);
                  
                  // Navigate back to CategoriesScreen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => StartApp()),
                    (route) => false, // Remove all routes
                  );
                },
              ),
            ),
          ],
          actionsPadding: EdgeInsets.only(bottom: 16),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar for bottom sheet
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            
            // Success Icon
           
            const SizedBox(height: 30),
            
            // Booking Details
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
                    'Booking Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kMainColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailItem('Booking ID', widget.reservation.reservationId ?? 'N/A'),
                  _buildDetailItem('Booking Date', widget.reservation.reservationDate != null ? 
                      DateFormat('MMM dd, yyyy').format(widget.reservation.reservationDate!) : 'N/A'),
                  _buildDetailItem('Hotel', widget.reservation.hotelName),
                  _buildDetailItem('Check-in', widget.reservation.checkInDate != null ? 
                      DateFormat('MMM dd, yyyy').format(widget.reservation.checkInDate!) : 'Not selected'),
                  _buildDetailItem('Check-out', widget.reservation.checkOutDate != null ? 
                      DateFormat('MMM dd, yyyy').format(widget.reservation.checkOutDate!) : 'Not selected'),
                  _buildDetailItem('Guests', '${widget.reservation.adults} Adults, ${widget.reservation.children} Children'),
                  _buildDetailItem('Room Type', '${widget.reservation.numberOfRooms} ${widget.reservation.roomType} (${widget.reservation.roomCategory})'),
                  _buildDetailItem('Meal Plan', widget.reservation.mealPlan),
                  _buildDetailItem('View Type', widget.reservation.viewType),
                  _buildDetailItem('Bed Type', widget.reservation.bedType),
                  _buildDetailItem('Total Price', '${widget.reservation.totalPrice.toStringAsFixed(2)} EGP'),
                  _buildDetailItem('Status', widget.reservation.status ?? 'Confirmed'),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Confirm Button with loading state
            isLoading
                ? const CircularProgressIndicator(color: kMainColor)
                : CustomButton(
                    text: 'Confirm',
                    onPressed: _simulateLoading,
                    width: double.infinity,
                  ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}