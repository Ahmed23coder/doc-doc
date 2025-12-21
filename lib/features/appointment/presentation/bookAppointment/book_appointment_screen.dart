import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/appointment/data/repository/appointment_repository.dart';
import 'package:docdoc/features/appointment/logic/appointment_bloc.dart';
import 'package:docdoc/features/appointment/logic/appointment_event.dart';
import 'package:docdoc/features/appointment/logic/appointment_state.dart';
import 'package:docdoc/features/appointment/presentation/bookAppointment/payment_screen.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:docdoc/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:docdoc/core/utils/colors_manager.dart';

class BookAppointmentScreen extends StatefulWidget {
  final DoctorModel doctor;

  const BookAppointmentScreen({super.key, required this.doctor});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  int _selectedTypeIndex = 0;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final List<DateTime> _dates = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index)),
  );
  final List<String> _times = [
    "09:00 AM",
    "09:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
  ];
  final List<Map<String, dynamic>> _appointmentTypes = [
    {"icon": Icons.person, "title": "In Person"},
    {"icon": Icons.videocam, "title": "Video Call"},
    {"icon": Icons.phone, "title": "Phone Call"},
  ];

  void _scrollList() {
    const double itemExtent = 60.0;
    final double position = _selectedDateIndex * itemExtent;
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => AppointmentsBloc(AppointmentRepository()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Book Appointment"),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          titleTextStyle: TextStyleManager.interBold18.copyWith(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepIndicator(size),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_sectionTitle("Select Date")],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_selectedDateIndex > 0) {
                        setState(() => _selectedDateIndex--);
                        _scrollList();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 14,
                      color: GrayColor.grey100,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Expanded(
                    child: SizedBox(
                      height: 75,
                      child: ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _dates.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          return _buildDateCard(index);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  IconButton(
                    onPressed: () {
                      if (_selectedDateIndex < _dates.length - 1) {
                        setState(() => _selectedDateIndex++);
                        _scrollList();
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: GrayColor.grey100,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              _sectionTitle("Available Time"),
              SizedBox(height: size.height * 0.015),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: size.width * 0.03,
                  runSpacing: size.height * 0.015,
                  children: List.generate(_times.length, (index) {
                    return _buildTimeChip(index, size);
                  }),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              _sectionTitle("Appointment Type"),
              SizedBox(height: size.height * 0.015),
              ...List.generate(
                _appointmentTypes.length,
                (index) => _buildTypeCard(index, size),
              ),
              SizedBox(height: size.height * 0.04),
              _buildContinueButton(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyleManager.interBold16.copyWith(color: GrayColor.grey100),
  );

  Widget _buildStepIndicator(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _stepItem("1", "Select Time", true),
        _stepLine(size),
        _stepItem("2", "Payment", false),
        _stepLine(size),
        _stepItem("3", "Summary", false),
      ],
    );
  }

  Widget _stepItem(String number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? PrimaryColor.primary100 : GrayColor.grey20,
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: TextStyleManager.interBold12.copyWith(
              color: isActive ? Colors.white : GrayColor.grey50,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyleManager.interMedium10.copyWith(
            color: isActive ? PrimaryColor.primary100 : GrayColor.grey50,
          ),
        ),
      ],
    );
  }

  Widget _stepLine(Size size) =>
      Container(width: size.width * 0.08, height: 1, color: GrayColor.grey40);

  Widget _buildDateCard(int index) {
    final date = _dates[index];
    final isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedDateIndex = index);
        _scrollList();
      },
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isSelected ? 50.0 : 38.0,
          height: isSelected ? 65.0 : 44.0,
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected ? PrimaryColor.primary100 : Secondary.surfaceText,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? PrimaryColor.primary100
                  : Secondary.surfaceText,
              width: 0.78,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: PrimaryColor.primary100.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: isSelected
                    ? TextStyleManager.interSemiBold11.copyWith(
                        color: Colors.white,
                      )
                    : TextStyleManager.interRegular10.copyWith(
                        color: GrayColor.grey50,
                        fontSize: 9,
                      ),
                child: Text(DateFormat('EEE').format(date)),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: isSelected
                    ? TextStyleManager.interBold16.copyWith(color: Colors.white)
                    : TextStyleManager.interBold14.copyWith(
                        color: GrayColor.grey50,
                        fontSize: 13,
                      ),
                child: Text(date.day.toString().padLeft(2, '0')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeChip(int index, Size size) {
    final isSelected = _selectedTimeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isSelected ? 157 : 158,
        height: 49,
        padding: const EdgeInsets.fromLTRB(8, 14, 8, 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? PrimaryColor.primary100 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? PrimaryColor.primary100 : GrayColor.grey20,
            width: 1,
          ),
        ),
        child: Text(
          _times[index],
          style: isSelected
              ? TextStyleManager.interBold12.copyWith(color: Colors.white)
              : TextStyleManager.interMedium12.copyWith(
                  color: GrayColor.grey100,
                ),
        ),
      ),
    );
  }

  Widget _buildTypeCard(int index, Size size) {
    final type = _appointmentTypes[index];
    final isSelected = _selectedTypeIndex == index;
    Color iconBgColor;
    Color iconColor;
    switch (index) {
      case 0:
        iconBgColor = Secondary.surfaceBlue;
        iconColor = Secondary.fillBlue;
        break;
      case 1:
        iconBgColor = Secondary.surfaceGreen;
        iconColor = Secondary.fillGreen;
        break;
      case 2:
        iconBgColor = Secondary.surfaceRed;
        iconColor = Secondary.fillRed;
        break;
      default:
        iconBgColor = GrayColor.grey20;
        iconColor = GrayColor.grey50;
    }
    return GestureDetector(
      onTap: () => setState(() => _selectedTypeIndex = index),
      child: Container(
        margin: EdgeInsets.only(bottom: size.height * 0.015),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: index != _appointmentTypes.length - 1
              ? Border(bottom: BorderSide(color: GrayColor.grey20))
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(type['icon'], color: iconColor, size: 24),
            ),
            SizedBox(width: size.width * 0.04),
            Expanded(
              child: Text(
                type['title'],
                style: TextStyleManager.interMedium14.copyWith(
                  color: GrayColor.grey100,
                ),
              ),
            ),
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
                      : GrayColor.grey30,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.circle, size: 8, color: Colors.white),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(Size size) {
    return BlocListener<AppointmentsBloc, AppointmentsState>(
      listener: (context, state) {
        if (state is AppointmentBookingSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(
                doctor: widget.doctor,
                bookingDate: _dates[_selectedDateIndex],
                bookingTime: _times[_selectedTimeIndex],
                appointmentType: _appointmentTypes[_selectedTypeIndex]['title'],
              ),
            ),
          );
        } else if (state is AppointmentBookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Secondary.fillRed,
            ),
          );
        }
      },
      child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (context, state) {
          if (state is AppointmentBookingLoading) {
            return const Center(
              child: CircularProgressIndicator(color: PrimaryColor.primary100),
            );
          }
          return ButtonWidget(
            text: "Continue",
            size: ButtonSize.large,
            width: double.infinity,
            type: ButtonType.primary,
            onTap: () {
              if (_selectedTimeIndex == -1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a time first")),
                );
                return;
              }
              final datePart = DateFormat(
                'yyyy-MM-dd',
              ).format(_dates[_selectedDateIndex]);
              context.read<AppointmentsBloc>().add(
                BookAppointmentEvent(
                  doctorId: widget.doctor.id,
                  startTime: "$datePart ${_times[_selectedTimeIndex]}",
                  notes: "Booking via App",
                ),
              );
            },
          );
        },
      ),
    );
  }
}
