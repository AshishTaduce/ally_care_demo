import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ally_care_demo/features/appointment/data/appointment_model.dart';
import 'package:ally_care_demo/features/appointment/presentation/providers/appointment_provider.dart';
import 'package:ally_care_demo/features/home/presentation/widgets/appointment_card.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

import '../widgets/appointment_details_card.dart';
import '../../../../core/constants/app_colors.dart';

class AllAppointmentsScreen extends ConsumerStatefulWidget {
  const AllAppointmentsScreen({super.key});

  @override
  ConsumerState<AllAppointmentsScreen> createState() =>
      _AllAppointmentsScreenState();
}

class _AllAppointmentsScreenState extends ConsumerState<AllAppointmentsScreen> {
  DateTime? _selectedDate;
  String _searchQuery = '';
  String _selectedType = 'All';
  final TextEditingController _searchController = TextEditingController();

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _showFilterDialog() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        selectedDate: _selectedDate,
        selectedType: _selectedType,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedDate = result['date'];
        _selectedType = result['type'];
      });
    }
  }

  void _showAppointmentDrawer(AppointmentModel appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentDetailsCard(appointment: appointment),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(appointmentsProvider(null));
    final currentUserAsync = ref.watch(currentUserProvider);
    
    return currentUserAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('User not found')));
        }
        
        final userBookingsAsync = ref.watch(userBookingsProvider(user.id));
        
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'All Appointments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Insets.md),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search appointments...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: Insets.borderRadiusMd,
                          ),
                        ),
                        onChanged: (val) => setState(() => _searchQuery = val),
                      ),
                    ),
                    SizedBox(width: Insets.sm),
                    IconButton(
                      icon: Icon(Icons.filter_alt_outlined),
                      onPressed: _showFilterDialog,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: appointmentsAsync.when(
                  data: (appointments) {
                    return userBookingsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      data: (bookings) {
                        // Get booked appointment IDs (only active, non-cancelled bookings)
                        final bookedAppointmentIds = bookings
                            .where((b) => b['status'] != 'cancelled')
                            .map((b) => b['appointmentId'] as String)
                            .toSet();

                        // Filter by search, type, and date
                        var filtered = appointments.where((a) {
                          final matchesTitle = a.title.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                          final matchesType =
                              _selectedType == 'All' ||
                              (_selectedType == 'Online' && a.isOnline) ||
                              (_selectedType == 'In-Person' && !a.isOnline);
                          final matchesDate =
                              _selectedDate == null ||
                              a.availableSlots.any(
                                (slot) => isSameDay(slot, _selectedDate!),
                              );
                          return matchesTitle && matchesType && matchesDate;
                        }).toList();

                        // Sort locally: booked appointments first
                        filtered.sort((a, b) {
                          final aBooked = bookedAppointmentIds.contains(a.id);
                          final bBooked = bookedAppointmentIds.contains(b.id);
                          if (aBooked && !bBooked) return -1;
                          if (!aBooked && bBooked) return 1;
                          return 0; // Keep original order for same booking status
                        });

                        if (filtered.isEmpty) {
                          return const Center(
                            child: Text('No appointments available.'),
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(appointmentsProvider(null));
                            ref.invalidate(userBookingsProvider(user.id));
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.all(Insets.md),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) => SizedBox(height: Insets.sm),
                            itemBuilder: (context, index) {
                              final appt = filtered[index];
                              final isBooked = bookedAppointmentIds.contains(appt.id);
                              return AppointmentCard(
                                appointment: appt,
                                isBooked: isBooked,
                                onTap: () => _showAppointmentDrawer(appt),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final DateTime? selectedDate;
  final String selectedType;
  const _FilterBottomSheet({Key? key, this.selectedDate, required this.selectedType})
    : super(key: key);
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  DateTime? _date;
  String _type = 'All';
  
  @override
  void initState() {
    super.initState();
    _date = widget.selectedDate;
    _type = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: Insets.md),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey400,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: EdgeInsets.all(Insets.lg),
            child: Row(
              children: [
                Icon(Icons.filter_alt, color: AppColors.primaryBlue, size: 24),
                SizedBox(width: Insets.sm),
                Expanded(
                  child: Text(
                    'Filter Appointments',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _date = null;
                      _type = 'All';
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Filter options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Filter
                Text(
                  'Date',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                  ),
                ),
                SizedBox(height: Insets.sm),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _date ?? DateTime.now(),
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _date = picked);
                  },
                  child: Container(
                    padding: EdgeInsets.all(Insets.md),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.grey300),
                      borderRadius: BorderRadius.circular(Insets.radiusMd),
                      color: _date != null ? AppColors.primaryBlue.withOpacity(0.1) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: _date != null ? AppColors.primaryBlue : AppColors.grey600,
                          size: 20,
                        ),
                        SizedBox(width: Insets.sm),
                        Expanded(
                          child: Text(
                            _date == null
                                ? 'Select a date'
                                : '${_date!.day}/${_date!.month}/${_date!.year}',
                            style: TextStyle(
                              color: _date != null ? AppColors.primaryBlue : AppColors.grey600,
                              fontWeight: _date != null ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ),
                        if (_date != null)
                          GestureDetector(
                            onTap: () => setState(() => _date = null),
                            child: Icon(
                              Icons.close,
                              color: AppColors.grey600,
                              size: 18,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: Insets.lg),
                
                // Type Filter
                Text(
                  'Appointment Type',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey700,
                  ),
                ),
                SizedBox(height: Insets.sm),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Insets.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey300),
                    borderRadius: BorderRadius.circular(Insets.radiusMd),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _type,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey600),
                      items: [
                        {'value': 'All', 'label': 'All Types', 'icon': Icons.all_inclusive},
                        {'value': 'Online', 'label': 'Online', 'icon': Icons.video_call},
                        {'value': 'In-Person', 'label': 'In-Person', 'icon': Icons.person},
                      ].map((item) => DropdownMenuItem<String>(
                        value: item['value'] as String,
                        child: Row(
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color: _type == item['value'] ? AppColors.primaryBlue : AppColors.grey600,
                              size: 18,
                            ),
                            SizedBox(width: Insets.sm),
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                color: _type == item['value'] ? AppColors.primaryBlue : AppColors.grey600,
                                fontWeight: _type == item['value'] ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      onChanged: (val) => setState(() => _type = val ?? 'All'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: Insets.lg),
          
          // Action buttons
          Padding(
            padding: EdgeInsets.all(Insets.lg),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: Insets.md),
                      side: BorderSide(color: AppColors.grey400),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.grey700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Insets.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, {'date': _date, 'type': _type}),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      padding: EdgeInsets.symmetric(vertical: Insets.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                      ),
                    ),
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

