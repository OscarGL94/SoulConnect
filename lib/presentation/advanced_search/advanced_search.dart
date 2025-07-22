import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/active_filters_widget.dart';
import './widgets/age_range_filter_widget.dart';
import './widgets/connection_purpose_widget.dart';
import './widgets/distance_filter_widget.dart';
import './widgets/location_search_widget.dart';
import './widgets/search_results_widget.dart';
import './widgets/spiritual_interests_filter_widget.dart';

/// Advanced Search Screen providing comprehensive filtering capabilities
/// for discovering spiritual connections through refined search parameters.
class AdvancedSearch extends StatefulWidget {
  const AdvancedSearch({super.key});

  @override
  State<AdvancedSearch> createState() => _AdvancedSearchState();
}

class _AdvancedSearchState extends State<AdvancedSearch> {
  // Filter state variables
  double _distanceRange = 50.0;
  String? _selectedConnectionPurpose;
  List<String> _selectedSpiritualInterests = [];
  RangeValues _ageRange = const RangeValues(18, 65);
  String? _selectedLocation;
  bool _useCurrentLocation = true;
  int _resultsCount = 0;
  List<String> _savedSearches = [];

  @override
  void initState() {
    super.initState();
    _updateResultsCount();
  }

  void _updateResultsCount() {
    // Simulate results count based on filters
    setState(() {
      _resultsCount = _calculateResultsCount();
    });
  }

  int _calculateResultsCount() {
    // Mock calculation based on filter restrictiveness
    int baseCount = 1250;

    // Distance filter impact
    if (_distanceRange < 25)
      baseCount ~/= 3;
    else if (_distanceRange < 50) baseCount ~/= 2;

    // Purpose filter impact
    if (_selectedConnectionPurpose != null) baseCount ~/= 1.5;

    // Interests filter impact
    if (_selectedSpiritualInterests.isNotEmpty) {
      baseCount =
          (baseCount * (0.8 - (_selectedSpiritualInterests.length * 0.1)))
              .round();
    }

    // Age range impact
    double ageRangeSize = _ageRange.end - _ageRange.start;
    if (ageRangeSize < 20) baseCount = (baseCount * 0.6).round();

    return baseCount.clamp(0, 9999);
  }

  void _clearAllFilters() {
    setState(() {
      _distanceRange = 50.0;
      _selectedConnectionPurpose = null;
      _selectedSpiritualInterests.clear();
      _ageRange = const RangeValues(18, 65);
      _selectedLocation = null;
      _useCurrentLocation = true;
      _updateResultsCount();
    });
  }

  void _saveCurrentSearch() {
    // Generate search name based on active filters
    String searchName = _generateSearchName();
    if (searchName.isNotEmpty && !_savedSearches.contains(searchName)) {
      setState(() {
        _savedSearches.add(searchName);
      });
      _showSaveSearchDialog(searchName);
    }
  }

  String _generateSearchName() {
    List<String> parts = [];

    if (_selectedConnectionPurpose != null) {
      parts.add(_selectedConnectionPurpose!);
    }

    if (_selectedSpiritualInterests.isNotEmpty) {
      if (_selectedSpiritualInterests.length == 1) {
        parts.add(_selectedSpiritualInterests.first);
      } else {
        parts.add('${_selectedSpiritualInterests.length} interests');
      }
    }

    if (_distanceRange < 50) {
      parts.add('${_distanceRange.round()}km');
    }

    return parts.isEmpty ? 'Custom Search' : parts.join(' • ');
  }

