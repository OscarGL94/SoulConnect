import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/profile_detail/profile_detail.dart';
import '../presentation/matches_list/matches_list.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/chat_conversation/chat_conversation.dart';
import '../presentation/profile_creation/profile_creation.dart';
import '../presentation/community_feed/community_feed.dart';
import '../presentation/create_post/create_post.dart';
import '../presentation/advanced_search/advanced_search.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String profileDetail = '/profile-detail';
  static const String matchesList = '/matches-list';
  static const String profileSettings = '/profile-settings';
  static const String chatConversation = '/chat-conversation';
  static const String profileCreation = '/profile-creation';
  static const String communityFeed = '/community-feed';
  static const String createPost = '/create-post';
  static const String advancedSearch = '/advanced-search';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    profileDetail: (context) => const ProfileDetail(),
    matchesList: (context) => const MatchesList(),
    profileSettings: (context) => const ProfileSettings(),
    chatConversation: (context) => const ChatConversation(),
    profileCreation: (context) => const ProfileCreation(),
    communityFeed: (context) => const CommunityFeed(),
    createPost: (context) => const CreatePost(),
    advancedSearch: (context) => const AdvancedSearch(),
    // TODO: Add your other routes here
  };
}
