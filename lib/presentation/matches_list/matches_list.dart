import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_button_widget.dart';
import './widgets/match_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/section_header_widget.dart';

class MatchesList extends StatefulWidget {
  const MatchesList({Key? key}) : super(key: key);

  @override
  State<MatchesList> createState() => _MatchesListState();
}

class _MatchesListState extends State<MatchesList>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  FilterType _selectedFilter = FilterType.recentActivity;
  bool _isEditMode = false;
  final Set<String> _selectedMatches = {};

  // Mock data for matches
  final List<Map<String, dynamic>> _allMatches = [
    {
      "id": "1",
      "spiritualName": "Luna Sagrada",
      "profileImage":
          "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mutualInterests": 5,
      "lastMessage":
          "Me encanta tu perspectiva sobre la meditación mindfulness",
      "lastMessageTime": DateTime.now().subtract(Duration(minutes: 15)),
      "hasUnreadMessages": true,
      "isNewMatch": true,
      "connectionType": "romance",
      "spiritualCompatibility": 0.95,
    },
    {
      "id": "2",
      "spiritualName": "Alma Libre",
      "profileImage":
          "https://images.pixabay.com/photo/2016/11/29/13/14/attractive-1869761_960_720.jpg",
      "mutualInterests": 3,
      "lastMessage":
          "¿Has probado alguna vez el breathwork con plantas sagradas?",
      "lastMessageTime": DateTime.now().subtract(Duration(hours: 2)),
      "hasUnreadMessages": false,
      "isNewMatch": false,
      "connectionType": "spiritual",
      "spiritualCompatibility": 0.87,
    },
    {
      "id": "3",
      "spiritualName": "Corazón Abierto",
      "profileImage":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80",
      "mutualInterests": 7,
      "lastMessage": "Tu energía divina femenina resuena profundamente conmigo",
      "lastMessageTime": DateTime.now().subtract(Duration(hours: 5)),
      "hasUnreadMessages": true,
      "isNewMatch": false,
      "connectionType": "friendship",
      "spiritualCompatibility": 0.92,
    },
    {
      "id": "4",
      "spiritualName": "Sendero Místico",
      "profileImage":
          "https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400",
      "mutualInterests": 4,
      "lastMessage": "¿Te gustaría hacer una sesión de tarot juntos?",
      "lastMessageTime": DateTime.now().subtract(Duration(days: 1)),
      "hasUnreadMessages": false,
      "isNewMatch": false,
      "connectionType": "collaboration",
      "spiritualCompatibility": 0.78,
    },
    {
      "id": "5",
      "spiritualName": "Estrella Dorada",
      "profileImage":
          "https://images.pixabay.com/photo/2017/05/31/04/59/beautiful-2358414_960_720.jpg",
      "mutualInterests": 6,
      "lastMessage": "",
      "lastMessageTime": DateTime.now().subtract(Duration(days: 2)),
      "hasUnreadMessages": false,
      "isNewMatch": true,
      "connectionType": "romance",
      "spiritualCompatibility": 0.89,
    },
  ];

  List<Map<String, dynamic>> get _filteredMatches {
    List<Map<String, dynamic>> filtered = _allMatches;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((match) {
        final name = (match['spiritualName'] as String).toLowerCase();
        return name.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply sorting
    switch (_selectedFilter) {
      case FilterType.recentActivity:
        filtered.sort((a, b) {
          final aTime = a['lastMessageTime'] as DateTime;
          final bTime = b['lastMessageTime'] as DateTime;
          return bTime.compareTo(aTime);
        });
        break;
      case FilterType.spiritualCompatibility:
        filtered.sort((a, b) {
          final aCompat = a['spiritualCompatibility'] as double;
          final bCompat = b['spiritualCompatibility'] as double;
          return bCompat.compareTo(aCompat);
        });
        break;
      case FilterType.connectionType:
        filtered.sort((a, b) {
          final aType = a['connectionType'] as String;
          final bType = b['connectionType'] as String;
          return aType.compareTo(bType);
        });
        break;
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _newMatches {
    return _filteredMatches
        .where((match) => match['isNewMatch'] == true)
        .toList();
  }

  List<Map<String, dynamic>> get _recentConversations {
    return _filteredMatches
        .where((match) =>
            match['isNewMatch'] != true &&
            (match['lastMessage'] as String).isNotEmpty)
        .toList();
  }

  List<Map<String, dynamic>> get _archivedMatches {
    return []; // Empty for now, would be populated from archived matches
  }

  int get _unreadCount {
    return _allMatches
        .where((match) => match['hasUnreadMessages'] == true)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(
            child: _filteredMatches.isEmpty && _searchQuery.isNotEmpty
                ? _buildSearchEmptyState()
                : _allMatches.isEmpty
                    ? _buildEmptyState()
                    : _buildMatchesList()));
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        title: _isEditMode
            ? Text('${_selectedMatches.length} seleccionados',
                style: AppTheme.lightTheme.textTheme.titleMedium)
            : Row(children: [
                Text('Conexiones',
                    style: AppTheme.lightTheme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (_unreadCount > 0) ...[
                  SizedBox(width: 2.w),
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Text(_unreadCount.toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                                  color: AppTheme.onPrimaryLight,
                                  fontWeight: FontWeight.w600))),
                ],
              ]),
        actions: [
          if (_isEditMode) ...[
            TextButton(
                onPressed: () {
                  setState(() {
                    _isEditMode = false;
                    _selectedMatches.clear();
                  });
                },
                child: Text('Cancelar',
                    style: AppTheme.lightTheme.textTheme.bodyMedium
                        ?.copyWith(color: AppTheme.primaryLight))),
          ] else ...[
            FilterButtonWidget(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                }),
          ],
        ]);
  }

  Widget _buildMatchesList() {
    return RefreshIndicator(
        onRefresh: _refreshMatches,
        color: AppTheme.primaryLight,
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: SearchBarWidget(onSearchChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          })),
          if (_newMatches.isNotEmpty) ...[
            SliverToBoxAdapter(
                child: SectionHeaderWidget(
                    title: 'Nuevas Conexiones', count: _newMatches.length)),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMatchCard(_newMatches[index]),
                    childCount: _newMatches.length)),
          ],
          if (_recentConversations.isNotEmpty) ...[
            SliverToBoxAdapter(
                child: SectionHeaderWidget(
                    title: 'Conversaciones Recientes',
                    count: _recentConversations.length)),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildMatchCard(_recentConversations[index]),
                    childCount: _recentConversations.length)),
          ],
          if (_archivedMatches.isNotEmpty) ...[
            SliverToBoxAdapter(
                child: SectionHeaderWidget(
                    title: 'Archivadas',
                    count: _archivedMatches.length,
                    actionText: 'Ver todas',
                    onActionTap: () {
                      // Navigate to archived matches
                    })),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildMatchCard(_archivedMatches[index]),
                    childCount: _archivedMatches.length > 3
                        ? 3
                        : _archivedMatches.length)),
          ],
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        ]));
  }

  Widget _buildMatchCard(Map<String, dynamic> matchData) {
    final isSelected = _selectedMatches.contains(matchData['id']);

    return Stack(children: [
      MatchCardWidget(
          matchData: matchData,
          onTap: () {
            if (_isEditMode) {
              _toggleSelection(matchData['id']);
            } else {
              Navigator.pushNamed(context, '/chat-conversation');
            }
          },
          onArchive: () => _archiveMatch(matchData['id']),
          onQuickMessage: () => _showQuickMessageOptions(matchData)),
      if (_isEditMode)
        Positioned(
            top: 2.h,
            right: 6.w,
            child: GestureDetector(
                onTap: () => _toggleSelection(matchData['id']),
                child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryLight
                            : Colors.transparent,
                        border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : AppTheme.borderLight,
                            width: 2),
                        borderRadius: BorderRadius.circular(4)),
                    child: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.onPrimaryLight,
                            size: 4.w)
                        : null))),
    ]);
  }

  Widget _buildEmptyState() {
    return EmptyStateWidget(
        title: 'Comienza tu viaje espiritual',
        subtitle:
            'Descubre almas afines que comparten tu camino de crecimiento personal y conexión espiritual.',
        actionText: 'Explorar conexiones',
        onActionTap: () {
          // Navigate to discovery/swipe screen
        },
        iconName: 'favorite_border');
  }

  Widget _buildSearchEmptyState() {
    return EmptyStateWidget(
        title: 'Sin resultados',
        subtitle:
            'No encontramos conexiones que coincidan con "$_searchQuery". Intenta con otro nombre espiritual.',
        iconName: 'search_off');
  }

  void _toggleSelection(String matchId) {
    setState(() {
      if (_selectedMatches.contains(matchId)) {
        _selectedMatches.remove(matchId);
      } else {
        _selectedMatches.add(matchId);
      }
    });
  }

  void _archiveMatch(String matchId) {
    setState(() {
      _allMatches.removeWhere((match) => match['id'] == matchId);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Conexión archivada'),
        action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              // Restore match logic
            })));
  }

  void _showQuickMessageOptions(Map<String, dynamic> matchData) {
    final List<String> quickMessages = [
      "¡Hola! Me encanta tu energía espiritual ✨",
      "¿Te gustaría compartir una meditación juntos? 🧘‍♀️",
      "Tu perfil resuena profundamente conmigo 💫",
      "¿Qué prácticas espirituales te nutren más? 🌙",
    ];

    showModalBottomSheet(
        context: context,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) => Container(
            padding: EdgeInsets.all(4.w),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                      color: AppTheme.borderLight,
                      borderRadius: BorderRadius.circular(2))),
              SizedBox(height: 3.h),
              Text('Mensaje rápido para ${matchData['spiritualName']}',
                  style: AppTheme.lightTheme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SizedBox(height: 2.h),
              ...quickMessages.map((message) => ListTile(
                  title: Text(message,
                      style: AppTheme.lightTheme.textTheme.bodyMedium),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/chat-conversation');
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)))),
              SizedBox(height: 2.h),
            ])));
  }

  Future<void> _refreshMatches() async {
    // Simulate network refresh
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // Update match data, refresh timestamps, etc.
    });
  }
}
