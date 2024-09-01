import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/common/helper/animations/confirm_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ewallet/common/widgets/appbar/app_bar.dart';

class PayPage extends StatefulWidget {
  const PayPage({super.key});

  @override
  PayPageState createState() => PayPageState();
}

class PayPageState extends State<PayPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _senderBalance = '';
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _fetchSenderData();
  }

  Future<void> _fetchSenderData() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(currentUserId).get();
      if (mounted) {
        setState(() {
          _senderBalance = doc.get('balance');
          _currentUsername = doc.get('username');
        });
      }
    }
  }

  void _setAmount(String amount) {
    _amountController.text = amount;
  }

  Future<void> _sendMoney() async {
    String? senderId = FirebaseAuth.instance.currentUser?.uid;
    if (senderId != null) {
      int senderBalance = int.parse(_senderBalance);
      int amountToSend = int.parse(_amountController.text);
      String targetUsername = _usernameController.text;


      if (targetUsername == _currentUsername) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You cannot send money to yourself')),
          );
        }
        return;
      }

      if (amountToSend > senderBalance) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Insufficient balance')),
          );
        }
        return;
      }

      QuerySnapshot targetUserSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: targetUsername)
          .get();

      if (targetUserSnapshot.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Target user not found')),
          );
        }
        return;
      }

      DocumentSnapshot targetDoc = targetUserSnapshot.docs.first;
      String targetUserId = targetDoc.id;

      int newSenderBalance = senderBalance - amountToSend;
      await FirebaseFirestore.instance.collection('Users').doc(senderId).update({
        'balance': newSenderBalance.toString(),
      });


      int targetBalance = int.parse(targetDoc.get('balance'));
      int newTargetBalance = targetBalance + amountToSend;
      await FirebaseFirestore.instance.collection('Users').doc(targetUserId).update({
        'balance': newTargetBalance.toString(),
      });

      if (mounted) {
        setState(() {
          _senderBalance = newSenderBalance.toString();
        });


        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ConfirmationAnimation(),
                const SizedBox(height: 20),
                Text('Payment Successful!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send money')),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _usernameController.dispose();
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
                'Send Money',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your Balance: Rp $_senderBalance',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the amount',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 20),
              Text(
                'Enter target username',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                  border: const UnderlineInputBorder(),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
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
            onPressed: _sendMoney,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF464BD8),
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: Text(
              'Send',
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