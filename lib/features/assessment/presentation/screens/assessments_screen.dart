import 'package:ally_care_demo/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/presentation/widgets/assessment_card.dart';
import '../providers/assessment_provider.dart';
import '../../../../shared/widgets/search_bar.dart' as custom;
import '../../../../core/theme/insets.dart';

class AssessmentsScreen extends ConsumerStatefulWidget {
  const AssessmentsScreen({super.key});

  @override
  ConsumerState<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends ConsumerState<AssessmentsScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  void _loadMore() async {
    setState(() => _isLoadingMore = true);
    if (_searchQuery.isEmpty) {
      await ref.read(paginatedAssessmentsProvider.notifier).fetchNext();
    } else {
      await ref
          .read(paginatedAssessmentSearchProvider.notifier)
          .searchNext(query: _searchQuery);
    }
    setState(() => _isLoadingMore = false);
  }

  void _onSearchChanged(String query) async {
    setState(() => _searchQuery = query);
    if (query.isEmpty) {
      await ref.refresh(paginatedAssessmentsProvider.notifier).fetchNext();
    } else {
      await ref
          .refresh(paginatedAssessmentSearchProvider.notifier)
          .searchNext(query: query);
    }
  }

  void _showFilterDialog() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        selectedCategory: _selectedCategory,
      ),
    );
    if (result != null) {
      setState(() {
        _selectedCategory = result['category'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final assessments = _searchQuery.isEmpty
        ? ref.watch(paginatedAssessmentsProvider)
        : ref.watch(paginatedAssessmentSearchProvider);
    final hasMore = _searchQuery.isEmpty
        ? ref.read(paginatedAssessmentsProvider.notifier).hasMore
        : ref.read(paginatedAssessmentSearchProvider.notifier).hasMore;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (_searchQuery.isEmpty) {
              ref.invalidate(paginatedAssessmentsProvider);
            } else {
              ref.invalidate(paginatedAssessmentSearchProvider);
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                automaticallyImplyLeading: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                titleSpacing: 0,
                elevation: 0,
                centerTitle: false,
                title: Text(
                  'All Assessments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.filter_alt_outlined),
                    onPressed: _showFilterDialog,
                  ),
                ],
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchBarSliverDelegate(
                  child: custom.SearchBar(
                    onChanged: _onSearchChanged,
                    hintText: 'Search assessments...',
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(Insets.md),
                sliver: assessments.when(
                  data: (items) {
                    // Filter by category
                    final filteredItems = _selectedCategory == 'All' 
                        ? items 
                        : items.where((item) => item.category == _selectedCategory).toList();
                    
                    if (filteredItems.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(child: Text('No assessments found.')),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == filteredItems.length) {
                          return hasMore
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.grey400,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(Insets.radiusMd))
                          ),
                          margin: EdgeInsets.only(bottom: Insets.md),
                          child: AssessmentCard(assessment: filteredItems[index]),
                        );
                      }, childCount: filteredItems.length + (hasMore ? 1 : 0)),
                    );
                  },
                  loading: () => SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, st) => SliverFillRemaining(
                    child: Center(child: Text('Error: $e')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  const _FilterBottomSheet({super.key, required this.selectedCategory});
  @override
  State<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String _category = 'All';
  
  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
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
                    'Filter Assessments',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _category = 'All';
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
                // Category Filter
                Text(
                  'Assessment Category',
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
                      value: _category,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.grey600),
                      items: [
                        {'value': 'All', 'label': 'All Categories', 'icon': Icons.all_inclusive},
                        {'value': 'Physical', 'label': 'Physical', 'icon': Icons.fitness_center},
                        {'value': 'Mental', 'label': 'Mental', 'icon': Icons.psychology},
                        {'value': 'Nutrition', 'label': 'Nutrition', 'icon': Icons.restaurant},
                        {'value': 'Lifestyle', 'label': 'Lifestyle', 'icon': Icons.home},
                      ].map((item) => DropdownMenuItem<String>(
                        value: item['value'] as String,
                        child: Row(
                          children: [
                            Icon(
                              item['icon'] as IconData,
                              color: _category == item['value'] ? AppColors.primaryBlue : AppColors.grey600,
                              size: 18,
                            ),
                            SizedBox(width: Insets.sm),
                            Text(
                              item['label'] as String,
                              style: TextStyle(
                                color: _category == item['value'] ? AppColors.primaryBlue : AppColors.grey600,
                                fontWeight: _category == item['value'] ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                      onChanged: (val) => setState(() => _category = val ?? 'All'),
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
                    onPressed: () => Navigator.pop(context, {'category': _category}),
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

class _SearchBarSliverDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SearchBarSliverDelegate({required this.child});

  @override
  double get minExtent => 64;
  @override
  double get maxExtent => 64;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
