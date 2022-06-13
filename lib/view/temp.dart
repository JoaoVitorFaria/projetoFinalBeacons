// iniciaScanBeacon() async { //Função assíncrona que inicia o scan do beacon
//     await flutterBeacon.initializeScanning; //Instância única ao método de scan da API flutter beacon
//     if (!controller.bluetoothEnabled) { //Teste do estado do bluetooth (desabilitado)
//       // print(
//       //     'bluetoothAtivado=${controller.bluetoothEnabled}'); //Imprime o valor da variável
//       return;
//     }

//     final regions = <Region>[]; //Lista de objetos];

//     if (Platform.isIOS) {
//     // iOS platform, at least set identifier and proximityUUID for region scanning
//           regions.add(Region(
//           identifier: 'Apple Airlocate',
//           proximityUUID: 'E2C56DB5-DFFB-48D2-B060-D0F5A71096E0'));  
//     } else {
//     // android platform, it can ranging out of beacon that filter all of Proximity UUID
//       regions.add(Region(identifier: 'com.beacon'));
// }
//     if (_resultadoScan != null) { //Testa o valor do objeto de StreaSubscription
//       if (_resultadoScan!.isPaused) { //Testa se o objeto não está 'pausado' (retorna verdadeiro se houver mais chamadas para pausar que para retomar ou retorna falso se o stream ainda pode emitir eventos)
//         _resultadoScan?.resume(); //Resume a inscrição
//         return;
//       }
//     }
//     var temp = 0;
//   var count =0 ;
//   // flutterBeacon.setBetweenScanPeriod(10000);
//     _resultadoScan = flutterBeacon.ranging(regions).listen((RangingResult result) {
//        if (mounted) { //Testa se o state object está na árvore de widget
//          setState(() { //Notifica o framework que o estado do objeto mudou
//           _beaconPorRegiao[result.region] = result.beacons; //Atribui as regiões do resultado
//           // _beacons.clear(); //Limpa a lista de beacons
//           _beaconPorRegiao.values.forEach((list) { //Faz um laço para cada um dos valores da lista de regiões
//             _beacons.addAll(list); //Adiciona à lista de beacons 
            
//             // var dist = distancia.calculaDistancia(_beacons[count].rssi, _beacons[count].txPower);
//             // log("Distancia: " + dist.toString());
//             // log("Acurracy: "+_beacons[count].accuracy.toString());
//             count++;
//           });
//       });
//       }
       
//       // //  _beacons.clear();
//       // temp++;
//       // count++;
//       // if(_beacons.length == 4){
//       //     var resultado = distancia.mediaDistancia(_beacons);
//       //     log("Resultado = "+ resultado.toString());
//       //    _beacons.clear();
//       //    log('tamanho da lista:'+_beacons.length.toString());
//       // }

//     });

     
//   }