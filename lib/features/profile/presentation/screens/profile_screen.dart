import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:ally_care_demo/core/theme/insets.dart';
import 'package:ally_care_demo/core/theme/typography.dart';
import 'package:ally_care_demo/features/auth/presentation/providers/auth_provider.dart';
import 'package:ally_care_demo/features/appointment/presentation/providers/appointment_provider.dart';
import 'package:ally_care_demo/features/assessment/presentation/providers/assessment_provider.dart';
import 'package:ally_care_demo/shared/routes/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _editingName = false;
  String? _nameError;
  bool _sendingReset = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    
    return currentUserAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        }

        _nameController.text = user.firstName;
        final userBookingsAsync = ref.watch(userBookingsProvider(user.id));
        final assessmentsAsync = ref.watch(assessmentsProvider(null));

    return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: AppColors.primaryBlue,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryBlue.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                          // Profile Picture
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement profile picture upload
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile picture upload coming soon!')),
                              );
                            },
                            child: Stack(
            children: [
              CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  backgroundImage: user.photoURL != null
                                      ? CachedNetworkImageProvider(user.photoURL!)
                                      : null,
                                  child: user.photoURL == null
                                      ? Text(
                                          (user.firstName).substring(0, 1).toUpperCase(),
                                          style: AppTypography.h2.copyWith(
                                            color: AppColors.primaryBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: AppColors.success,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Insets.sm),
                          // Name
                    _editingName
                              ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                                  child: TextField(
                            controller: _nameController,
                                    style: AppTypography.h4.copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                      hintText: 'Enter your name',
                                      hintStyle: TextStyle(color: Colors.white70),
                              errorText: _nameError,
                                      errorStyle: TextStyle(color: Colors.red[200]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                                        borderSide: BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                                        borderSide: BorderSide(color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  user.firstName,
                                  style: AppTypography.h4.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          SizedBox(height: Insets.xs),
                          Text(
                            user.email,
                            style: AppTypography.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                  ],
                ),
              ),
                  ),
                ),
                actions: [
              IconButton(
                    icon: Icon(_editingName ? Icons.check : Icons.edit, color: Colors.white),
                onPressed: () async {
                  if (_editingName) {
                    final newName = _nameController.text.trim();
                    if (newName.isEmpty) {
                      setState(() => _nameError = 'Name cannot be empty');
                      return;
                    }
                        setState(() => _isLoading = true);
                        try {
                          await ref.read(authNotifierProvider.notifier).updateUserProfile(
                            displayName: newName,
                          );
                    setState(() {
                      _editingName = false;
                      _nameError = null;
                    });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Name updated successfully!')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error updating name: $e')),
                          );
                        } finally {
                          setState(() => _isLoading = false);
                        }
                  } else {
                    setState(() => _editingName = true);
                  }
                },
              ),
            ],
          ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Cards
                      _buildStatsSection(userBookingsAsync),
                      SizedBox(height: Insets.lg),

                      // Quick Actions
                      _buildQuickActionsSection(),
                      SizedBox(height: Insets.lg),

                      // Recent Appointments
                      _buildRecentAppointmentsSection(userBookingsAsync),
                      SizedBox(height: Insets.lg),

                      // Favorite Assessments
                      _buildFavoriteAssessmentsSection(assessmentsAsync),
                      SizedBox(height: Insets.lg),

                      // Achievements
                      _buildAchievementsSection(),
          SizedBox(height: Insets.lg),

                      // Account Actions
                      _buildAccountActionsSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(AsyncValue userBookingsAsync) {
    return userBookingsAsync.when(
      loading: () => _buildStatsCard(0, 0, 0),
      error: (e, _) => _buildStatsCard(0, 0, 0),
            data: (bookings) {
              final now = DateTime.now();
        final activeBookings = bookings.where((b) => b['status'] != 'cancelled').toList();
        final upcomingBookings = activeBookings.where((b) {
          final slot = b['selectedSlot'];
          DateTime? slotTime;
          if (slot is DateTime) slotTime = slot;
          else if (slot is String) slotTime = DateTime.tryParse(slot);
          else if (slot is Timestamp) slotTime = slot.toDate();
          return slotTime != null && slotTime.isAfter(now);
        }).length;
        final completedBookings = activeBookings.where((b) {
          final slot = b['selectedSlot'];
          DateTime? slotTime;
          if (slot is DateTime) slotTime = slot;
          else if (slot is String) slotTime = DateTime.tryParse(slot);
          else if (slot is Timestamp) slotTime = slot.toDate();
          return slotTime != null && slotTime.isBefore(now);
        }).length;

        return _buildStatsCard(upcomingBookings, completedBookings, activeBookings.length);
      },
    );
  }

  Widget _buildStatsCard(int upcoming, int completed, int total) {
    return Container(
      padding: EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Insets.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowColor(context),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'Upcoming',
              upcoming.toString(),
              Icons.calendar_today,
              AppColors.primaryBlue,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.getDividerColor(context),
          ),
          Expanded(
            child: _buildStatItem(
              'Completed',
              completed.toString(),
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.getDividerColor(context),
          ),
          Expanded(
            child: _buildStatItem(
              'Total',
              total.toString(),
              Icons.assessment,
              AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: Insets.xs),
        Text(
          value,
          style: AppTypography.h5.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.getTextSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.h6.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimaryColor(context),
          ),
        ),
        SizedBox(height: Insets.md),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Book Appointment',
                Icons.calendar_today,
                AppColors.primaryBlue,
                () => context.push(RouteNames.fullAppointments),
              ),
            ),
            SizedBox(width: Insets.md),
            Expanded(
              child: _buildActionCard(
                'Take Assessment',
                Icons.assessment,
                AppColors.success,
                () => context.push(RouteNames.fullAssessments),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Insets.radiusMd),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: Insets.sm),
            Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAppointmentsSection(AsyncValue userBookingsAsync) {
              return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Appointments',
              style: AppTypography.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimaryColor(context),
              ),
            ),
            TextButton(
              onPressed: () => context.push(RouteNames.fullAppointments),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: Insets.md),
        userBookingsAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
          data: (bookings) {
            final activeBookings = bookings
                .where((b) => b['status'] != 'cancelled')
                .take(3)
                .toList();

            if (activeBookings.isEmpty) {
              return Container(
                padding: EdgeInsets.all(Insets.lg),
                decoration: BoxDecoration(
                  color: AppColors.getSurfaceColor(context).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Insets.radiusMd),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 48,
                        color: AppColors.getIconColor(context),
                      ),
                      SizedBox(height: Insets.sm),
                      Text(
                        'No appointments yet',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.getTextSecondaryColor(context),
                        ),
                      ),
                      SizedBox(height: Insets.sm),
                      ElevatedButton(
                        onPressed: () => context.push(RouteNames.fullAppointments),
                        child: Text('Book Your First'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: activeBookings.map<Widget>((booking) {
                final slot = booking['selectedSlot'];
                DateTime? slotTime;
                if (slot is DateTime) slotTime = slot;
                else if (slot is String) slotTime = DateTime.tryParse(slot);
                else if (slot is Timestamp) slotTime = slot.toDate();

                return Card(
                  margin: EdgeInsets.only(bottom: Insets.sm),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                      child: Icon(
                        Icons.calendar_today,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    title: Text(
                      'Appointment',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimaryColor(context),
                      ),
                    ),
                    subtitle: Text(
                      slotTime != null
                          ? '${slotTime.day}/${slotTime.month}/${slotTime.year} at ${slotTime.hour}:${slotTime.minute.toString().padLeft(2, '0')}'
                          : 'Date not available',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.getTextSecondaryColor(context),
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Insets.radiusSm),
                      ),
                      child: Text(
                        booking['status'] ?? 'pending',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFavoriteAssessmentsSection(AsyncValue assessmentsAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Favorite Assessments',
              style: AppTypography.h6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimaryColor(context),
              ),
            ),
            TextButton(
              onPressed: () => context.push(RouteNames.fullAssessments),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: Insets.md),
        FutureBuilder<List<String>>(
          future: _getFavoriteIds(),
          builder: (context, snapshot) {
            final favoriteIds = snapshot.data ?? [];
            
            return assessmentsAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (assessments) {
                final favorites = assessments
                    .where((a) => favoriteIds.contains(a.id))
                    .take(3)
                    .toList();

                if (favorites.isEmpty) {
                  return Container(
                    padding: EdgeInsets.all(Insets.lg),
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceColor(context).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(Insets.radiusMd),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 48,
                            color: AppColors.getIconColor(context),
                          ),
                          SizedBox(height: Insets.sm),
                          Text(
                            'No favorite assessments yet',
                            style: AppTypography.bodyMedium.copyWith(
                              color: AppColors.getTextSecondaryColor(context),
                            ),
                          ),
                          SizedBox(height: Insets.sm),
                          ElevatedButton(
                            onPressed: () => context.push(RouteNames.fullAssessments),
                            child: Text('Explore Assessments'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

              return Column(
                  children: favorites.map<Widget>((assessment) => Card(
                    margin: EdgeInsets.only(bottom: Insets.sm),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.success.withOpacity(0.1),
                        child: Icon(
                          Icons.assessment,
                          color: AppColors.success,
                        ),
                      ),
                      title: Text(
                        assessment.title,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextPrimaryColor(context),
                        ),
                      ),
                      subtitle: Text(
                        assessment.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.getTextSecondaryColor(context),
                        ),
                      ),
                      trailing: Icon(
                        Icons.favorite,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                )).toList(),
              );
            },
            );
          },
        ),
      ],
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: AppTypography.h6.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimaryColor(context),
          ),
        ),
        SizedBox(height: Insets.md),
        Container(
          padding: EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(Insets.radiusMd),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: AppColors.warning,
                size: 32,
              ),
              SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coming Soon!',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                    Text(
                      'Track your progress and earn badges',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAccountActionsSection() {
                  return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: AppTypography.h6.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.getTextPrimaryColor(context),
          ),
        ),
        SizedBox(height: Insets.md),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.settings, color: AppColors.primaryBlue),
                title: Text('Settings'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => context.push(RouteNames.fullSettings),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.lock, color: AppColors.warning),
                title: Text('Change Password'),
                trailing: _sendingReset
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.chevron_right),
                onTap: _sendingReset
                    ? null
                    : () async {
                        setState(() => _sendingReset = true);
                        try {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user?.email != null) {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: user!.email!,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset email sent!'),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $e'),
                            ),
                          );
                        } finally {
                          setState(() => _sendingReset = false);
                        }
                      },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.error),
                title: Text('Sign Out'),
                trailing: Icon(Icons.chevron_right),
                onTap: () async {
                  try {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    context.go(RouteNames.login);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.delete_forever, color: AppColors.error),
                title: Text('Delete Account'),
                subtitle: Text('This action cannot be undone'),
                trailing: Icon(Icons.chevron_right),
                onTap: () => _showDeleteAccountDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final TextEditingController confirmController = TextEditingController();
    bool isDeleting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 28,
                  ),
                  SizedBox(width: Insets.sm),
                  Expanded(
                    child: Text(
                      'Delete Account',
                      style: AppTypography.h6.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This action is irreversible and will permanently delete your account and all associated data.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.getTextPrimaryColor(context),
                    ),
                  ),
                  SizedBox(height: Insets.md),
                  Text(
                    'To confirm deletion, please type "DELETE" in the field below:',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.getTextSecondaryColor(context),
                    ),
                  ),
                  SizedBox(height: Insets.sm),
                  TextField(
                    controller: confirmController,
                    decoration: InputDecoration(
                      hintText: 'Type DELETE to confirm',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Insets.radiusMd),
                        borderSide: BorderSide(color: AppColors.error),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  SizedBox(height: Insets.md),
                  Container(
                    padding: EdgeInsets.all(Insets.md),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(Insets.radiusMd),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                        SizedBox(width: Insets.sm),
                        Expanded(
                          child: Text(
                            'This will log you out immediately after deletion.',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.getTextSecondaryColor(context)),
                  ),
                ),
                ElevatedButton(
                  onPressed: (confirmController.text == 'DELETE' && !isDeleting)
                      ? () async {
                          setState(() => isDeleting = true);
                          
                          // TODO: Implement actual account deletion
                          // For now, just show a message and log out
                          await Future.delayed(Duration(seconds: 2));
                          
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Account deletion feature coming soon!'),
                                backgroundColor: AppColors.warning,
                              ),
                            );
                            
                            // Log out the user
                            try {
                              await ref.read(authNotifierProvider.notifier).signOut();
                              if (context.mounted) {
                                context.go(RouteNames.login);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error signing out: $e')),
                                );
                              }
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  child: isDeleting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Delete Account'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<String>> _getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorite_assessments') ?? [];
  }
}
