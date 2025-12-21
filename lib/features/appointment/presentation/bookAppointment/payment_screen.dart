
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/appointment/presentation/bookAppointment/summary_screen.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final DoctorModel doctor;
  final DateTime bookingDate;
  final String bookingTime;
  final String appointmentType;

  const PaymentScreen({
    super.key,
    required this.doctor,
    required this.bookingDate,
    required this.bookingTime,
    required this.appointmentType,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentOption = 0;
  final List<Map<String, dynamic>> _savedCards = [
    {"icon": Icons.credit_card, "name": "Master Card", "color": Colors.orange},
    {
      "icon": Icons.credit_card,
      "name": "American Express",
      "color": Colors.blue,
    },
    {"icon": Icons.credit_card, "name": "Capital One", "color": Colors.indigo},
    {"icon": Icons.credit_card, "name": "Barclays", "color": Colors.lightBlue},
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Book Appointment"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        titleTextStyle: TextStyleManager.interBold18.copyWith(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(size.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepIndicator(size),
                  SizedBox(height: size.height * 0.04),
                  Text(
                    "Payment Option",
                    style: TextStyleManager.interBold16.copyWith(
                      color: GrayColor.grey100,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  _buildPaymentOptionItem(
                    index: 0,
                    title: "Credit Card",
                    hasSubList: true,
                  ),
                  _buildPaymentOptionItem(index: 1, title: "Bank Transfer"),
                  _buildPaymentOptionItem(index: 2, title: "Paypal"),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: ButtonWidget(
              text: "Continue",
              size: ButtonSize.large,
              width: double.infinity,
              type: ButtonType.primary,
              onTap: () {
                // PASS EVERYTHING TO SUMMARY
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScreen(
                      doctor: widget.doctor,
                      bookingDate: widget.bookingDate,
                      bookingTime: widget.bookingTime,
                      appointmentType: widget.appointmentType,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ... (Same helpers as before: _buildStepIndicator, _stepItem, _buildPaymentOptionItem)
  Widget _buildStepIndicator(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stepItem("1", "Date & Time", StepState.completed),
        _stepLine(size),
        _stepItem("2", "Payment", StepState.active),
        _stepLine(size),
        _stepItem("3", "Summary", StepState.inactive),
      ],
    );
  }

  Widget _stepItem(String number, String label, StepState state) {
    Color circleColor = state == StepState.active
        ? PrimaryColor.primary100
        : (state == StepState.completed
              ? Secondary.fillGreen
              : GrayColor.grey20);
    Color textColor = state == StepState.completed || state == StepState.active
        ? Colors.white
        : GrayColor.grey50;
    Color labelColor = state == StepState.active
        ? GrayColor.grey100
        : (state == StepState.completed
              ? Secondary.fillGreen
              : GrayColor.grey50);
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Text(
            number,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyleManager.interMedium10.copyWith(color: labelColor),
        ),
      ],
    );
  }

  Widget _stepLine(Size size) =>
      Container(width: size.width * 0.08, height: 1, color: GrayColor.grey40);

  Widget _buildPaymentOptionItem({
    required int index,
    required String title,
    bool hasSubList = false,
  }) {
    final isSelected = _selectedPaymentOption == index;
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _selectedPaymentOption = index),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? PrimaryColor.primary100
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? PrimaryColor.primary100
                          : GrayColor.grey50,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyleManager.interMedium14.copyWith(
                    color: GrayColor.grey100,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected && hasSubList)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              children: List.generate(_savedCards.length, (cardIndex) {
                final card = _savedCards[cardIndex];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: cardIndex != _savedCards.length - 1
                        ? Border(bottom: BorderSide(color: GrayColor.grey20))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(card['icon'], color: card['color'], size: 24),
                      const SizedBox(width: 12),
                      Text(
                        card['name'],
                        style: TextStyleManager.interRegular14.copyWith(
                          color: GrayColor.grey80,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

enum StepState { completed, active, inactive }
