import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:geolocator/geolocator.dart';

/// Distance filter widget with interactive map preview and radius slider
class DistanceFilterWidget extends StatefulWidget {
  final double currentDistance;
  final bool useCurrentLocation;
  final ValueChanged<double> onDistanceChanged;
  final ValueChanged<bool> onLocationToggle;

  const DistanceFilterWidget({
    super.key,
    required this.currentDistance,
    required this.useCurrentLocation,
    required this.onDistanceChanged,
    required this.onLocationToggle,
  });

  @override
  State<DistanceFilterWidget> createState() => _DistanceFilterWidgetState();
}

class _DistanceFilterWidgetState extends State<DistanceFilterWidget> {
  Position? _currentPosition;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.useCurrentLocation) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  String _getDistanceLabel(double distance) {
    if (distance >= 1000) {
      return 'Global';
    } else if (distance >= 100) {
      return '${distance.round()}+ km';
    } else {
      return '${distance.round()} km';
    }
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
                  Icons.location_on,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Distance',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getDistanceLabel(widget.currentDistance),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.w),

            // Map preview placeholder with radius visualization
            Container(
              height: 40.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary.withAlpha(25),
                          Theme.of(context).colorScheme.surface,
                        ],
                      ),
                    ),
                  ),

                  // Center point and radius visualization
                  Center(
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(51),
                      ),
                      child: Center(
                        child: _isLoadingLocation
                            ? SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                            : Icon(
                                widget.useCurrentLocation
                                    ? Icons.my_location
                                    : Icons.location_on,
                                color: Theme.of(context).colorScheme.primary,
                                size: 6.w,
                              ),
                      ),
                    ),
                  ),

                  // Distance label overlay
                  Positioned(
                    top: 2.w,
                    right: 2.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.w,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor,
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'Radius: ${_getDistanceLabel(widget.currentDistance)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.w),

            // Distance slider
            Row(
              children: [
                Text(
                  '1km',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Expanded(
                  child: Slider(
                    value: widget.currentDistance,
                    min: 1,
                    max: 1000,
                    divisions: 100,
                    onChanged: widget.onDistanceChanged,
                  ),
                ),
                Text(
                  'Global',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),

            SizedBox(height: 2.w),

            // Location toggle
            Row(
              children: [
                Icon(
                  Icons.gps_fixed,
                  size: 5.w,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Use current location',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: widget.useCurrentLocation,
                  onChanged: (value) {
                    widget.onLocationToggle(value);
                    if (value) {
                      _getCurrentLocation();
                    }
                  },
                ),
              ],
            ),

            if (_currentPosition != null)
              Padding(
                padding: EdgeInsets.only(top: 2.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 4.w,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Current: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
