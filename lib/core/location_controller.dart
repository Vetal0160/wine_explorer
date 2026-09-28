import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// Приблизительное местоположение пользователя. null — неизвестно
/// (не спрашивали или не разрешили). Никуда не отправляется и не сохраняется.
final ValueNotifier<LatLng?> userLocation = ValueNotifier<LatLng?>(null);

enum LocateResult { ok, serviceDisabled, denied, deniedForever, failed }

/// Спрашивает разрешение (только по нажатию кнопки) и определяет, где пользователь.
Future<LocateResult> locateUser() async {
  try {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocateResult.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) return LocateResult.denied;
    if (permission == LocationPermission.deniedForever) {
      return LocateResult.deniedForever;
    }

    Position? position;
    try {
      // Для «рядом со мной» хватает точности в сотни метров
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
    } catch (_) {
      position = await Geolocator.getLastKnownPosition();
    }
    if (position == null) return LocateResult.failed;
    userLocation.value = LatLng(position.latitude, position.longitude);
    return LocateResult.ok;
  } catch (e) {
    debugPrint('Не удалось определить местоположение: $e');
    return LocateResult.failed;
  }
}

Future<void> openLocationSettingsFor(LocateResult result) =>
    result == LocateResult.serviceDisabled
    ? Geolocator.openLocationSettings()
    : Geolocator.openAppSettings();

const _distance = Distance();

/// Расстояние по прямой, км.
double distanceKm(LatLng from, double latitude, double longitude) =>
    _distance.as(LengthUnit.Meter, from, LatLng(latitude, longitude)) / 1000;

/// «4.2» до 10 км, дальше целыми: «37».
String formatKm(double km) =>
    km < 10 ? km.toStringAsFixed(1) : km.round().toString();
