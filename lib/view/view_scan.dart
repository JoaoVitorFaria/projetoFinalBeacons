import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:beacon/controller/controller_bluetooth.dart';
import 'package:beacon/controller/controller_distancia.dart';
import 'package:get/get.dart';
import 'dart:developer';

class TabScanning extends StatefulWidget {
  const TabScanning({Key? key}) : super(key: key);
 //StatuefulWidget fornece informações mutáveis e cria um state object
  @override //Sobrescreve o método build, pois a classe é abstrata
  _TabScanningState createState() => _TabScanningState(); //Cria um estado mutável para a widget
}

class _TabScanningState extends State<TabScanning> {
  StreamSubscription<RangingResult>? _resultadoScan; //Cria um objeto que providencia um listener para os eventos do stream e segura os callbacks para lidar com eles
  final _beaconPorRegiao = <Region, List<Beacon>>{}; //Variável do tipo Region em uma lista de objetos do tipo Beacon
  final _beacons = <Beacon>[]; //Lista de objetos Beacon
  final controller = Get.find<RequirementStateController>(); //Variável que contém a classe com ps métodos de scanning do bluetooth
  final controllerDistancia = Get.find<RequirementDistance>();

  @override
  void initState() { //Função para iniciar o estado
    super.initState(); //Método que é chamado uma vez que a stateful widget é inserida na árvore de widget, função de inicialização

    controller.iniciaStream.listen((flag) { //Chama o método que inicia o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) { //Testa o valor da flag
        iniciaScanBeacon(); //Chama a função para iniciar o scan do beacon
      }
    });

    controller.pausaStream.listen((flag) { //Chama o método que pausa o stream, da classe RequirementStateController e escuta a flag de resposta
      if (flag == true) { //Testa o valor da flag
        pausaScanBeacon(); //Chama a função para pausar o scan do beacon
      }
    });
  }
iniciaScanBeacon() async { //Função assíncrona que inicia o scan do beacon
    await flutterBeacon.initializeScanning; //Instância única ao método de scan da API flutter beacon
    if (!controller.bluetoothEnabled) { //Teste do estado do bluetooth (desabilitado)
      // print(
      //     'bluetoothAtivado=${controller.bluetoothEnabled}'); //Imprime o valor da variável
      return;
    }

    final regions = <Region>[]; //Lista de objetos];
    regions.add(Region(identifier: 'com.beacon'));

    if (_resultadoScan != null) { //Testa o valor do objeto de StreaSubscription
      if (_resultadoScan!.isPaused) { //Testa se o objeto não está 'pausado' (retorna verdadeiro se houver mais chamadas para pausar que para retomar ou retorna falso se o stream ainda pode emitir eventos)
        _resultadoScan?.resume(); //Resume a inscrição
        return;
      }
    }
    // flutterBeacon.setBetweenScanPeriod(10000);
    _resultadoScan = flutterBeacon.ranging(regions).listen((RangingResult result) {
          _beaconPorRegiao[result.region] = result.beacons;
          _beaconPorRegiao.values.forEach((list) { //Faz um laço para cada um dos valores da lista de regiões
            _beacons.addAll(list); //Adiciona à lista de beacons 
          });
      if(_beacons.length == 20){ // Define o número de leituras com o qual irei calcular a média da distância
          // var resultado = controllerDistancia.mediaDistancia(_beacons);
          var resultado  = controllerDistancia.movingAverage(_beacons);
          log("Distancia com moving Average: "+resultado.toString());
         _beacons.clear(); // Limpo a lista de leituras
      }
    });

     
  }
  
  pausaScanBeacon() async { //Função assíncrona que pausa o scanning do beacon
    _resultadoScan?.pause(); //Pausa o stream
    if (_beacons.isNotEmpty) { //Testa se a lista de beacons não está vazia
      setState(() { //Notifica o framework que o estado do objeto mudou
        log('TESTE: '+_beacons.length.toString());
        _beacons.clear(); //Limpa a lista de beacons
      });
    }
  }



  @override
  void dispose() { //Método chamado quando o objeto é removido da árvore
    _resultadoScan?.cancel(); //Cancela a incrição e não recebe mais eventos
    super.dispose(); //Método quando o objeto não vai ser construído novamente
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: _beacons.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: ListTile.divideTiles(
              context: context,
              tiles: _beacons.map(
                (beacon) {
                  return ListTile(
                    title: Text(
                      'MAC: ${beacon.macAddress}',
                      style: TextStyle(fontSize: 15.0),
                    ),
                    subtitle: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            'Distancia: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                            style: TextStyle(fontSize: 13.0),
                          ),
                          flex: 2,
                          fit: FlexFit.tight,
                        ),Flexible(
                          child: Text(
                            'TxPower: ${beacon.txPower}',
                            style: TextStyle(fontSize: 13.0),
                          ),
                          flex: 2,
                          fit: FlexFit.tight,
                        )
                      ],
                    ),
                  );
                },
              ),
            ).toList(),
          ),
  );
}
}