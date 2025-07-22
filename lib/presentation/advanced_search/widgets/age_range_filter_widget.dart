import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Age range filter widget with dual-slider for precise demographic targeting
class AgeRangeFilterWidget extends StatelessWidget {
  final RangeValues currentRange;
  final ValueChanged<RangeValues> onRangeChanged;

  const AgeRangeFilterWidget({
    super.key,
    required this.currentRange,
    required this.onRangeChanged,
  });

  String _getAgeRangeText(RangeValues range) {
    int startAge = range.start.round();
    int endAge = range.end.round();

    if (startAge == 18 && endAge == 80) {
      return 'Any age';
    } else if (endAge == 80) {
      return '$startAge+ years';
    } else {
      return '$startAge - $endAge years';
    }
  }

  List<String> _getAgeRangeInsights(RangeValues range) {
    int startAge = range.start.round();
    int endAge = range.end.round();
    int rangeSize = endAge - startAge;

    List<String> insights = [];

    if (rangeSize <= 5) {
      insights.add('Very specific age range');
    } else if (rangeSize <= 15) {
      insights.add('Focused age group');
    } else if (rangeSize > 40) {
      insights.add('Broad age range');
    }

    if (startAge >= 50) {
      insights.add('Mature connections');
    } else if (startAge <= 25) {
      insights.add('Young adult focus');
    }

    return insights;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cake,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Age Range',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getAgeRangeText(currentRange),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.w),

            Text(
              'Select your preferred age range for connections',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            SizedBox(height: 4.w),

            // Age range visualization
            Container(
              height: 16.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withAlpha(25),
                          Theme.of(context).colorScheme.primary.withAlpha(51),
                          Theme.of(context).colorScheme.primary.withAlpha(25),
                        ],
                      ),
                    ),
                  ),

                  // Age markers
                  Positioned.fill(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              '${currentRange.start.round()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 8.w,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              '${currentRange.end.round()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.w),

            // Range slider
            RangeSlider(
              values: currentRange,
              min: 18,
              max: 80,
              divisions: 62,
              labels: RangeLabels(
                currentRange.start.round().toString(),
                currentRange.end.round().toString(),
              ),
              onChanged: onRangeChanged,
            ),

            // Age range labels
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '18',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  Text(
                    '80+',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),

            // Age range insights
            if (_getAgeRangeInsights(currentRange).isNotEmpty) ...[
              SizedBox(height: 3.w),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withAlpha(77),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insights,
                          size: 4.w,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Insights',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.w),
                    ...(_getAgeRangeInsights(currentRange).map(
                      (insight) => Padding(
                        padding: EdgeInsets.only(top: 1.w),
                        child: Row(
                          children: [
                            Container(
                              width: 1.w,
                              height: 1.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                insight,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
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
