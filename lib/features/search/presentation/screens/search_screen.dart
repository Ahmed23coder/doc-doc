import 'package:docdoc/features/search/presentation/widget/search_doctors_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/core/utils/colors_manager.dart';
import 'package:docdoc/core/utils/text_style_manager.dart';
import 'package:docdoc/features/search/data/repository/search_repository.dart';
import 'package:docdoc/features/search/logic/search_bloc.dart';
import 'package:docdoc/features/search/logic/search_event.dart';
import 'package:docdoc/features/search/logic/search_state.dart';
import 'package:docdoc/models/doctor_filter_model.dart';
import 'package:docdoc/models/specialization_model.dart';
import 'package:docdoc/presentation/widgets/shared/button_widget.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  // Local State
  String _currentQuery = '';
  DoctorFilterModel _currentFilter = DoctorFilterModel();

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _triggerSearch(BuildContext context) {
    context.read<SearchBloc>().add(
      FetchSearchEvent(query: _currentQuery, filters: _currentFilter),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => SearchBloc(SearchRepository()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text("Search", style: TextStyleManager.interBold14),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.width * 0.05,
                  horizontal: size.height * 0.02,
                ),
                child: Column(
                  children: [
                    // --- Search Bar & Filter Button ---
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyleManager.interMedium16.copyWith(
                              color: GrayColor.grey100,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyleManager.interRegular12
                                  .copyWith(color: GrayColor.grey80),
                              prefixIcon: const Icon(
                                Icons.search_sharp,
                                color: GrayColor.grey80,
                              ),
                              filled: true,
                              fillColor: GrayColor.grey20,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) {
                              _currentQuery = value;
                              _triggerSearch(context);
                            },
                          ),
                        ),
                        SizedBox(width: size.width * 0.02),
                        GestureDetector(
                          onTap: () => _showFilterBottomSheet(context, size),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: GrayColor.grey20,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.filter_list),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.02),

                    // --- Results Area ---
                    Expanded(
                      child: BlocBuilder<SearchBloc, SearchState>(
                        builder: (context, state) {
                          if (state is SearchLoading) {
                            return const Center(
                              child: CircularProgressIndicator(color: PrimaryColor.primary100),
                            );
                          } else if (state is SearchSuccess) {
                            if (state.doctors.isEmpty) {
                              return _buildEmptyState("No doctors found");
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${state.doctors.length} found",
                                  style: TextStyleManager.interBold16.copyWith(
                                    color: GrayColor.grey80,
                                  ),
                                ),
                                SizedBox(height: size.height * 0.02),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: SearchDoctorsListWidget(
                                      doctorsList: state.doctors,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if (state is SearchError) {
                            return Center(
                              child: Text(
                                state.error,
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          return _buildEmptyState("Search for a doctor.");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 80, color: GrayColor.grey20),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyleManager.interMedium16.copyWith(
              color: GrayColor.grey80,
            ),
          ),
        ],
      ),
    );
  }

  // --- Filter Bottom Sheet Logic ---
  void _showFilterBottomSheet(BuildContext parentContext, Size size) {
    // 1. Load data once outside the builder to prevent reloading on clicks
    final Future<List<SpecializationModel>> specializationFuture =
    SearchRepository().getAllSpecializations();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        // 2. StatefulBuilder allows updating the sheet (blue color) independently
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              height: size.height * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Handle Bar ---
                  Center(
                    child: Container(
                      width: 50, height: 4,
                      decoration: BoxDecoration(
                        color: GrayColor.grey30,
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // --- Title ---
                  Center(
                    child: Text(
                      "Sort by",
                      style: TextStyleManager.interSemiBold18.copyWith(
                        color: GrayColor.grey100,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(width: double.infinity, height: 1, color: GrayColor.grey30),
                  SizedBox(height: size.height * 0.03),

                  // --- Section Header ---
                  Text(
                    "Speciality",
                    style: TextStyleManager.interMedium16.copyWith(
                      color: GrayColor.grey100,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // --- Chips ---
                  Expanded(
                    child: FutureBuilder<List<SpecializationModel>>(
                      future: specializationFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: PrimaryColor.primary100),
                          );
                        }

                        final specializations = snapshot.data ?? [];
                        if (specializations.isEmpty) {
                          return const Text("No specializations available");
                        }

                        return SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              // 1. "All" Chip
                              _buildFilterChip(
                                label: "All",
                                isSelected: _currentFilter.specializationId == null,
                                onTap: () {
                                  setSheetState(() {
                                    _currentFilter = DoctorFilterModel(specializationId: null);
                                  });
                                  setState(() {}); // Updates main screen
                                },
                              ),

                              // 2. Dynamic Chips
                              ...specializations.map((spec) {

                                if (spec.id == 0) return const SizedBox.shrink();

                                final isSelected = _currentFilter.specializationId == spec.id;

                                return _buildFilterChip(
                                  label: spec.name ?? "Unknown",
                                  isSelected: isSelected,
                                  onTap: () {
                                    setSheetState(() {
                                      // Toggle logic
                                      if (isSelected) {
                                        _currentFilter = DoctorFilterModel(specializationId: null);
                                      } else {
                                        _currentFilter = DoctorFilterModel(specializationId: spec.id);
                                      }
                                    });
                                    setState(() {}); // Updates main screen
                                  },
                                );
                              }),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // --- Done Button ---
                  const SizedBox(height: 10),
                  ButtonWidget(
                    text: "Done",
                    onTap: () {
                      parentContext.read<SearchBloc>().add(
                        FetchSearchEvent(query: _currentQuery, filters: _currentFilter),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper Widget for Chips
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? PrimaryColor.primary100 : GrayColor.grey20,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : GrayColor.grey80,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}