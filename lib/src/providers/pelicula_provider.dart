import 'dart:async';
import 'dart:convert';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = 'e896ce6d349be82076dc0382260527ea';
  String _url = 'api.themoviedb.org';
  String _languaje = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamCtrl = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamCtrl.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamCtrl.stream;

  void disposeStreams() {
    _popularesStreamCtrl?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url ) async  {

    final resp = await  http.get(url); 

    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;

  }

  Future<List<Pelicula>> getEnCines() async  {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key' : _apikey,
      'languaje' : _languaje
    });

    final resp = await  http.get(url); 

    final decodeData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decodeData['results']);

    return peliculas.items;
  }

  Future<List<Pelicula>> getPopulares() async {


    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    print('Cargando Siguientes');

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apikey,
      'languaje' : _languaje,
      'page': _popularesPage.toString()
    });

    final res = await _procesarRespuesta(url);

    _populares.addAll(res);

    popularesSink(_populares);

    _cargando = false;

    return res;

  }

  Future<List<Actor>> getCast(String peliId) async {

    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key' : _apikey,
      'languaje' : _languaje
    });

    final res = await http.get(url);

    final decodeData = json.decode( res.body );

    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;

  }


  
  Future<List<Pelicula>> buscarPelicula(String query) async  {
    final url = Uri.https(_url, '3/search/movie', {
      'api_key' : _apikey,
      'languaje' : _languaje,
      'query': query
    });

    return await _procesarRespuesta(url);
  }
} 