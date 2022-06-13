
// -------------------------------------importacoes-------------------------------------
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:beacon/view/view_scan.dart';
import 'package:get/get.dart';
import 'dart:developer';
// Cria a tela
class HomePage extends StatefulWidget {
  //override é usado para reescrever um 'metodo abstrato' da classe statefulWidget
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // criando uma variavel para um controller
  final controller = Get.find<RequirementStateController>();
  // funcao assincrona para receber informacoes sobre o bluetooth
  StreamSubscription<BluetoothState>? _streamBluetooth;
  int currentIndex = 0;
  String retorno = ' ';

  // metodo para iniciar a aplicacao
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    esperaEstadoBluetooth();
  }

  esperaEstadoBluetooth() async {
    // print('Verificando o estado do Bluetooth');
    // verifica o estado do bluetooth
    _streamBluetooth = flutterBeacon.bluetoothStateChanged().listen((BluetoothState state) async {
      // atualiza o estado do bluetooth no controle
      controller.atualizaEstadoBluetooth(state);
      // chama o metodo para verificar os parametros da aplicacao
      await verificaParametroApp();
    });
    // print('Teste de retorno----------------------------- $retorno ---------------------------------------');
    // print('Teste de stream(01)----------------------------- $_streamBluetooth ---------------------------------------');

  }
  // Metodo para checar os requisitos da aplicacao
  verificaParametroApp() async {
    // recebe o estado do bluetooth(ligado ou desligado)
    final bluetoothState = await flutterBeacon.bluetoothState;
    // atualiza o estado do bluetooth
    controller.atualizaEstadoBluetooth(bluetoothState);
    _streamBluetooth.printInfo();
    // imprime o estado do bluetooth(ligado ou desligado)
    // print('BLUETOOTH $bluetoothState');
    // print('Teste de retorno----------------------------- $retorno ---------------------------------------');
    // print('Teste de stream(02)-----------------------------$_streamBluetooth---------------------------------------');
    // print('Teste de stream(02)tostring-----------------------------' + _streamBluetooth.toString()+' ---------------------------------------');

    
    // Caso o bluetooth esteja ligada a aplicacao pode ser iniciada
    if (controller.bluetoothEnabled ) { 
      // print('Aplicação pronta');
      if (currentIndex == 0) {
        // print('Escaneando');
        // Chamada do metodo para comecar a escanear 
        controller.iniciaEscaneamento();
      } 
    } else {
      // print('Aplicação não está pronta');
      controller.pausaEscaneamento();// Caso o bluetooth seja desligado ele para de escanear
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // print('AppLifecycleState = $state');
    if (state == AppLifecycleState.resumed) { // quando a aplicacao esta aberta
      if (_streamBluetooth != null) {
        if (_streamBluetooth!.isPaused) {
          _streamBluetooth?.resume();
          retorno = _streamBluetooth.toString();
          // ignore: avoid_print
          // print('Teste de retorno----------------------------- $retorno ---------------------------------------');
          // print('Teste de stream(03)-----------------------------' + _streamBluetooth.toString()+' ---------------------------------------');
        }
      }
      await verificaParametroApp();
    } else if (state == AppLifecycleState.paused) { // quando a aplicacao esta no background mas nao esta sendo usada
      _streamBluetooth?.pause(); // pausa o stream
    }
  }

  // Encerra o funcionamento
  @override
  void dispose() {
    _streamBluetooth?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // constroi o widget
    return Scaffold( // uma estrutura padrão de tela do flutter
      appBar: AppBar( // barra azul de cima da tela
        title: const Text('Projeto'), // 
        centerTitle: false,
        actions: <Widget>[
          Obx(() { // vai fazer update do widget do bluetooth
            final state = controller.bluetoothState.value; // pega o valor do estado do bluetooth

            if (state == BluetoothState.stateOn) {
              return IconButton(
                tooltip: 'Bluetooth ligado', // para acessibilidade(aparece escrito apos passar o mouse)
                icon: Icon(Icons.bluetooth_connected),
                onPressed: () {},
                color: Colors.lightBlueAccent, // cor do icone do bluetooth ligado
              );
            }

            if (state == BluetoothState.stateOff) { // caso bluetooth esteja desligado
              return IconButton(
                tooltip: 'Bluetooth desligado', //para acessibilidade
                icon: Icon(Icons.bluetooth),
                onPressed: handleOpenBluetooth, // chama o metodo que pede para ligar o bluetooth
                color: Colors.red,
              );
            }

            return IconButton(
              icon: Icon(Icons.bluetooth_disabled), // quando nao reconhecer o bluetooth no dispositivo
              tooltip: 'Bluetooth não disponível', // acessiblidade
              onPressed: () {},
              color: Colors.grey, 
            );
          }),
        ],
      ),
      body: IndexedStack( // o espaco no meio da tela
        index: currentIndex,
        children: [
          TabScanning(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar( // a barra de baixo
        currentIndex: currentIndex,
        onTap: (index) { 
          setState(() {
            currentIndex = index;
          });

          if (currentIndex == 0) { // inicia o scan ao clicar no botao
            controller.iniciaEscaneamento();
          }else {
            controller.pausaEscaneamento();
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Escanear',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pause),
            label: 'Pausar',
          ),
        ],
      ),
    );
  }

  // Metodo para requisitar a inicializacao do bluetooth no dispositivo
  handleOpenBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await flutterBeacon.openBluetoothSettings;
      } on PlatformException catch (e) {
        print(e);
      }
    } 
  }
}
