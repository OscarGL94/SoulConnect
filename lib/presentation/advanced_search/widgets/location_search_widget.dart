import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:country_picker/country_picker.dart';
import 'package:geocoding/geocoding.dart';

/// Location search widget enabling global city/country selection with autocomplete
class LocationSearchWidget extends StatefulWidget {
  final String? selectedLocation;
  final bool useCurrentLocation;
  final ValueChanged<String> onLocationSelected;
  final ValueChanged<bool> onCurrentLocationToggle;

  const LocationSearchWidget({
    super.key,
    required this.selectedLocation,
    required this.useCurrentLocation,
    required this.onLocationSelected,
    required this.onCurrentLocationToggle,
  });

  @override
  State<LocationSearchWidget> createState() => _LocationSearchWidgetState();
}

class _LocationSearchWidgetState extends State<LocationSearchWidget> {
  final TextEditingController _locationController = TextEditingController();
  final FocusNode _locationFocus = FocusNode();
  List<String> _locationSuggestions = [];
  bool _isSearching = false;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    if (widget.selectedLocation != null) {
      _locationController.text = widget.selectedLocation!;
    }
  }

  Future<void> _searchLocations(String query) async {
    if (query.length < 2) {
      setState(() {
        _locationSuggestions = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      List<Location> locations = await locationFromAddress(query);
      List<String> suggestions = [];

      for (Location location in locations.take(5)) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          String suggestion = _formatPlacemark(place);
          if (suggestion.isNotEmpty && !suggestions.contains(suggestion)) {
            suggestions.add(suggestion);
          }
        }
      }

      setState(() {
        _locationSuggestions = suggestions;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _locationSuggestions = [];
        _isSearching = false;
      });
    }
  }

  String _formatPlacemark(Placemark placemark) {
    List<String> parts = [];

    if (placemark.locality?.isNotEmpty == true) {
      parts.add(placemark.locality!);
    }
    if (placemark.administrativeArea?.isNotEmpty == true) {
      parts.add(placemark.administrativeArea!);
    }
    if (placemark.country?.isNotEmpty == true) {
      parts.add(placemark.country!);
    }

    return parts.join(', ');
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _locationController.text = country.name;
        });
        widget.onLocationSelected(country.name);
      },
    );
  }

  void _selectLocation(String location) {
    setState(() {
      _locationController.text = location;
      _locationSuggestions = [];
    });
    widget.onLocationSelected(location);
    _locationFocus.unfocus();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _locationFocus.dispose();
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
                  Icons.public,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Location',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (!widget.useCurrentLocation &&
                    widget.selectedLocation != null)
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
                      'Custom',
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
              'Search for any city or country worldwide',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            SizedBox(height: 4.w),

            // Current location toggle
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: widget.useCurrentLocation
                    ? Theme.of(context).colorScheme.primary.withAlpha(25)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.useCurrentLocation
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.my_location,
                    color: widget.useCurrentLocation
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use Current Location',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: widget.useCurrentLocation
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                    fontWeight: widget.useCurrentLocation
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                        ),
                        SizedBox(height: 1.w),
                        Text(
                          'Automatically detect your location',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.useCurrentLocation,
                    onChanged: widget.onCurrentLocationToggle,
                  ),
                ],
              ),
            ),

            if (!widget.useCurrentLocation) ...[
              SizedBox(height: 4.w),

              // Quick country selection
              OutlinedButton.icon(
                onPressed: _selectCountry,
                icon: _selectedCountry != null
                    ? Text(
                        _selectedCountry!.flagEmoji,
                        style: const TextStyle(fontSize: 20),
                      )
                    : const Icon(Icons.flag),
                label: Text(
                  _selectedCountry?.name ?? 'Select Country',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),

              SizedBox(height: 4.w),

              // Manual location input
              Column(
                children: [
                  TextField(
                    controller: _locationController,
                    focusNode: _locationFocus,
                    decoration: InputDecoration(
                      hintText: 'Type city, state, or country...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: Padding(
                                padding: EdgeInsets.all(3.w),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            )
                          : _locationController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _locationController.clear();
                                      _locationSuggestions = [];
                                      _selectedCountry = null;
                                    });
                                    widget.onLocationSelected('');
                                  },
                                )
                              : null,
                    ),
                    onChanged: (value) {
                      _searchLocations(value);
                    },
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        widget.onLocationSelected(value);
                      }
                    },
                  ),

                  // Location suggestions
                  if (_locationSuggestions.isNotEmpty) ...[
                    SizedBox(height: 2.w),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .outline
                              .withAlpha(77),
                        ),
                      ),
                      child: Column(
                        children: _locationSuggestions
                            .map(
                              (suggestion) => ListTile(
                                leading: Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                title: Text(
                                  suggestion,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                onTap: () => _selectLocation(suggestion),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ],

            // Selected location display
            if (!widget.useCurrentLocation &&
                widget.selectedLocation?.isNotEmpty == true) ...[
              SizedBox(height: 4.w),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Location',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            widget.selectedLocation!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
