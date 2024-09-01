import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewallet/common/helper/navigator/navigate_with_slide.dart';
import 'package:ewallet/presentation/Transaction/pages/pay_page.dart';
import 'package:ewallet/presentation/Transaction/pages/topup_page.dart';
import 'package:ewallet/presentation/profile/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  String _username = '';
  String _balance = '';

  late AnimationController _controller;
  late Animation<double> _balanceAnimation;
  double _previousBalance = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _balanceAnimation = Tween<double>(begin: 0.0, end: _previousBalance).animate(_controller)
      ..addListener(() {
        setState(() {
          _balance = _formatBalance(_balanceAnimation.value.toString());
        });
      });

    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('Users').doc(currentUserId).get();
      double newBalance = double.parse(doc.get('balance'));
      _updateBalance(newBalance);
      setState(() {
        _username = doc.get('username');
      });
    }
  }

  void _updateBalance(double newBalance) {
    _previousBalance = _balanceAnimation.value;
    _balanceAnimation = Tween<double>(begin: _previousBalance, end: newBalance).animate(_controller);
    _controller.forward(from: 0.0);
  }

  String _formatBalance(String balance) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(double.parse(balance));
  }

  Future<void> _refresh() async {
    await _fetchUserData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _account(context),
                _recentsend(context),
                _contentServices(context)
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Container _account(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFF464BD8)),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    navigateWithSlideTransition(context, const ProfilePage());
                  },
                  child: const CircleAvatar(
                    radius: 26,
                    child: Icon(Icons.person, size: 32),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning.',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      _username,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: _refresh,
                  color: const Color(0xff2656c3),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 34),
            Column(
              children: [
                Text(
                  'Balance',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  _balance,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.w700),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Container _recentsend(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 0),
      decoration: const BoxDecoration(color: Color(0xFF464BD8)),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send & Receive Payment',
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

  class ModelServices {
    final String title;
    final String img;

    ModelServices({required this.title, required this.img});
  }

  Widget _contentServices(BuildContext context) {
    List<ModelServices> listServices = [
      ModelServices(title: "Top Up", img: "wallet-add-1-svgrepo-com.svg"),
      ModelServices(title: "Pay", img: "wallet-send-svgrepo-com.svg"),
    ];

    return SizedBox(
      width: double.infinity,
      height: 260,
      child: GridView.count(
        crossAxisCount: 4,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.5),
        children: listServices.map((value) {
          return GestureDetector(
            onTap: () {
              if (value.title == "Top Up") {
                navigateWithSlideTransition(context, const TopupPage());
              } else if (value.title == "Pay") {
                navigateWithSlideTransition(context, const PayPage());
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset("assets/vectors/${value.img}"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  value.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xff3A4276),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
