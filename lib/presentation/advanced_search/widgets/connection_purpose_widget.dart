import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Connection Purpose filter widget displaying selectable cards with spiritual iconography
class ConnectionPurposeWidget extends StatelessWidget {
  final String? selectedPurpose;
  final ValueChanged<String?> onPurposeSelected;

  const ConnectionPurposeWidget({
    super.key,
    required this.selectedPurpose,
    required this.onPurposeSelected,
  });

  static const List<Map<String, dynamic>> _connectionPurposes = [
    {
      'title': 'Friendship',
      'subtitle': 'Spiritual companionship & support',
      'icon': Icons.people_outline,
      'color': Colors.amber,
    },
    {
      'title': 'Love',
      'subtitle': 'Romantic spiritual partnership',
      'icon': Icons.favorite_border,
      'color': Colors.pink,
    },
    {
      'title': 'Mentorship',
      'subtitle': 'Spiritual guidance & learning',
      'icon': Icons.school_outlined,
      'color': Colors.purple,
    },
    {
      'title': 'Practice Partner',
      'subtitle': 'Joint meditation & rituals',
      'icon': Icons.self_improvement_outlined,
      'color': Colors.teal,
    },
  ];

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
                  Icons.connect_without_contact,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Connection Purpose',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (selectedPurpose != null)
                  TextButton(
                    onPressed: () => onPurposeSelected(null),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 3.w),

            Text(
              'What type of spiritual connection are you seeking?',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            SizedBox(height: 4.w),

            // Purpose cards grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.w,
                childAspectRatio: 1.2,
              ),
              itemCount: _connectionPurposes.length,
              itemBuilder: (context, index) {
                final purpose = _connectionPurposes[index];
                final isSelected = selectedPurpose == purpose['title'];

                return InkWell(
                  onTap: () {
                    onPurposeSelected(
                      isSelected ? null : purpose['title'] as String,
                    );
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withAlpha(77),
                        width: isSelected ? 2 : 1,
                      ),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withAlpha(25)
                          : Theme.of(context).colorScheme.surface,
                    ),
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : (purpose['color'] as Color).withAlpha(51),
                          ),
                          child: Icon(
                            purpose['icon'] as IconData,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : purpose['color'] as Color,
                            size: 6.w,
                          ),
                        ),
                        SizedBox(height: 2.w),
                        Text(
                          purpose['title'] as String,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          purpose['subtitle'] as String,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
