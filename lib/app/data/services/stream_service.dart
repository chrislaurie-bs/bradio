
import 'dart:convert';

import 'package:bradio/app/data/model/radio_stream/radio_stream.dart';
import 'package:http/http.dart' as http;

class StreamService{
  static final List<RadioStream> _streamList = [];
  static List<RadioStream> get streamList => _streamList;

  static bool _busyLoading = false;
  static bool get busyLoading => _busyLoading;

  static bool _isLoadError = false;
  static bool get isLoadError => _isLoadError;

  static String _loadError = '';
  static String get loadError => _loadError;

  static Future<void> getStreams() async {
    //get json from api 
    _busyLoading = true;
    _isLoadError = false;
    _loadError = '';
    const uri = 'https://nl1.api.radio-browser.info/json/stations/bycountry/netherlands?hidebroken=true';
    final url = Uri.parse(uri);
    try {      
      var response = await http.get(url);
      if(response.statusCode == 200){
        var body = utf8.decode(response.bodyBytes);
        var stationsJson = jsonDecode(body);
        for(var jStream in stationsJson){
          var _stream = RadioStream.fromMap(jStream);
          int idx = _streamList.indexWhere((iStream) => iStream.name.trim() == _stream.name.trim());
          if(idx < 0 ) {
            _streamList.add(_stream);
          } else if(
            _stream.bitrate > _streamList[idx].bitrate
          ){
            _streamList[idx] = _stream;
          }
        }
        _streamList.sort((a,b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      } else {
        _isLoadError = true;
        _loadError = response.reasonPhrase ?? 'Unable to load stations.';
      }
    } on Exception catch (e) {
      _isLoadError = true;
      _loadError = e.toString();
    }
    _busyLoading = false;
  }

  static String getUrl(String station) {
    var idx = _streamList.indexWhere((element) => element.name == station);
    if(idx < 0){
      return '';
    } else {
      return _streamList[idx].urlResolved;
    }
  }

  static void removeStationbyName(String station) {
    var idx = _streamList.indexWhere((element) => element.name == station);
    if(idx >= 0){
      _streamList.removeAt(idx);
    }

  }

}