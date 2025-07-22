import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class QuestionnaireResponsesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> responses;

  const QuestionnaireResponsesWidget({
    Key? key,
    required this.responses,
  }) : super(key: key);

  @override
  State<QuestionnaireResponsesWidget> createState() =>
      _QuestionnaireResponsesWidgetState();
}

class _QuestionnaireResponsesWidgetState
    extends State<QuestionnaireResponsesWidget> {
  final Set<int> _expandedItems = {};

  @override
  Widget build(BuildContext context) {
    if (widget.responses.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Autoconocimiento',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.responses.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final response = widget.responses[index];
            final isExpanded = _expandedItems.contains(index);

            return Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded
                            ? _expandedItems.remove(index)
                            : _expandedItems.add(index);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              response['question'] as String,
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          CustomIconWidget(
                            iconName:
                                isExpanded ? 'expand_less' : 'expand_more',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 6.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
                      child: Text(
                        response['answer'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
