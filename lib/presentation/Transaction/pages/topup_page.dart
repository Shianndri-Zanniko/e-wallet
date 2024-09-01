import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/common/helper/animations/confirm_animation.dart';
import 'package:ewallet/common/widgets/appbar/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopupPage extends StatefulWidget {
  const TopupPage({super.key});

  @override
  TopupPageState createState() => TopupPageState();
}

class TopupPageState extends State<TopupPage> {
  final TextEditingController _amountController = TextEditingController();
  String _balance = '';

  void _setAmount(String amount) {
    _amountController.text = amount;
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(currentUserId).get();
      if (mounted) {
        setState(() {
          _balance = doc.get('balance');
        });
      }
    }
  }

  Future<void> _updateBalance() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      int currentBalance = int.parse(_balance);
      int amountToAdd = int.parse(_amountController.text);
      int newBalance = currentBalance + amountToAdd;

      await FirebaseFirestore.instance.collection('Users').doc(currentUserId).update({
        'balance': newBalance.toString(),
      });

      if (mounted) {
        setState(() {
          _balance = newBalance.toString();
        });


        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ConfirmationAnimation(),
                const SizedBox(height: 20),
                Text('Top-Up Successful!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update balance')),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(backgroundColor: Colors.white),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top up your wallet',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the amount',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  prefixText: 'Rp ',
                  prefixStyle: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  border: const UnderlineInputBorder(),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Amount',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildAmountButton('50000'),
                  _buildAmountButton('100000'),
                  _buildAmountButton('200000'),
                  _buildAmountButton('500000'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _updateBalance,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF464BD8),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: Text(
              'Confirm',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return OutlinedButton(
      onPressed: () => _setAmount(amount),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF464BD8)),
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: Text(
        'Rp $amount',
        style: GoogleFonts.poppins(
          color: const Color(0xFF464BD8),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}