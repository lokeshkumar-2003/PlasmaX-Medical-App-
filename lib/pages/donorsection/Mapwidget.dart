import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';

class FreeMapWidget extends StatefulWidget {
  final double lat;
  final double lng;
  const FreeMapWidget({super.key, required this.lat, required this.lng});

  @override
  State<FreeMapWidget> createState() => _FreeMapWidgetState();
}

class _FreeMapWidgetState extends State<FreeMapWidget> {
  late final MapController _mapController;
  late LatLng _src;
  String _address = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _src = LatLng(widget.lat, widget.lng);
    _mapController = MapController();
    _getAddress(_src);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Your Location',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _buildMap(),
            _buildAddressLabel(),
          ],
        ),
      ),
    );
  }

  /// Builds the FreeMap widget
  Widget _buildMap() {
    return FmMap(
      mapController: _mapController,
      mapOptions: MapOptions(
        minZoom: 15,
        maxZoom: 18,
        initialZoom: 15,
        initialCenter: _src,
        onTap: (pos, point) => _getAddress(point),
      ),
      markers: [
        Marker(
          point: _src,
          child: const Icon(
            size: 40.0,
            color: Colors.red,
            Icons.location_on_rounded,
          ),
        ),
      ],
      polylineOptions: const FmPolylineOptions(
        strokeWidth: 3,
        color: Colors.blue,
      ),
    );
  }

  /// Builds the address label
  Widget _buildAddressLabel() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _address,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Future<void> _getAddress(LatLng pos) async {
    setState(() {
      _isLoading = true;
    });
    final data = await FmService().getAddress(
      lat: pos.latitude,
      lng: pos.longitude,
    );
    if (kDebugMode) print(data?.address);
    if (data != null) {
      setState(() {
        _address = data.address;
        _isLoading = false;
      });
      _getGeocode(data.address);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getGeocode(String address) async {
    final data = await FmService().getGeocode(address: address);
    if (kDebugMode) print('${data?.lat},${data?.lng}');
  }
}