  void _showSaveSearchDialog(String searchName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Search "$searchName" saved successfully'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Navigate to saved searches
          },
        ),
      ),
    );
  }

  void _applyFilters() {
    // Apply filters and navigate to results
    Navigator.pop(context, {
      'distance': _distanceRange,
      'connectionPurpose': _selectedConnectionPurpose,
      'spiritualInterests': _selectedSpiritualInterests,
      'ageRange': _ageRange,
      'location': _selectedLocation,
      'useCurrentLocation': _useCurrentLocation,
      'resultsCount': _resultsCount,
    });
  }

  List<String> _getActiveFiltersList() {
    List<String> filters = [];

    if (_distanceRange != 50.0) {
      filters.add('Distance: ${_distanceRange.round()}km');
    }

    if (_selectedConnectionPurpose != null) {
      filters.add('Purpose: $_selectedConnectionPurpose');
    }

    if (_selectedSpiritualInterests.isNotEmpty) {
      if (_selectedSpiritualInterests.length <= 2) {
        filters.addAll(_selectedSpiritualInterests.map((e) => 'Interest: $e'));
      } else {
        filters
            .add('Interests: ${_selectedSpiritualInterests.length} selected');
      }
    }

    if (_ageRange.start != 18 || _ageRange.end != 65) {
      filters.add('Age: ${_ageRange.start.round()}-${_ageRange.end.round()}');
    }

    if (!_useCurrentLocation && _selectedLocation != null) {
      filters.add('Location: $_selectedLocation');
    }

    return filters;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Advanced Search',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_getActiveFiltersList().isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.bookmark_add_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: _saveCurrentSearch,
              tooltip: 'Save Search',
            ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: _clearAllFilters,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          // Active filters chips
          if (_getActiveFiltersList().isNotEmpty)
            ActiveFiltersWidget(
              activeFilters: _getActiveFiltersList(),
              onClearAll: _clearAllFilters,
              onRemoveFilter: (filter) {
                // Handle individual filter removal
                setState(() {
                  if (filter.startsWith('Distance:')) {
                    _distanceRange = 50.0;
                  } else if (filter.startsWith('Purpose:')) {
                    _selectedConnectionPurpose = null;
                  } else if (filter.startsWith('Interest:')) {
                    String interest = filter.replaceFirst('Interest: ', '');
                    _selectedSpiritualInterests.remove(interest);
                  } else if (filter.startsWith('Interests:')) {
                    _selectedSpiritualInterests.clear();
                  } else if (filter.startsWith('Age:')) {
                    _ageRange = const RangeValues(18, 65);
                  } else if (filter.startsWith('Location:')) {
                    _selectedLocation = null;
                    _useCurrentLocation = true;
                  }
                  _updateResultsCount();
                });
              },
            ),

          // Main content with filters
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance filter with map preview
                  DistanceFilterWidget(
                    currentDistance: _distanceRange,
                    useCurrentLocation: _useCurrentLocation,
                    onDistanceChanged: (value) {
                      setState(() {
                        _distanceRange = value;
                        _updateResultsCount();
                      });
                    },
                    onLocationToggle: (value) {
                      setState(() {
                        _useCurrentLocation = value;
                        if (value) _selectedLocation = null;
                        _updateResultsCount();
                      });
                    },
                  ),

                  SizedBox(height: 6.w),

                  // Connection purpose filter
                  ConnectionPurposeWidget(
                    selectedPurpose: _selectedConnectionPurpose,
                    onPurposeSelected: (purpose) {
                      setState(() {
                        _selectedConnectionPurpose = purpose;
                        _updateResultsCount();
                      });
                    },
                  ),

                  SizedBox(height: 6.w),

                  // Spiritual interests filter
                  SpiritualInterestsFilterWidget(
                    selectedInterests: _selectedSpiritualInterests,
                    onInterestsChanged: (interests) {
                      setState(() {
                        _selectedSpiritualInterests = interests;
                        _updateResultsCount();
                      });
                    },
                  ),

                  SizedBox(height: 6.w),

                  // Age range filter
                  AgeRangeFilterWidget(
                    currentRange: _ageRange,
                    onRangeChanged: (range) {
                      setState(() {
                        _ageRange = range;
                        _updateResultsCount();
                      });
                    },
                  ),

                  SizedBox(height: 6.w),

                  // Location search with global support
                  LocationSearchWidget(
                    selectedLocation: _selectedLocation,
                    useCurrentLocation: _useCurrentLocation,
                    onLocationSelected: (location) {
                      setState(() {
                        _selectedLocation = location;
                        _useCurrentLocation = false;
                        _updateResultsCount();
                      });
                    },
                    onCurrentLocationToggle: (value) {
                      setState(() {
                        _useCurrentLocation = value;
                        if (value) _selectedLocation = null;
                        _updateResultsCount();
                      });
                    },
                  ),

                  SizedBox(height: 8.w),

                  // Results preview
                  SearchResultsWidget(
                    resultsCount: _resultsCount,
                    hasActiveFilters: _getActiveFiltersList().isNotEmpty,
                  ),
                ],
              ),
            ),
          ),

          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearAllFilters,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Clear All'),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _applyFilters,
                      icon: const Icon(Icons.search),
                      label: Text('Show $_resultsCount Results'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
