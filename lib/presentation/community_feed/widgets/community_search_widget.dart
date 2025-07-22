import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Community Search Widget - Search functionality for discovering posts by topics/hashtags
/// Features: Search bar with spiritual topic suggestions and hashtag support
class CommunitySearchWidget extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onFilterTap;

  const CommunitySearchWidget({
    super.key,
    required this.onSearch,
    required this.onFilterTap,
  });

  @override
  State<CommunitySearchWidget> createState() => _CommunitySearchWidgetState();
}

class _CommunitySearchWidgetState extends State<CommunitySearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  final List<String> _spiritualSuggestions = [
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
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              // Search Icon
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),

              // Search Input
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Search spiritual topics, hashtags...',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      widget.onSearch(value.trim());
                      _focusNode.unfocus();
                    }
                  },
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild for suggestions
                  },
                ),
              ),

              // Filter Button
              GestureDetector(
                onTap: widget.onFilterTap,
                child: Container(
                  margin: EdgeInsets.only(right: 2.w),
                  padding: EdgeInsets.all(2.w),
                  child: Icon(
                    Icons.tune,
                    color: Theme.of(context).colorScheme.primary,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Suggestions
        if (_showSuggestions && _searchController.text.length < 2) ...[
          _buildSuggestions(),
        ],
      ],
    );
  }

  Widget _buildSuggestions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      constraints: BoxConstraints(maxHeight: 25.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: 1.h),
        itemCount: _spiritualSuggestions.length,
        itemBuilder: (context, index) {
          final suggestion = _spiritualSuggestions[index];
          return ListTile(
            dense: true,
            leading: Icon(
              Icons.tag,
              color: Theme.of(context).colorScheme.primary,
              size: 4.w,
            ),
            title: Text(
              suggestion,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              _searchController.text = suggestion;
              widget.onSearch(suggestion);
              _focusNode.unfocus();
            },
          );
        },
      ),
    );
  }
}
