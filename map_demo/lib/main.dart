import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (Platform.isAndroid) {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
      mapsImplementation.initializeWithRenderer(AndroidMapRenderer.latest);
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapPage(),
    );
  }
}

class Waypoint {
  final LatLng point;
  final String address;
  Waypoint(this.point, this.address);
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? _mapController;

  LatLng? userLocation;
  String userAddress = "";

  List<Waypoint> stops = [];
  List<LatLng> routePoints = [];
  List<String> routeInstructions = [];

  String statusMessage = "Đang lấy vị trí...";
  String distanceText = "";
  String durationText = "";

  static final String _openRouteApiKey =
      dotenv.env['ORS_API_KEY'] ?? "";

  // static const Map<String, LatLng> _mockCities = {
  //   'GPS thật': LatLng(0, 0),
  //   'TP.HCM': LatLng(10.7769, 106.7009),
  //   'Hà Nội': LatLng(21.0285, 105.8542),
  //   'Đà Nẵng': LatLng(16.0544, 108.2022),
  //   'Huế': LatLng(16.4637, 107.5909),
  //   'Nha Trang': LatLng(12.2388, 109.1967),
  //   'Đà Lạt': LatLng(11.9404, 108.4583),
  //   'Phú Quốc': LatLng(10.2899, 103.9840),
  // };

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> _moveCamera(LatLng pos, double zoom) async {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(pos, zoom));
    }
  }

  Future<void> _setMockLocation(String cityName) async {
    setState(() {
      stops.clear();
      routePoints.clear();
      routeInstructions.clear();
      distanceText = '';
      durationText = '';
    });

    // final mockLoc = _mockCities[cityName]!;
    // if (mockLoc.latitude == 0 && mockLoc.longitude == 0) {
    //   await getUserLocation();
    //   return;
    // }

    // setState(() {
    //   userLocation = mockLoc;
    //   statusMessage = "Đang lấy địa chỉ $cityName...";
    // });
    //
    // _moveCamera(mockLoc, 13);
    // final address = await _getAddressFromLatLng(mockLoc);
    
    // setState(() {
    //   userAddress = address;
    //   statusMessage = "Tìm kiếm / Chạm vào bản đồ để thêm điểm dừng";
    // });
  }

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => statusMessage = "GPS chưa bật!");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => statusMessage = "Chưa cấp quyền GPS!");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => statusMessage = "Quyền GPS bị từ chối vĩnh viễn!");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);

      final loc = LatLng(position.latitude, position.longitude);

      setState(() {
        userLocation = loc;
        statusMessage = "Đang lấy địa chỉ...";
      });

      _moveCamera(loc, 14);

      final address = await _getAddressFromLatLng(loc);
      setState(() {
        userAddress = address;
        statusMessage = "Tìm kiếm / Chạm vào bản đồ để thêm điểm dừng";
      });
    } catch (e) {
      setState(() => statusMessage = "Lỗi GPS: $e");
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.isEmpty) return;
    setState(() => statusMessage = "Đang tìm '$query'...");
    
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        final pt = LatLng(loc.latitude, loc.longitude);
        _moveCamera(pt, 14);
        _addStop(pt);
        return;
      }
    } catch (e) {
      try {
        final url = "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1";
        final res = await http.get(Uri.parse(url), headers: {'User-Agent': 'MapDemoApp'});
        if (res.statusCode == 200) {
          final items = jsonDecode(res.body);
          if (items.isNotEmpty) {
            final lat = double.parse(items[0]['lat']);
            final lon = double.parse(items[0]['lon']);
            final pt = LatLng(lat, lon);
            _moveCamera(pt, 14);
            _addStop(pt);
            return;
          }
        }
      } catch (_) {}
    }
    setState(() => statusMessage = "Không tìm thấy: '$query'");
  }

  Future<void> _addStop(LatLng point) async {
    setState(() => statusMessage = "Đang lấy thông tin đường đi...");
    final address = await _getAddressFromLatLng(point);
    setState(() {
      stops.add(Waypoint(point, address.isEmpty ? "Toạ độ: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}" : address));
    });
    getRoute();
  }

  Future<String> _getAddressFromLatLng(LatLng point) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(point.latitude, point.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [p.street, p.subLocality, p.locality, p.administrativeArea, p.country]
            .where((s) => s != null && s.isNotEmpty).toList();
        return parts.join(', ');
      }
    } catch (e) {
       try {
          final url = "https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json&addressdetails=1";
          final res = await http.get(Uri.parse(url), headers: {'Accept-Language': 'vi', 'User-Agent': 'MapDemoApp'});
          if (res.statusCode == 200) {
            final data = jsonDecode(res.body);
            return data['display_name'] ?? "";
          }
       } catch (_) {}
    }
    return "";
  }

  Future<void> getRoute() async {
    if (userLocation == null || stops.isEmpty) return;

    setState(() => statusMessage = "Đang tính đường đi qua ${stops.length} điểm...");

    List<List<double>> coords = [
      [userLocation!.longitude, userLocation!.latitude],
    ];
    for (var stop in stops) {
      coords.add([stop.point.longitude, stop.point.latitude]);
    }

    final url = "https://api.openrouteservice.org/v2/directions/driving-car/geojson";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': _openRouteApiKey,
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          "coordinates": coords,
          "language": "vi",
          "instructions": true,
        })
      );

      if (response.statusCode != 200) {
        setState(() => statusMessage = "Lỗi API: Mã ${response.statusCode}");
        return;
      }

      final data = jsonDecode(response.body);
      final route = data['features'][0];
      
      final geometry = route['geometry']['coordinates'];
      final segments = route['properties']['segments'];

      List<LatLng> points = [];
      for (var c in geometry) {
        points.add(LatLng(c[1], c[0]));
      }

      double totalDist = 0;
      double totalDur = 0;
      List<String> instructions = [];

      for (var segment in segments) {
        totalDist += segment['distance'];
        totalDur += segment['duration'];
        for (var step in segment['steps']) {
           instructions.add("${step['instruction']} (${(step['distance'] as num).toStringAsFixed(0)}m)");
        }
      }

      setState(() {
        routePoints = points;
        distanceText = "${(totalDist / 1000).toStringAsFixed(1)} km";
        durationText = "${(totalDur / 60).toStringAsFixed(0)} phút";
        routeInstructions = instructions;
        statusMessage = "Sẵn sàng điều hướng!";
      });
    } catch (e) {
      setState(() => statusMessage = "Lỗi kết nối / Không có đường đi");
    }
  }

  void _showRouteInstructions() {
    if (routeInstructions.isEmpty) return;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
               const Text("Chỉ đường", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
               const Divider(),
               Expanded(
                 child: ListView.builder(
                   itemCount: routeInstructions.length,
                   itemBuilder: (ctx, index) {
                     return ListTile(
                       leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: Text("${index + 1}")),
                       title: Text(routeInstructions[index], style: const TextStyle(fontSize: 14)),
                     );
                   }
                 ),
               ),
            ],
          ),
        );
      }
    );
  }

  // --- Sinh Google Maps Markers (Trạm + GPS của mình)
  Set<Marker> _buildMarkers() {
    Set<Marker> m = {};
    if (userLocation != null) {
      m.add(Marker(
        markerId: const MarkerId("user_loc"),
        position: userLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: "Vị trí của bạn"),
      ));
    }
    for (int i = 0; i < stops.length; i++) {
       m.add(Marker(
         markerId: MarkerId("stop_$i"),
         position: stops[i].point,
         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
         infoWindow: InfoWindow(title: "Trạm ${i + 1}", snippet: stops[i].address),
       ));
    }
    return m;
  }

  // --- Sinh Google Maps Polylines (Vẽ đường xanh)
  Set<Polyline> _buildPolylines() {
    Set<Polyline> p = {};
    if (routePoints.isNotEmpty) {
      p.add(Polyline(
        polylineId: const PolylineId("route_line"),
        points: routePoints,
        color: Colors.blueAccent,
        width: 6,
        jointType: JointType.round,
        geodesic: true,
      ));
    }
    return p;
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(statusMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.length < 3) return const Iterable<Map<String, dynamic>>.empty();
            try {
              final url = "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(textEditingValue.text)}&format=json&limit=5&addressdetails=1";
              final res = await http.get(Uri.parse(url), headers: {'User-Agent': 'MapDemoApp'});
              if (res.statusCode == 200) {
                final List items = jsonDecode(res.body);
                return items.map((e) => {
                  'name': e['display_name'],
                  'lat': double.parse(e['lat']),
                  'lon': double.parse(e['lon'])
                });
              }
            } catch (_) {}
            return const Iterable<Map<String, dynamic>>.empty();
          },
          displayStringForOption: (option) => option['name'],
          onSelected: (option) {
            FocusScope.of(context).unfocus();
            final pt = LatLng(option['lat'], option['lon']);
            _moveCamera(pt, 14);
            _addStop(pt);
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: const InputDecoration(
                hintText: "Gõ địa điểm để hiện gợi ý...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmitted: (v) {
                onFieldSubmitted();
                _searchAddress(v);
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 6,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 64,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        leading: const Icon(Icons.location_on, color: Colors.blue),
                        title: Text(option['name'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
        // actions: [
        //   PopupMenuButton<String>(
        //     icon: const Icon(Icons.location_city),
        //     tooltip: "Chuyển TP để test",
        //     onSelected: _setMockLocation,
        //     itemBuilder: (context) {
        //        return _mockCities.keys.map((city) => PopupMenuItem(value: city, child: Text(city))).toList();
        //     },
        //   )
        // ],
      ),
      body: Stack(
        children: [
          // ── Google Maps ──
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation!,
              zoom: 14,
            ),
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controllerCompleter.complete(controller);
              _mapController = controller;
            },
            onTap: (LatLng pt) => _addStop(pt),
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
          ),

          // ── Các Nút Nổi (Zoom, Vị Trí) ──
          Positioned(
            right: 16,
            bottom: 240,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "btnZoomIn",
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black87),
                  onPressed: () async {
                    if (_mapController != null) {
                       final z = await _mapController!.getZoomLevel();
                       _mapController!.animateCamera(CameraUpdate.zoomTo(z + 1));
                    }
                  },
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: "btnZoomOut",
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: Colors.black87),
                  onPressed: () async {
                    if (_mapController != null) {
                       final z = await _mapController!.getZoomLevel();
                       _mapController!.animateCamera(CameraUpdate.zoomTo(z - 1));
                    }
                  },
                ),
                const SizedBox(height: 16),
                FloatingActionButton(
                  heroTag: "btnLoc",
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.my_location, color: Colors.white),
                  onPressed: () {
                    if (userLocation != null) _moveCamera(userLocation!, 15);
                  },
                ),
              ],
            )
          ),

          // ── Bảng Thông Tin ──
          Positioned(
            bottom: 16, left: 16, right: 16,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.adjust, color: Colors.blue),
                      title: Text(userAddress, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Điểm xuất phát"),
                    ),
                    const Divider(height: 0),

                    if (stops.isNotEmpty)
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 120),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: stops.length,
                          itemBuilder: (context, index) {
                             return ListTile(
                               dense: true,
                               contentPadding: EdgeInsets.zero,
                               leading: CircleAvatar(radius: 12, backgroundColor: Colors.red, child: Text("${index + 1}", style: const TextStyle(color: Colors.white, fontSize: 12))),
                               title: Text(stops[index].address, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                               trailing: IconButton(
                                 icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                                 onPressed: () {
                                    setState(() => stops.removeAt(index));
                                    getRoute();
                                 },
                               ),
                             );
                          }
                        ),
                      ),

                    if (stops.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text("Chạm bảng đồ / Tìm kiếm để thêm điểm dừng", style: TextStyle(color: Colors.black54)),
                      ),

                    if (routePoints.isNotEmpty) ...[
                      const Divider(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.route, color: Colors.blueGrey, size: 20),
                              const SizedBox(width: 4),
                              Text(" $distanceText", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 16),
                              const Icon(Icons.timer, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text(" $durationText", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade50),
                            icon: const Icon(Icons.list_alt, size: 16, color: Colors.blue),
                            label: const Text("Chi tiết", style: TextStyle(color: Colors.blue)),
                            onPressed: _showRouteInstructions,
                          )
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}