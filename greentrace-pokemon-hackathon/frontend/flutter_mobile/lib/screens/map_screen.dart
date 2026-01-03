import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../services/api_service.dart';
import '../components/reward_popup.dart';
import '../components/pokemon_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapboxMapController? _controller;
  final ApiService _apiService = ApiService();
  final LatLng _hongKongCenter = const LatLng(22.32, 114.17);
  bool _loading = false;
  String _statusMessage = 'Catch a Trash-Monster by checking in!';

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMapController controller) async {
    _controller = controller;
    await _loadBins();
  }

  Future<void> _loadBins() async {
    try {
      final bins = await _apiService.fetchBins();
      for (final bin in bins) {
        await _controller?.addSymbol(
          SymbolOptions(
            geometry: LatLng(bin['lat'], bin['lng']),
            iconImage: 'marker-15',
            iconSize: 1.4,
            iconColor: bin['type'] == 'toilet' ? '#4DC1FF' : '#28C76F',
          ),
          {'name': bin['name'], 'type': bin['type']},
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _statusMessage = 'Oops! Failed to load bins. Try again soon.';
      });
    }
  }

  Future<void> _uploadWaste() async {
    try {
      setState(() {
        _loading = true;
        _statusMessage = 'Summoning the eco-scan...';
      });
      final ImagePicker picker = ImagePicker();
      final XFile? picked = await picker.pickImage(source: ImageSource.camera);
      if (picked == null) {
        setState(() {
          _loading = false;
          _statusMessage = 'Camera closed. Tap again when ready!';
        });
        return;
      }

      final Uint8List bytes = await picked.readAsBytes();
      final response = await _apiService.classifyWaste(base64Encode(bytes));
      if (!mounted) return;

      final points = response['points'] as int? ?? 0;
      final category = response['category'] as String? ?? 'unknown';
      setState(() {
        _loading = false;
        _statusMessage = 'You caught a $category monster! +$points points!';
      });

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => RewardPopup(points: points, category: category),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _statusMessage = 'Upload failed. Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? mapboxToken = dotenv.env['NEXT_PUBLIC_MAPBOX_TOKEN'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenTrace Map'),
        backgroundColor: const Color(0xFF28C76F),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MapboxMap(
            accessToken: mapboxToken,
            initialCameraPosition: CameraPosition(
              target: _hongKongCenter,
              zoom: 12,
            ),
            styleString: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: _StatusCard(message: _statusMessage),
          ),
          Positioned(
            right: 16,
            bottom: 24,
            child: PokemonButton(
              label: _loading ? 'Scanning...' : 'Eco Scan',
              icon: Icons.camera_alt_rounded,
              onPressed: _loading ? null : _uploadWaste,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String message;

  const _StatusCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFC700), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.eco_rounded, color: Color(0xFF28C76F)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
