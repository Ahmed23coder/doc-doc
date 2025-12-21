import 'package:docdoc/core/utils/appointment_store.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/appointment/data/repository/appointment_repository.dart';
import 'package:docdoc/features/appointment/logic/appointment_bloc.dart';
import 'package:docdoc/features/appointment/logic/appointment_event.dart';
import 'package:docdoc/features/appointment/logic/appointment_state.dart';
import 'package:docdoc/features/appointment/presentation/myAppointment/reschedule_appointment_screen.dart';
import 'package:docdoc/models/appointment_model.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppointmentsScreen extends StatefulWidget {
  const MyAppointmentsScreen({super.key});

  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final allAppointments = AppointmentsStore.appointments;
    return BlocProvider(
      // 1. Trigger Fetch Event
      create: (context) =>
          AppointmentsBloc(AppointmentRepository())
            ..add(GetAppointmentsEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("My Appointment"),
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black),
            ),
          ],
          titleTextStyle: TextStyleManager.interBold18.copyWith(
            color: Colors.black,
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: PrimaryColor.primary100,
            unselectedLabelColor: GrayColor.grey60,
            indicatorColor: PrimaryColor.primary100,
            indicatorWeight: 3,
            labelStyle: TextStyleManager.interSemiBold14,
            tabs: const [
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),

        // 2. State Management
        body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PrimaryColor.primary100,
                ),
              );
            } else if (state is AppointmentsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    state.message,
                    style: TextStyleManager.interMedium14.copyWith(
                      color: Secondary.fillRed,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (state is AppointmentsLoaded) {
              // 3. Pass Fetched List
              // Assuming API returns lowercase status strings: "upcoming", "completed", "cancelled"
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildList(
                    allAppointments,
                    "upcoming",
                  ), // or boolean check if your API uses bool
                  _buildList(allAppointments, "completed"),
                  _buildList(allAppointments, "cancelled"),
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(color: PrimaryColor.primary100),
            );
          },
        ),
      ),
    );
  }

  Widget _buildList(List<AppointmentData> allList, String status) {
    // NOTE: Adjust this filter based on exactly what your API returns for 'status'
    // Example: If API returns 0/1, change this logic. Assuming string for now.
    final filtered = allList
        .where((e) => (e.status.toLowerCase()) == status)
        .toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: GrayColor.grey40,
            ),
            const SizedBox(height: 16),
            Text(
              "No ${status} appointments",
              style: TextStyleManager.interMedium14.copyWith(
                color: GrayColor.grey60,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      separatorBuilder: (c, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: filtered[index]);
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentData appointment;
  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // Map your Model fields here
    final status = appointment.status
        .toLowerCase(); // "upcoming", "completed", etc
    final doctor = appointment.doctor;
    final time = appointment.appointmentTime; // e.g., "10:00 AM" or ISO string

    // You might need to format date/time if it comes as raw ISO string
    // For now assuming it is display-ready string based on your model snippet.

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GrayColor.grey30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // --- STATUS LABEL (If not upcoming) ---
          if (status != "upcoming") ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  status == "completed"
                      ? "Appointment done"
                      : "Appointment cancelled",
                  style: TextStyleManager.interMedium12.copyWith(
                    color: status == "completed"
                        ? Secondary.fillGreen
                        : Secondary.fillRed,
                  ),
                ),
                const Icon(Icons.more_vert, color: GrayColor.grey60, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: GrayColor.grey20, height: 1),
            const SizedBox(height: 12),
          ],

          // --- DOCTOR INFO ---
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    // Handle null or invalid URL
                    image: NetworkImage(
                      doctor?.photo ?? "https://via.placeholder.com/150",
                    ),
                    fit: BoxFit.cover,
                    onError: (e, s) => const Icon(Icons.person), // Fallback
                  ),
                  color: GrayColor.grey20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor?.name ?? "Unknown Doctor",
                      style: TextStyleManager.interBold16.copyWith(
                        color: GrayColor.grey100,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor?.specialization?.name ?? 'Specialist',
                      style: TextStyleManager.interMedium12.copyWith(
                        color: GrayColor.grey60,
                      ),
                    ),
                  ],
                ),
              ),
              // Chat Bubble (Only Upcoming)
              if (status == "upcoming")
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Secondary.surfaceBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: PrimaryColor.primary100,
                    size: 20,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),
          Divider(color: GrayColor.grey20, height: 1),
          const SizedBox(height: 12),

          // --- DATE & TIME ---
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: GrayColor.grey60,
              ),
              const SizedBox(width: 6),
              // Using appointmentTime. If you have separate Date field, combine them here.
              Text(
                time,
                style: TextStyleManager.interMedium12.copyWith(
                  color: GrayColor.grey80,
                ),
              ),
              if (appointment.appointmentPrice > 0) ...[
                const Spacer(),
                Text(
                  "\$${appointment.appointmentPrice}",
                  style: TextStyleManager.interBold14.copyWith(
                    color: GrayColor.grey100,
                  ),
                ),
              ],
            ],
          ),

          // --- ACTION BUTTONS (Upcoming Only) ---
          if (status == "upcoming") ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: "Cancel Appointment",
                    type: ButtonType.secondary, // Outline
                    size: ButtonSize.small,
                    onTap: () {
                      // Add Cancel Event logic here
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    text: "Reschedule",
                    type: ButtonType.primary, // Blue Filled
                    size: ButtonSize.small,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RescheduleAppointmentScreen(
                            appointment: appointment,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
