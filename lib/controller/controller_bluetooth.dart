import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class RequirementStateController extends GetxController {
  final bluetoothState = BluetoothState.stateOff.obs;
  final _startScanning = false.obs;
  final _pauseScanning = false.obs;

  bool get bluetoothEnabled => bluetoothState.value == BluetoothState.stateOn;

  atualizaEstadoBluetooth(BluetoothState state) {
    bluetoothState.value = state;
  }
  // Atualiza o estado do scanner 
  iniciaEscaneamento() {
    _startScanning.value = true;
    _pauseScanning.value = false;
  }
  // Atualiza o estado do scanner 
  pausaEscaneamento() {
    _startScanning.value = false;
    _pauseScanning.value = true;
  }
  // uma variavel assincrona 
  Stream<bool> get iniciaStream {
    return _startScanning.stream;
  }

  Stream<bool> get pausaStream {
    return _pauseScanning.stream;
  }
}
