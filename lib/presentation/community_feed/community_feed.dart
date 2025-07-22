import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/community_filter_tabs_widget.dart';
import './widgets/community_guidelines_widget.dart';
import './widgets/post_card_widget.dart';

/// Community Feed Screen - Central hub for spiritual content sharing and engagement
/// Features: Vertical scrolling feed, post interactions, filter tabs, search functionality
/// Responsive design with proper vertical scrolling for all device sizes
class CommunityFeed extends StatefulWidget {
  const CommunityFeed({super.key});

  @override
  State<CommunityFeed> createState() => _CommunityFeedState();
}

class _CommunityFeedState extends State<CommunityFeed>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  // Mock data for posts - replace with actual data service
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = false;
  bool _hasMorePosts = true;
  String _selectedFilter = 'Recent';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadInitialPosts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMorePosts) {
      _loadMorePosts();
    }
  }

  Future<void> _loadInitialPosts() async {
    setState(() => _isLoading = true);

    // Simulate API call - replace with actual service
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _posts = _generateMockPosts();
      _isLoading = false;
    });
  }

  Future<void> _loadMorePosts() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Simulate API call for more posts
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _posts.addAll(_generateMockPosts(startIndex: _posts.length));
      _isLoading = false;

      // Simulate end of posts after 20 items
      if (_posts.length >= 20) {
        _hasMorePosts = false;
      }
    });
  }

  Future<void> _refreshFeed() async {
    setState(() {
      _posts.clear();
      _hasMorePosts = true;
    });
    await _loadInitialPosts();
  }

  List<Map<String, dynamic>> _generateMockPosts({int startIndex = 0}) {
    final List<String> spiritualContent = [
      "Today's meditation reminded me that we are all interconnected souls on this beautiful journey. Sending love and light to everyone ✨",
      "The sunrise this morning filled my heart with such gratitude. Nature is truly our greatest teacher 🌅",
      "Had an incredible breathwork session today. The healing power of conscious breathing never ceases to amaze me 💚",
      "Reflecting on how Human Design has transformed my understanding of authentic living. We're all here for a unique purpose 🌟",
      "Moon ceremony last night was pure magic. The divine feminine energy was so strong 🌙✨",
      "Sharing some wisdom from my astrology reading today: Trust the cosmic timing, everything unfolds as it should 🔮",
    ];

    final List<String> userNames = [
      "Luna Starlight",
      "River Moonstone",
      "Sage Willow",
      "Aurora Phoenix",
      "Ocean Mystic",
      "Forest Spirit"
    ];

    final List<String> profileImages = [
      "https://images.unsplash.com/photo-1494790108755-2616c27de7d9?w=150&h=150&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1489424731084-a5d8b219a5bb?w=150&h=150&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150&h=150&fit=crop&crop=face",
      "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=150&h=150&fit=crop&crop=face",
    ];

    return List.generate(6, (index) {
      final actualIndex = startIndex + index;
      return {
        'id': 'post_$actualIndex',
        'userId': 'user_${actualIndex % userNames.length}',
        'userName': userNames[actualIndex % userNames.length],
        'userAvatar': profileImages[actualIndex % profileImages.length],
        'content': spiritualContent[actualIndex % spiritualContent.length],
        'timestamp': DateTime.now().subtract(Duration(hours: actualIndex)),
        'reactions': {
          'gratitude': actualIndex % 3 == 0 ? actualIndex + 5 : 0,
          'love': actualIndex % 2 == 0 ? actualIndex + 3 : 0,
          'light': actualIndex % 4 == 0 ? actualIndex + 7 : 0,
        },
        'commentsCount': actualIndex % 5 + 1,
        'hasImage': actualIndex % 3 == 0,
        'imageUrl': actualIndex % 3 == 0
            ? 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=400&fit=crop'
            : null,
        'hasVideo': false,
        'videoUrl': null,
        'spiritualTags': ['meditation', 'mindfulness', 'gratitude'],
        'isUserPost': actualIndex % 7 == 0,
      };
    });
  }

  void _onFilterChanged(String filter) {
    setState(() => _selectedFilter = filter);
    // Implement filter logic here
    _refreshFeed();
  }

  void _onSearchPressed() {
    // Implement search functionality
    showSearch(
      context: context,
      delegate: CommunitySearchDelegate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Community',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _onSearchPressed,
            icon: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Community Guidelines Banner (subtle reminder)
          const CommunityGuidelinesWidget(),

          // Filter Tabs
          CommunityFilterTabsWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: _onFilterChanged,
          ),

          // Posts Feed with Refresh
          Expanded(
            child: RefreshIndicator(
              key: _refreshKey,
              onRefresh: _refreshFeed,
              color: Theme.of(context).colorScheme.primary,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index < _posts.length) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 3.h),
                              child: PostCardWidget(
                                post: _posts[index],
                                onReaction: (postId, reaction) =>
                                    _handleReaction(postId, reaction),
                                onComment: (postId) => _handleComment(postId),
                                onSave: (postId) => _handleSave(postId),
                                onReport: (postId) => _handleReport(postId),
                                onUserTap: (userId) => _handleUserTap(userId),
                              ),
                            );
                          } else if (_isLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (!_hasMorePosts) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.all(4.h),
                                child: Text(
                                  'You\'ve reached the end of the spiritual journey for now ✨',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        childCount: _posts.length + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createPost);
        },
        child: const Icon(Icons.add),
        tooltip: 'Create Post',
      ),
    );
  }

  void _handleReaction(String postId, String reaction) {
    // Implement reaction logic
    setState(() {
      final postIndex = _posts.indexWhere((post) => post['id'] == postId);
      if (postIndex != -1) {
        final reactions =
            _posts[postIndex]['reactions'] as Map<String, dynamic>;
        reactions[reaction] = (reactions[reaction] ?? 0) + 1;
      }
    });
  }

  void _handleComment(String postId) {
    // Navigate to comments screen or show bottom sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Comments',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: 5, // Mock comments
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=40&h=40&fit=crop&crop=face',
                      ),
                    ),
                    title: Text('Soul Sister ${index + 1}'),
                    subtitle: Text(
                        'Beautiful reflection! Thank you for sharing your light ✨'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSave(String postId) {
    // Implement save post logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Post saved to your collection'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleReport(String postId) {
    // Show report dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text(
            'Are you sure you want to report this post for violating community guidelines?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Post reported. Thank you for helping keep our community safe.')),
              );
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _handleUserTap(String userId) {
    // Navigate to user profile
    Navigator.pushNamed(context, AppRoutes.profileDetail, arguments: userId);
  }
}

// Search delegate for community posts
class CommunitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, ''),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results
    return const Center(
      child: Text('Search results will appear here'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = [
      'meditation',
      'breathwork',
      'astrology',
      'human design',
      'mindfulness',
      'gratitude',
    ];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.search),
        title: Text(suggestions[index]),
        onTap: () {
          query = suggestions[index];
          showResults(context);
        },
      ),
    );
  }
}
