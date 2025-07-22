import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

enum FilterType {
  recentActivity,
  spiritualCompatibility,
  connectionType,
}

class FilterButtonWidget extends StatelessWidget {
  final FilterType selectedFilter;
  final Function(FilterType) onFilterChanged;

  const FilterButtonWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFilterOptions(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppTheme.borderLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.primaryLight,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              _getFilterText(selectedFilter),
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 1.w),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.primaryLight,
              size: 4.w,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Ordenar por',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildFilterOption(
              context,
              FilterType.recentActivity,
              'Actividad reciente',
              'Los más activos primero',
            ),
            _buildFilterOption(
              context,
              FilterType.spiritualCompatibility,
              'Compatibilidad espiritual',
              'Mayor afinidad primero',
            ),
            _buildFilterOption(
              context,
              FilterType.connectionType,
              'Tipo de conexión',
              'Por propósito de conexión',
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    FilterType filterType,
    String title,
    String subtitle,
  ) {
    final bool isSelected = selectedFilter == filterType;

    return ListTile(
      leading: CustomIconWidget(
        iconName:
            isSelected ? 'radio_button_checked' : 'radio_button_unchecked',
        color: isSelected ? AppTheme.primaryLight : AppTheme.textDisabledLight,
        size: 6.w,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppTheme.primaryLight : AppTheme.textPrimaryLight,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondaryLight,
        ),
      ),
      onTap: () {
        onFilterChanged(filterType);
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _getFilterText(FilterType filter) {
    switch (filter) {
      case FilterType.recentActivity:
        return 'Recientes';
      case FilterType.spiritualCompatibility:
        return 'Compatibilidad';
      case FilterType.connectionType:
        return 'Tipo';
    }
  }
}
