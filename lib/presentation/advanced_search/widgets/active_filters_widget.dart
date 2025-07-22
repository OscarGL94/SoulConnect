import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Active filters widget displaying applied filters as dismissible chips
class ActiveFiltersWidget extends StatelessWidget {
  final List<String> activeFilters;
  final VoidCallback onClearAll;
  final ValueChanged<String> onRemoveFilter;

  const ActiveFiltersWidget({
    super.key,
    required this.activeFilters,
    required this.onClearAll,
    required this.onRemoveFilter,
  });

  @override
  Widget build(BuildContext context) {
    if (activeFilters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                size: 5.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Active Filters',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: onClearAll,
                icon: Icon(
                  Icons.clear_all,
                  size: 4.w,
                ),
                label: const Text('Clear All'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Wrap(
            spacing: 2.w,
            runSpacing: 2.w,
            children: activeFilters
                .map((filter) => Chip(
                      label: Text(
                        filter,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      deleteIcon: Icon(
                        Icons.close,
                        size: 4.w,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onDeleted: () => onRemoveFilter(filter),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
