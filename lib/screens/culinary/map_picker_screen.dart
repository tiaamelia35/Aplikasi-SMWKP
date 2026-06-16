import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// removed unused import: geolocator
import 'package:smwkp_culinary_tourism/core/constants/app_constants.dart';
import 'package:smwkp_culinary_tourism/services/maps_service.dart';
import 'package:smwkp_culinary_tourism/widgets/common/common_widgets.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  // ignore: use_super_parameters
  const MapPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late GoogleMapController _mapController;
  final _mapsService = MapsService();

  late LatLng _selectedLocation;
  String? _selectedAddress;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  // Palembang center coordinates
  static const LatLng _palembangCenter = LatLng(-2.915808, 104.745199);

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      if (widget.initialLatitude != null && widget.initialLongitude != null) {
        // Use provided location
        _selectedLocation = LatLng(
          widget.initialLatitude!,
          widget.initialLongitude!,
        );
        _selectedAddress = widget.initialAddress;
      } else {
        // Try to get current location
        final position = await _mapsService.getCurrentLocation();
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _selectedAddress = await _mapsService.getAddressFromCoordinates(
          position.latitude,
          position.longitude,
        );
      }

      _addMarkerAtLocation(_selectedLocation);

      setState(() => _isLoading = false);
    } catch (e) {
      // Default to Palembang center if location access is denied
      _selectedLocation = _palembangCenter;
      _selectedAddress = 'Palembang, Indonesia';
      _addMarkerAtLocation(_selectedLocation);

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Using default location: ${e.toString()}')),
        );
      }
    }
  }

  void _addMarkerAtLocation(LatLng location) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('selected'),
        position: location,
        infoWindow: InfoWindow(title: _selectedAddress ?? 'Selected Location'),
      ),
    );
  }

  Future<void> _handleMapTap(LatLng location) async {
    setState(() => _isLoading = true);

    try {
      _selectedLocation = location;
      _selectedAddress = await _mapsService.getAddressFromCoordinates(
        location.latitude,
        location.longitude,
      );
      _addMarkerAtLocation(location);

      // Animate camera to new location
      _mapController.animateCamera(
        CameraUpdate.newLatLng(location),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get address: ${e.toString()}')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoading = true);

      final position = await _mapsService.getCurrentLocation();
      final location = LatLng(position.latitude, position.longitude);

      _selectedLocation = location;
      _selectedAddress = await _mapsService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      _addMarkerAtLocation(location);

      // Animate camera to current location
      _mapController.animateCamera(
        CameraUpdate.newLatLng(location),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get current location: ${e.toString()}')),
        );
      }
      setState(() => _isLoading = false);
    }
  }

  void _confirmLocation() {
    Navigator.pop(context, {
      'latitude': _selectedLocation.latitude,
      'longitude': _selectedLocation.longitude,
      'address': _selectedAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingWidget(message: 'Memuat peta...'),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pilih Lokasi',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            markers: _markers,
            onTap: _handleMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapToolbarEnabled: true,
          ),

          // Location info card at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.lg),
                  topRight: Radius.circular(AppBorderRadius.lg),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lokasi Terpilih',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedAddress ?? 'Lokasi tidak diketahui',
                                      style: const TextStyle(
                                        fontSize: AppFontSize.sm,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(
                                      '${_selectedLocation.latitude.toStringAsFixed(6)}, ${_selectedLocation.longitude.toStringAsFixed(6)}',
                                      style: const TextStyle(
                                        fontSize: AppFontSize.xs,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.my_location),
                            label: const Text('Lokasi Saya'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _confirmLocation,
                            icon: const Icon(Icons.check),
                            label: const Text('Konfirmasi'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

// Widget untuk menampilkan peta dengan multiple markers (untuk browsing restoran)
class MultiMarkerMapScreen extends StatefulWidget {
  final List<MapMarker> markers;
  final Function(MapMarker) onMarkerTap;

  const MultiMarkerMapScreen({
    Key? key,
    required this.markers,
    required this.onMarkerTap,
  }) : super(key: key);

  @override
  State<MultiMarkerMapScreen> createState() => _MultiMarkerMapScreenState();
}

class _MultiMarkerMapScreenState extends State<MultiMarkerMapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  static const LatLng _palembangCenter = LatLng(-2.915808, 104.745199);

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.clear();

    for (final marker in widget.markers) {
      _markers.add(
        Marker(
          markerId: MarkerId(marker.id),
          position: LatLng(marker.latitude, marker.longitude),
          infoWindow: InfoWindow(
            title: marker.title,
            snippet: marker.address,
            onTap: () => widget.onMarkerTap(marker),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            marker.isHalalCertified
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Peta Restoran',
        showBackButton: true,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: _palembangCenter,
          zoom: 13,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
        mapToolbarEnabled: true,
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

// Model untuk marker data
class MapMarker {
  final String id;
  final String title;
  final String address;
  final double latitude;
  final double longitude;
  final bool isHalalCertified;
  final double rating;

  MapMarker({
    required this.id,
    required this.title,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.isHalalCertified = false,
    this.rating = 0,
  });
}
