import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Search results preview widget showing match count and insights
class SearchResultsWidget extends StatelessWidget {
  final int resultsCount;
  final bool hasActiveFilters;

  const SearchResultsWidget({
    super.key,
    required this.resultsCount,
    required this.hasActiveFilters,
  });

  String _getResultsText(int count) {
    if (count == 0) {
      return 'No matches found';
    } else if (count == 1) {
      return '1 potential match';
    } else if (count >= 9999) {
      return '9999+ potential matches';
    } else {
      return '$count potential matches';
    }
  }

  List<String> _getSearchInsights(int count, bool hasFilters) {
    List<String> insights = [];

    if (!hasFilters) {
      insights.add('Add filters to refine your search');
    } else if (count == 0) {
      insights.add('Try adjusting your filters for more results');
      insights.add('Consider expanding your distance or age range');
    } else if (count < 10) {
      insights.add('Very specific criteria - great for targeted connections');
    } else if (count < 50) {
      insights.add('Good balance of specificity and options');
    } else if (count < 200) {
      insights.add('Plenty of options to explore');
    } else {
      insights.add('Many potential matches - consider adding more filters');
    }

    return insights;
  }

  Color _getResultsColor(BuildContext context, int count) {
    if (count == 0) {
      return Theme.of(context).colorScheme.error;
    } else if (count < 10) {
      return Colors.orange;
    } else if (count < 50) {
      return Theme.of(context).colorScheme.primary;
    } else {
      return Colors.green;
    }
  }

  IconData _getResultsIcon(int count) {
    if (count == 0) {
      return Icons.search_off;
    } else if (count < 10) {
      return Icons.person_search;
    } else if (count < 50) {
      return Icons.people;
    } else {
      return Icons.groups;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resultsColor = _getResultsColor(context, resultsCount);
    final insights = _getSearchInsights(resultsCount, hasActiveFilters);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Search Preview',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.w),

            // Results count display
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: resultsColor.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: resultsColor.withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: resultsColor,
                    ),
                    child: Icon(
                      _getResultsIcon(resultsCount),
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getResultsText(resultsCount),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: resultsColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          hasActiveFilters
                              ? 'Based on your current filters'
                              : 'All users in your area',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (resultsCount > 0)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: resultsColor,
                      size: 4.w,
                    ),
                ],
              ),
            ),

            SizedBox(height: 4.w),

            // Search insights
            if (insights.isNotEmpty) ...[
              Text(
                'Insights',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              SizedBox(height: 2.w),
              ...insights.map((insight) => Padding(
                    padding: EdgeInsets.only(bottom: 2.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 1.5.w,
                          height: 1.5.w,
                          margin: EdgeInsets.only(top: 1.5.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            insight,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],

            // Real-time update indicator
            if (hasActiveFilters) ...[
              SizedBox(height: 4.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 2.w,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withAlpha(77),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Results update in real-time as you adjust filters',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
