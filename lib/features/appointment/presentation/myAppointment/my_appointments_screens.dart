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

        body: BlocBuilder<AppointmentsBloc, AppointmentsState>(
          builder: (context, state) {
            if (state is AppointmentsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: PrimaryColor.primary100,
                ),
              );
            } else if (state is AppointmentsError) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    color: Secondary.fillRed.withOpacity(0.1),
                    child: Text(
                      "Failed to fetch recent appointments. Showing local data.",
                      style: TextStyleManager.interMedium12.copyWith(
                        color: Secondary.fillRed,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildList(allAppointments, "upcoming"),
                        _buildList(allAppointments, "completed"),
                        _buildList(allAppointments, "cancelled"),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is AppointmentsLoaded) {
              final combinedAppointments = [
                ...state.appointments,
                ...allAppointments,
              ];
              // Remove duplicates if any (e.g. by ID)
              final Map<int, AppointmentData> uniqueAppointments = {};
              for (var appointment in combinedAppointments) {
                uniqueAppointments[appointment.id] = appointment;
              }
              final finalAppointments = uniqueAppointments.values.toList();

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildList(finalAppointments, "upcoming"),
                  _buildList(finalAppointments, "completed"),
                  _buildList(finalAppointments, "cancelled"),
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
    final status = appointment.status
        .toLowerCase();
    final doctor = appointment.doctor;
    final time = appointment.appointmentTime;



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

          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(
                      doctor?.photo ?? "https://via.placeholder.com/150",
                    ),
                    fit: BoxFit.cover,
                    onError: (e, s) => const Icon(Icons.person),
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

          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: GrayColor.grey60,
              ),
              const SizedBox(width: 6),
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

          if (status == "upcoming") ...[
            const SizedBox(height: 16),
            Row(
              children: [
                // Expanded(
                //   child: ButtonWidget(
                //     text: "Cancel Appointment",
                //     type: ButtonType.secondary,
                //     size: ButtonSize.small,
                //     onTap: () {
                //     },
                //   ),
                // ),
                const SizedBox(width: 12),
                Expanded(
                  child: ButtonWidget(
                    text: "Reschedule",
                    type: ButtonType.primary,
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
