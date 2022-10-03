import 'dart:async';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class Tela1 extends StatefulWidget {
  @override
  _Tela1State createState() => _Tela1State();
}

class _Tela1State extends State<Tela1> {
  late ProgressDialog pr;
  double fontTitulo = 13;
  double fontTexto = 18;
  double paddintIndicadores = 1;
  double marginIndicadores = 5;
  GeoPoint? _local = GeoPoint( latitude: -20.450223, longitude: -45.411982 );

  Future<Position> _determinePosition() async {
    pr = ProgressDialog(context, showLogs: true, isDismissible: true);
    pr.style(message: 'Aguarde ...');
    await pr.show();
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  /**
   * Método de Tela1ização da tela
   */
  @override
  void initState() {
    super.initState();
    //cria o evento de onTap no widget do mapa
    controller.listenerMapSingleTapping.addListener(() async {
      //adiciona marcador no centro do mapa, quando o widget mapa recebe um tap
      print("adicionar marcador");
      if (await confirm(
        context,
        title: const Text('Confirma'),
        content: const Text('Deseja adicionar o marcador?'),
        textOK: const Text('Sim'),
        textCancel: const Text('Não'),
      )){
        addMarcador(await controller.centerMap);
      }
    });

    //cria o evento de mudança de região
    controller.listenerRegionIsChanging.addListener(() async {
      print("movivmentando no mapa");
    });

    //cria evento de onTap longo
    controller.listenerMapLongTapping.addListener(() async {
      print("TAP LONGO!!!");
    });
  }

  //controlador do maps
  MapController controller = MapController(
    initMapWithUserPosition: false,
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    /*areaLimit: BoundingBox(
      east: 10.4922941,
      north: 47.8084648,
      south: 45.817995,
      west: 5.9559113,
    ),*/
  );

  /**
   * método que monta a tela de informativo
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          OSMFlutter(
            controller: controller,
            trackMyPosition: false,
            initZoom: 12,
            minZoomLevel: 8,
            maxZoomLevel: 19,
            stepZoom: 1.0,
            showZoomController: true,
            androidHotReloadSupport: true,
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                icon: Icon(
                  Icons.local_car_wash,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              directionArrowMarker: MarkerIcon(
                icon: Icon(
                  Icons.add_location,
                  size: 60,
                ),
              ),
            ),
            roadConfiguration: RoadConfiguration(
              startIcon: MarkerIcon(
                icon: Icon(
                  Icons.add_location,
                  size: 64,
                  color: Colors.brown,
                ),
              ),
              roadColor: Colors.red,
            ),
            markerOption: MarkerOption(
                defaultMarker: MarkerIcon(
                  icon: Icon(
                    Icons.person_pin_circle,
                    color: Colors.blue,
                    size: 56,
                  ),
                )),
          )
        ],
      ),

      //BOTÕES FLUTUANTES AZUIS NA TELA
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: 100,
          ),
          FloatingActionButton(
              child: Icon(Icons.location_history_sharp,
                  color: Colors.amber, size: 40),
              onPressed: () async {
                //muda a localização para o IFMG
                controller.goToLocation(GeoPoint(latitude: -20.453319, longitude: -45.438125));
                controller.setZoom(zoomLevel: 18, stepZoom: 1);
              }),
          FloatingActionButton(
              child: Icon(Icons.my_location, color: Colors.amber, size: 40),
              onPressed: () async {
                Position accuracy = await _determinePosition();
                _local = GeoPoint(latitude: accuracy.latitude, longitude: accuracy.longitude);
                controller.goToLocation(_local!);
                controller.setZoom(zoomLevel: 18, stepZoom: 1);
                addMarcador(_local!);
                if (pr.isShowing()) {
                  pr.hide();
                }
              }),
          FloatingActionButton(
              child: Icon(Icons.my_location, color: Colors.amber, size: 40),
              onPressed: () async {
                RoadInfo roadInfo = await desenhaRota(_local!,GeoPoint(latitude: -20.453319, longitude: -45.438125));
                print("${roadInfo.distance}km");
                if (pr.isShowing()) {
                  pr.hide();
                }
              }),
        ],
      ),
    );
  }

  /**
   * método que adiciona um marcador ao centro do mapa
   * este método é chamado no envento onTap do mapa.
   * Este evento foi setado no initState
   */
  void addMarcador(GeoPoint p) async {
    await controller.addMarker(p,
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.add_location,
            color: Colors.green,
            size: 70,
          ),
        ));
  }

  Future<RoadInfo> desenhaRota(GeoPoint origem, GeoPoint destino) async {
    pr = ProgressDialog(context, showLogs: true, isDismissible: false);
    pr.style(message: 'Gerando rota ...');
    await pr.show();
  return await controller.drawRoad(origem,destino, roadType: RoadType.car,
    roadOption: const RoadOption(
            roadWidth: 20,
            roadColor: Colors.green,
            showMarkerOfPOI: false,
            zoomInto: true,
    ));
  }
}
