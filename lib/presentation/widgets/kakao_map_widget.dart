import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/models/hospital_marker.dart';
import '../../core/constants/kakao_config.dart';

/// 카카오맵 위젯
class KakaoMapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final List<HospitalMarker> hospitals;
  final Function(HospitalMarker)? onMarkerTap;

  const KakaoMapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.hospitals = const [],
    this.onMarkerTap,
  });

  @override
  State<KakaoMapWidget> createState() => KakaoMapWidgetState();
}

class KakaoMapWidgetState extends State<KakaoMapWidget> {
  late final WebViewController controller;
  bool isMapReady = false;
  bool isSdkReady = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('WebView 로딩 진행: $progress%');
          },
          onPageStarted: (String url) {
            print('페이지 로딩 시작: $url');
          },
          onPageFinished: (String url) {
            print('페이지 로딩 완료: $url');
            // 페이지 로드 완료 후 SDK 체크
            if (!isSdkReady) {
              _checkSdkReady();
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView 에러: ${error.description}');
            setState(() {
              errorMessage = '지도 로딩 실패: ${error.description}';
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            print('Navigation 요청: ${request.url}');
            // 외부 URL로의 이동 차단
            if (request.url.startsWith('http') && !request.url.contains('kakao')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (JavaScriptMessage message) {
          print('JavaScript 메시지: ${message.message}');
          final data = message.message;
          if (data == 'sdkReady') {
            setState(() {
              isSdkReady = true;
            });
            // SDK가 준비되면 맵 초기화
            _initializeMap();
          } else if (data == 'mapReady') {
            setState(() {
              isMapReady = true;
            });
            _addMarkers();
          } else if (data.startsWith('markerClick:')) {
            final markerId = data.substring('markerClick:'.length);
            if (widget.onMarkerTap != null && markerId != 'current_location') {
              final hospital = widget.hospitals.firstWhere(
                (h) => h.id == markerId,
                orElse: () => widget.hospitals.first,
              );
              widget.onMarkerTap!(hospital);
            }
          } else if (data.startsWith('error:')) {
            final error = data.substring('error:'.length);
            print('JavaScript 에러: $error');
            setState(() {
              errorMessage = '지도 오류: $error';
            });
          }
        },
      );
    
    // HTML 직접 로드
    _loadMapHtml();
  }

  Future<void> _loadMapHtml() async {
    try {
      final String htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>카카오맵</title>
    <style>
        html, body {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        #map {
            width: 100%;
            height: 100%;
        }
        #loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
        }
    </style>
</head>
<body>
    <div id="loading">지도를 불러오는 중...</div>
    <div id="map"></div>
    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${KakaoConfig.javascriptKey}"></script>
    <script>
        var map;
        var markers = [];
        var mapInitialized = false;
        
        // Flutter와 통신
        function sendToFlutter(message) {
            try {
                if (window.Flutter && window.Flutter.postMessage) {
                    window.Flutter.postMessage(message);
                } else {
                    console.log('Flutter channel not available, message:', message);
                }
            } catch (e) {
                console.error('Flutter 통신 에러:', e);
            }
        }
        
        // 에러 핸들러
        window.onerror = function(msg, url, lineNo, columnNo, error) {
            console.error('JavaScript 오류:', msg, error);
            sendToFlutter('error:' + msg);
            return true;
        };
        
        // 카카오맵 초기화
        function initializeMap(lat, lng) {
            if (mapInitialized) return;
            
            try {
                console.log('지도 초기화 시작:', lat, lng);
                var mapContainer = document.getElementById('map');
                var mapOption = {
                    center: new kakao.maps.LatLng(lat, lng),
                    level: 3
                };

                map = new kakao.maps.Map(mapContainer, mapOption);
                mapInitialized = true;
                
                // 로딩 텍스트 숨기기
                document.getElementById('loading').style.display = 'none';
                
                console.log('지도 초기화 완료');
                sendToFlutter('mapReady');
            } catch (e) {
                console.error('Map initialization error:', e);
                sendToFlutter('error:지도 초기화 실패 - ' + e.message);
            }
        }
        
        // 맵 타입 변경 함수
        function changeMapType(type) {
            if (!map) return;
            try {
                if (type === 'ROADMAP') {
                    map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);
                } else if (type === 'HYBRID') {
                    map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);
                }
            } catch (e) {
                console.error('Change map type error:', e);
            }
        }
        
        // 현재 위치로 이동
        function moveToLocation(lat, lng) {
            if (!map) return;
            try {
                var moveLatLon = new kakao.maps.LatLng(lat, lng);
                map.setCenter(moveLatLon);
            } catch (e) {
                console.error('Move location error:', e);
            }
        }
        
        // 마커 추가
        function addMarker(id, lat, lng, title, type) {
            if (!map) return;
            try {
                console.log('마커 추가:', id, title, type);
                var markerPosition = new kakao.maps.LatLng(lat, lng);
                
                var imageSrc = type === 'current' 
                    ? 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/current_location.png'
                    : type === 'hospital'
                    ? 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'
                    : 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/marker_red.png';
                
                var imageSize = type === 'current' 
                    ? new kakao.maps.Size(40, 40)
                    : new kakao.maps.Size(30, 44);
                
                var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);
                
                var marker = new kakao.maps.Marker({
                    position: markerPosition,
                    map: map,
                    image: markerImage
                });
                
                if (title && type !== 'current') {
                    var infowindow = new kakao.maps.InfoWindow({
                        content: '<div style="padding:5px;font-size:12px;">' + title + '</div>'
                    });
                    
                    // iOS에서는 mouseover 이벤트가 작동하지 않으므로 클릭 시 정보창 표시
                    var isInfoWindowOpen = false;
                    kakao.maps.event.addListener(marker, 'click', function() {
                        if (isInfoWindowOpen) {
                            infowindow.close();
                        } else {
                            infowindow.open(map, marker);
                        }
                        isInfoWindowOpen = !isInfoWindowOpen;
                        sendToFlutter('markerClick:' + id);
                    });
                }
                
                markers.push(marker);
                console.log('마커 추가 완료');
            } catch (e) {
                console.error('Add marker error:', e);
                sendToFlutter('error:마커 추가 실패 - ' + e.message);
            }
        }
        
        // SDK 준비 상태 체크
        function checkSdkReady() {
            if (typeof kakao !== 'undefined' && kakao.maps) {
                console.log('카카오맵 SDK 준비 완료');
                sendToFlutter('sdkReady');
                return true;
            }
            return false;
        }
        
        // 페이지 로드 완료 시 SDK 체크
        window.addEventListener('load', function() {
            setTimeout(function() {
                if (!checkSdkReady()) {
                    console.error('카카오맵 SDK 로드 실패');
                    sendToFlutter('error:카카오맵 SDK 로드 실패');
                }
            }, 2000);
        });
    </script>
</body>
</html>
      ''';
      
      await controller.loadHtmlString(htmlContent);
    } catch (e) {
      print('HTML 로드 에러: $e');
      setState(() {
        errorMessage = 'HTML 로드 실패: $e';
      });
    }
  }

  void _checkSdkReady() async {
    // 페이지 로드 후 SDK 체크
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      await controller.runJavaScript('checkSdkReady()');
      print('SDK 체크 실행 완료');
    } catch (e) {
      print('SDK 체크 오류: $e');
    }
  }

  void _initializeMap() async {
    if (!isSdkReady) return;
    
    try {
      await controller.runJavaScript(
        'initializeMap(${widget.latitude}, ${widget.longitude});'
      );
    } catch (e) {
      print('맵 초기화 오류: $e');
    }
  }

  void _addMarkers() async {
    if (!isMapReady) return;
    
    try {
      // 현재 위치 마커 추가
      await controller.runJavaScript(
        'addMarker("current_location", ${widget.latitude}, ${widget.longitude}, "현재 위치", "current");'
      );

      // 병원/약국 마커 추가
      for (var hospital in widget.hospitals) {
        // 이름에서 특수문자 이스케이프 처리
        final escapedName = hospital.name
            .replaceAll("'", "\\'")
            .replaceAll('"', '\\"')
            .replaceAll('\n', ' ')
            .replaceAll('\r', ' ');
        
        await controller.runJavaScript(
          'addMarker("${hospital.id}", ${hospital.latitude}, ${hospital.longitude}, "$escapedName", "${hospital.type}");'
        );
      }
    } catch (e) {
      print('마커 추가 오류: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                    isMapReady = false;
                    isSdkReady = false;
                  });
                  _initWebView();
                },
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (!isMapReady)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  /// 현재 위치로 이동
  void moveToCurrentLocation() {
    if (!isMapReady) return;
    controller.runJavaScript(
      'moveToLocation(${widget.latitude}, ${widget.longitude});'
    );
  }

  /// 지도 타입 변경 (일반/위성)
  void changeMapType(MapType type) {
    if (!isMapReady) return;
    controller.runJavaScript(
      'changeMapType("${type == MapType.normal ? 'ROADMAP' : 'HYBRID'}");'
    );
  }
}

enum MapType { normal, satellite } 