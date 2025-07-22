import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Spiritual Interests filter widget with expandable categories and multi-select functionality
class SpiritualInterestsFilterWidget extends StatefulWidget {
  final List<String> selectedInterests;
  final ValueChanged<List<String>> onInterestsChanged;

  const SpiritualInterestsFilterWidget({
    super.key,
    required this.selectedInterests,
    required this.onInterestsChanged,
  });

  @override
  State<SpiritualInterestsFilterWidget> createState() =>
      _SpiritualInterestsFilterWidgetState();
}

class _SpiritualInterestsFilterWidgetState
    extends State<SpiritualInterestsFilterWidget> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  static const Map<String, List<String>> _spiritualCategories = {
    'Meditation': [
      'Mindfulness',
      'Transcendental Meditation',
      'Zen',
      'Vipassana',
      'Loving-kindness',
      'Walking Meditation',
    ],
    'Energy Work': [
      'Reiki',
      'Chakra Healing',
      'Crystal Healing',
      'Breathwork',
      'Pranayama',
      'Energy Clearing',
    ],
    'Divination': [
      'Tarot',
      'Oracle Cards',
      'Astrology',
      'Numerology',
      'I Ching',
      'Pendulum',
    ],
    'Personal Development': [
      'Human Design',
      'Enneagram',
      'Shadow Work',
      'Inner Child',
      'Life Coaching',
      'Journaling',
    ],
    'Alternative Healing': [
      'Ayurveda',
      'Traditional Chinese Medicine',
      'Herbalism',
      'Sound Healing',
      'Color Therapy',
      'Aromatherapy',
    ],
    'Sacred Practices': [
      'Yoga',
      'Tai Chi',
      'Qigong',
      'Sacred Plants',
      'Ceremony',
      'Ritual',
    ],
  };

  List<String> _getFilteredInterests() {
    if (_searchQuery.isEmpty) {
      return _spiritualCategories.values.expand((list) => list).toList();
    }

    return _spiritualCategories.values
        .expand((list) => list)
        .where((interest) =>
            interest.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleInterest(String interest) {
    List<String> newInterests = List.from(widget.selectedInterests);

    if (newInterests.contains(interest)) {
      newInterests.remove(interest);
    } else {
      newInterests.add(interest);
    }

    widget.onInterestsChanged(newInterests);
  }

  void _clearAllInterests() {
    widget.onInterestsChanged([]);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  Icons.spa,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Spiritual Interests',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (widget.selectedInterests.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 1.w,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.selectedInterests.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 3.w),

            Text(
              'Select your spiritual interests and practices',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            SizedBox(height: 4.w),

            // Search within interests
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search interests...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            SizedBox(height: 4.w),

            // Quick actions
            if (widget.selectedInterests.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.selectedInterests.length} selected',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  TextButton(
                    onPressed: _clearAllInterests,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: 2.w),

            // Categories with interests
            if (_searchQuery.isEmpty) ...[
              // Show by categories
              ..._spiritualCategories.entries.map((category) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.w),
                        child: Text(
                          category.key,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 2.w,
                        children: category.value.map((interest) {
                          final isSelected =
                              widget.selectedInterests.contains(interest);

                          return FilterChip(
                            label: Text(interest),
                            selected: isSelected,
                            onSelected: (_) => _toggleInterest(interest),
                            selectedColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(51),
                            checkmarkColor:
                                Theme.of(context).colorScheme.primary,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 3.w),
                    ],
                  )),
            ] else ...[
              // Show filtered results
              Wrap(
                spacing: 2.w,
                runSpacing: 2.w,
                children: _getFilteredInterests().map((interest) {
                  final isSelected =
                      widget.selectedInterests.contains(interest);

                  return FilterChip(
                    label: Text(interest),
                    selected: isSelected,
                    onSelected: (_) => _toggleInterest(interest),
                    selectedColor:
                        Theme.of(context).colorScheme.primary.withAlpha(51),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),
            ],

            if (_getFilteredInterests().isEmpty && _searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 12.w,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        'No interests found for "$_searchQuery"',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
