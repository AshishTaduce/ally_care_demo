import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/typography.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'profile_menu_bottom_sheet.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    return currentUser.when(
      data: (data) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitle("Hello ${data?.firstName ?? "There"}"),

          _buildProfileAvatar(context, ref, currentUser),
        ],
      ),
      error: (error, _) => Row(
        children: [
          // App logo/name
          Text("Hello There"),

          // Profile avatar
          _buildProfileAvatar(context, ref, currentUser),
        ],
      ),
      loading: () => Container(),
    );
  }

  Text _buildTitle(String title) => Text(
    title,
    style: AppTypography.h3.copyWith(color: AppColors.primaryBlue),
  );

  Widget _buildProfileAvatar(
    BuildContext context,
    WidgetRef ref,
    AsyncValue currentUser,
  ) {
    return GestureDetector(
      onTap: () => _showProfileMenu(context, ref),
      child: currentUser.when(
        data: (user) => CircleAvatar(
          radius: 16.r,
          backgroundColor: Colors.transparent,
          child: user?.photoURL == null
              ? _getAvatarPlaceholder()
              : CachedNetworkImage(imageUrl: user!.photoURL!),
        ),
        loading: () => CircleAvatar(
          radius: 16.r,
          backgroundColor: Colors.transparent,
          child: _getAvatarPlaceholder(),
        ),
        error: (error, stack) => CircleAvatar(
          radius: 16.r,
          backgroundColor: Colors.transparent,
          child: _getAvatarPlaceholder(),
        ),
      ),
    );
  }

  SvgPicture _getAvatarPlaceholder() => SvgPicture.asset('assets/images/icons/avatar.svg');

  void _showProfileMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileMenuBottomSheet(ref: ref),
    );
  }
}
