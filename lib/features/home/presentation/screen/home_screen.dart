import 'dart:math' as math;

import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:ally_care_demo/seed_data_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/routes/route_names.dart';
import '../../../appointment/presentation/widgets/appointment_details_card.dart';
import '../../../assessment/presentation/providers/assessment_provider.dart';
import '../../../appointment/presentation/providers/appointment_provider.dart';
import '../widgets/appointment_card.dart';
import '../widgets/challange_card.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/animated_tab_bar.dart';
import '../widgets/assessment_card.dart';
import '../widgets/home_common_widgets.dart';
import '../../../../core/theme/insets.dart';
import '../widgets/workout_section.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  int activeTab = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(Insets.md).copyWith(
        bottom: Insets.sm,
      ),
      margin: EdgeInsets.symmetric(vertical: Insets.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Insets.md),
        border: Border.all(color: Color(0xFFf1f1f9)),
        color: AppColors.tabBackground,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: Insets.screenPaddingAll,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HomeAppBar(),
                  SizedBox(height: Insets.md.h),
                  HomeTabBar(
                    tabController: _tabController,
                    updateTab: (int newIndex) => setState(() {
                      activeTab = newIndex;
                    }),
                  ),
                  PageTransitionSwitcher(
                    duration: const Duration(milliseconds: 400),
                    reverse: false,
                    transitionBuilder:
                        (
                          Widget child,
                          Animation<double> primaryAnimation,
                          Animation<double> secondaryAnimation,
                        ) {
                          return SharedAxisTransition(
                            animation: primaryAnimation,
                            secondaryAnimation: secondaryAnimation,
                            transitionType: SharedAxisTransitionType.horizontal,
                            child: child,
                          );
                        },
                    child: IndexedStack(
                      key: ValueKey<int>(activeTab),
                      index: activeTab,
                      children: [
                        _buildCard(child: _AssessmentsTabView()),
                        _buildCard(child: _AppointmentsTabView()),
                      ],
                    ),
                  ),
                  ChallengeCard(),
                  WorkoutSection(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        SeedData.addAllSampleData();
        Future<void> seedWorkoutRoutines() async {
          final firestore = FirebaseFirestore.instance;
          final routines = [
            {
              'title': 'Sweat Starter',
              'type': 'Full Body',
              'imageUrl': 'https://images.pexels.com/photos/1552242/pexels-photo-1552242.jpeg',
              'tag': 'Lose Weight',
              'difficulty': 'Medium',
              'description': 'A full body workout to get you sweating and burning calories.',
            },
            {
              'title': 'Strength Builder',
              'type': 'Upper Body',
              'imageUrl': 'https://images.pexels.com/photos/2261482/pexels-photo-2261482.jpeg',
              'tag': 'Build Muscle',
              'difficulty': 'Hard',
              'description': 'Focus on upper body strength and muscle gain.',
            },
            {
              'title': 'Flexibility Flow',
              'type': 'Stretching',
              'imageUrl': 'https://images.pexels.com/photos/4056723/pexels-photo-4056723.jpeg',
              'tag': 'Flexibility',
              'difficulty': 'Easy',
              'description': 'Improve your flexibility with guided stretching routines.',
            },
          ];
          for (final routine in routines) {
            await firestore.collection('workout_routines').add(routine);
          }
          print('Seeded workout routines!');
        }
        seedWorkoutRoutines();
      }),
    );
  }
}

// Assessments Tab View Widget
class _AssessmentsTabView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAssessments = ref.watch(recentAssessmentsProvider);

    return recentAssessments.when(
      data: (assessments) {
        if (assessments.isEmpty) {
          return HomeCommonWidgets.buildEmptyState(
            context,
            icon: Icons.assignment_outlined,
            title: 'No Assessments Yet',
            subtitle: 'Start your health journey with an assessment',
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(recentAssessmentsProvider);
          },
          child: Column(
            children: [
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: math.min(assessments.length, 2),
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: Insets.sm),
                itemBuilder: (context, index) =>
                    AssessmentCard(assessment: assessments[index]),
              ),
              SizedBox(height: Insets.sm),
              Center(
                child: ElevatedButton(
                  onPressed: () => context.push(RouteNames.fullAssessments),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textTertiaryLight,
                  ),
                  child: Text("View All", style: AppTypography.buttonSmall),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => SizedBox(),
      error: (error, stack) => HomeCommonWidgets.buildErrorState(
        context,
        error.toString(),
        () => ref.refresh(recentAssessmentsProvider),
      ),
    );
  }
}

class _AppointmentsTabView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAppointments = ref.watch(recentAppointmentsProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    return currentUserAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (user) {
        if (user == null) {
          return const Center(child: Text('User not found'));
        }
        final userId = user.id;
        final userBookingsAsync = ref.watch(userBookingsProvider(userId));
        return userBookingsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (bookings) {
            // Get only active (non-cancelled) bookings
            final activeBookings = bookings.where((b) => b['status'] != 'cancelled').toList();
            
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(recentAppointmentsProvider);
                ref.invalidate(userBookingsProvider(userId));
              },
              child: recentAppointments.when(
                data: (appointments) {
                  // Get booked appointment IDs (only active bookings)
                  final bookedAppointmentIds = activeBookings
                      .map((b) => b['appointmentId'] as String)
                      .toSet();

                  // Separate booked and unbooked appointments
                  final bookedAppointments = appointments
                      .where((appointment) => bookedAppointmentIds.contains(appointment.id))
                      .toList();
                  
                  final unbookedAppointments = appointments
                      .where((appointment) => !bookedAppointmentIds.contains(appointment.id))
                      .toList();

                  // Combine and prioritize booked appointments, limit to 4 total
                  final allAppointments = [...bookedAppointments, ...unbookedAppointments];
                  final displayAppointments = allAppointments.take(4).toList();

                  if (displayAppointments.isEmpty) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 60,
                                color: AppColors.primaryBlue.withOpacity(0.5),
                              ),
                              SizedBox(height: Insets.md),
                              Text(
                                'No Appointments Available',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              SizedBox(height: Insets.xs),
                              Text(
                                'Check back later for new appointments',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: Insets.md),
                              ElevatedButton(
                                onPressed: () => context.push(RouteNames.fullAppointments),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                                child: Text("View All", style: AppTypography.buttonMedium),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: displayAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = displayAppointments[index];
                          final isBooked = bookedAppointmentIds.contains(appointment.id);
                          return AppointmentCard(
                            appointment: appointment, 
                            isFromHome: true,
                            isBooked: isBooked,
                            onTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => AppointmentDetailsCard(appointment: appointment),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Insets.md,
                          crossAxisSpacing: Insets.md,
                          childAspectRatio: 7/6.5,
                        ),
                      ),
                      SizedBox(height: Insets.sm),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => context.push(RouteNames.fullAppointments),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textTertiaryLight,
                          ),
                          child: Text("View All", style: AppTypography.buttonSmall),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Container(),
                error: (error, stack) => HomeCommonWidgets.buildErrorState(
                  context,
                  error.toString(),
                  () => ref.refresh(recentAppointmentsProvider),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
