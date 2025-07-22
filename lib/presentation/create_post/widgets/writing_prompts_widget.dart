import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Writing Prompts Widget - Inspirational prompts to help users start sharing
/// Features: Rotating spiritual prompts, tap-to-use functionality, creative inspiration
class WritingPromptsWidget extends StatefulWidget {
  final Function(String) onPromptSelected;

  const WritingPromptsWidget({
    super.key,
    required this.onPromptSelected,
  });

  @override
  State<WritingPromptsWidget> createState() => _WritingPromptsWidgetState();
}

class _WritingPromptsWidgetState extends State<WritingPromptsWidget> {
  int _currentPromptIndex = 0;
  bool _isExpanded = false;

  final List<String> _spiritualPrompts = [
    "Today I'm grateful for...",
    "My meditation practice taught me...",
    "The universe is showing me...",
    "In my heart, I'm feeling...",
    "My spiritual journey has revealed...",
    "The energy around me feels...",
    "I'm learning to trust...",
    "My soul is calling me to...",
    "The lesson in this moment is...",
    "I'm manifesting...",
    "My intuition is guiding me toward...",
    "The divine is speaking through...",
    "I'm releasing the need to...",
    "My sacred practice today involved...",
    "The moon/stars are reminding me...",
    "I'm honoring my inner wisdom by...",
    "My ancestors are teaching me...",
    "The earth is reflecting back...",
    "I'm embracing the shadow of...",
    "My light is shining through...",
  ];

  void _nextPrompt() {
    setState(() {
      _currentPromptIndex =
          (_currentPromptIndex + 1) % _spiritualPrompts.length;
    });
  }

  void _toggleExpanded() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Writing Inspiration',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const Spacer(),
              IconButton(
                onPressed: _toggleExpanded,
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          if (_isExpanded) ...[
            SizedBox(height: 2.h),

            // Current Prompt
            GestureDetector(
              onTap: () => widget
                  .onPromptSelected(_spiritualPrompts[_currentPromptIndex]),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _spiritualPrompts[_currentPromptIndex],
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Tap to use this prompt',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Prompt Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_currentPromptIndex + 1} of ${_spiritualPrompts.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentPromptIndex = _currentPromptIndex > 0
                              ? _currentPromptIndex - 1
                              : _spiritualPrompts.length - 1;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 4.w,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: _nextPrompt,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 4.w,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentPromptIndex = DateTime.now().millisecond %
                              _spiritualPrompts.length;
                        });
                      },
                      icon: Icon(
                        Icons.shuffle,
                        size: 5.w,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Random prompt',
                    ),
                  ],
                ),
              ],
            ),
          ] else ...[
            SizedBox(height: 1.h),
            Text(
              'Get inspired with spiritual writing prompts',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
