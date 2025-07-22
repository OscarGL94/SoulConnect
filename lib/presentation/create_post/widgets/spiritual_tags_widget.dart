import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Spiritual Tags Widget - Selectable spiritual topic chips for post categorization
/// Features: Predefined spiritual interests, custom tag creation, multi-selection
class SpiritualTagsWidget extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const SpiritualTagsWidget({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  State<SpiritualTagsWidget> createState() => _SpiritualTagsWidgetState();
}

class _SpiritualTagsWidgetState extends State<SpiritualTagsWidget> {
  final TextEditingController _customTagController = TextEditingController();
  final FocusNode _customTagFocus = FocusNode();
  bool _showCustomInput = false;

  final List<String> _predefinedTags = [
    'meditation',
    'breathwork',
    'astrology',
    'human design',
    'mindfulness',
    'gratitude',
    'chakras',
    'energy healing',
    'moon cycles',
    'sacred plants',
    'yoga',
    'manifestation',
    'crystal healing',
    'sound healing',
    'tarot',
    'numerology',
    'spiritual awakening',
    'inner peace',
    'self love',
    'divine feminine',
    'sacred masculine',
    'twin flames',
    'soul purpose',
  ];

  @override
  void dispose() {
    _customTagController.dispose();
    _customTagFocus.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    final newTags = List<String>.from(widget.selectedTags);

    if (newTags.contains(tag)) {
      newTags.remove(tag);
    } else {
      if (newTags.length < 5) {
        // Limit to 5 tags
        newTags.add(tag);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum 5 tags allowed'),
          ),
        );
        return;
      }
    }

    widget.onTagsChanged(newTags);
  }

  void _addCustomTag() {
    final customTag = _customTagController.text.trim().toLowerCase();

    if (customTag.isEmpty) return;

    if (customTag.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tag must be 20 characters or less'),
        ),
      );
      return;
    }

    if (widget.selectedTags.contains(customTag) ||
        _predefinedTags.contains(customTag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tag already exists'),
        ),
      );
      return;
    }

    if (widget.selectedTags.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 5 tags allowed'),
        ),
      );
      return;
    }

    final newTags = List<String>.from(widget.selectedTags)..add(customTag);
    widget.onTagsChanged(newTags);

    _customTagController.clear();
    setState(() => _showCustomInput = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spiritual Topics (${widget.selectedTags.length}/5)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton(
              onPressed: () {
                setState(() => _showCustomInput = !_showCustomInput);
                if (_showCustomInput) {
                  _customTagFocus.requestFocus();
                }
              },
              child: Text(_showCustomInput ? 'Cancel' : 'Add Custom'),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Custom Tag Input
        if (_showCustomInput) ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customTagController,
                  focusNode: _customTagFocus,
                  decoration: InputDecoration(
                    hintText: 'Enter custom tag...',
                    prefixIcon: const Icon(Icons.tag),
                    suffixIcon: IconButton(
                      onPressed: _addCustomTag,
                      icon: const Icon(Icons.add),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                  ),
                  onSubmitted: (_) => _addCustomTag(),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],

        // Selected Tags
        if (widget.selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.selectedTags
                .map((tag) => Chip(
                      label: Text('#$tag'),
                      onDeleted: () => _toggleTag(tag),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 2.h),
        ],

        // Predefined Tags
        Text(
          'Popular Topics:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: 1.h),

        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _predefinedTags.map((tag) {
            final isSelected = widget.selectedTags.contains(tag);
            return FilterChip(
              label: Text('#$tag'),
              selected: isSelected,
              onSelected: (_) => _toggleTag(tag),
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              selectedColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
