

// ignore_for_file: prefer_const_constructors, prefer_conditional_assignment

import 'dart:async';

import 'package:bradio/app/core/enums/button_state.dart';
import 'package:bradio/app/data/model/radio_stream/radio_stream.dart';
import 'package:bradio/app/data/services/stream_service.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';

class StationState extends ChangeNotifier{

  late StreamSubscription _processingStateListener;
  late Timer _whatsonTimer;

  

  StationState(){
    // if (_processingStateListener == null){
      _processingStateListener = _player.processingStateStream.listen((state) {
          _processingState = state;
          notifyListeners();
        }
      );     
    // }
    // if(_whatsonTimer == null){
      _whatsonTimer = Timer.periodic(Duration(milliseconds: 1000), (timer) { 
        _getWhatsOn();
      });
    // }
  }
  final _player = AudioPlayer(userAgent: 'bradioCL');
  
  List<RadioStream> get stationList => StreamService.streamList;
  bool get isLoadError => StreamService.isLoadError;
  String get loadError => StreamService.loadError;
  int get stationCount => StreamService.streamList.length;


  String _currentStation = 'No Station Selected';
  String get currentStation => _currentStation;

  bool _isPlayerError = false;
  bool get isPlayerError => _isPlayerError;

  String _playerError = '';
  String get playerError => _playerError;


  String _whatsOnNow = '';
  String get whatsOnNow => _whatsOnNow;

  ButtonState _buttonState = ButtonState.notPlaying;
  ButtonState get buttonState => _buttonState;

  ProcessingState _processingState = ProcessingState.idle;
  ProcessingState get processingState => _processingState;
  
  @override
  void dispose(){
    _processingStateListener.cancel();
    _whatsonTimer.cancel();
    _player.dispose();
    super.dispose();
  }

  playStream(String station) async {
    
    if(station == _currentStation){
      return;
    }
    if(!_player.playing && _player.processingState == ProcessingState.loading){
      return;
    }

    _currentStation = station;
    _isPlayerError = false;
    _playerError = '';
    _whatsOnNow = '';
    _buttonState = ButtonState.notPlaying;
    notifyListeners();
    //if player is busy loading exit 
    try {

      if(_player.playing){
        await _player.stop();
        _buttonState = ButtonState.notPlaying;
      }

      String url = StreamService.getUrl(station);
      if(url.isEmpty){
        _isPlayerError = true;
        _playerError = 'URL not found';
        throw('URL not found');
      }

      await _player.setUrl(url);
      await _player.load();
      startPlaying();

    } catch (e) {
      _isPlayerError = true;
      _buttonState = ButtonState.notPlaying;
      StreamService.removeStationbyName(station);
    } finally{
      notifyListeners();
    }    
  }

  void _getWhatsOn() {
    var _what = '';    
    if(_player.playing && _player.icyMetadata != null){
      _what = _player.icyMetadata?.info?.title ?? '';
      // debugPrint('_getWhatson=$_what');
      if(_what.isNotEmpty){
        _what = ':\n$_what';
      }
    }
    if(_what != _whatsOnNow){
      _whatsOnNow = _what;
      notifyListeners();
    }
  }

  Future<void> startPlaying() async {
    if(!_player.playing){
      _buttonState = ButtonState.playing;
      Future.delayed(Duration(milliseconds: 50), () async {
        try {          
          await _player.play();
        } catch(e) {
          _buttonState = ButtonState.notPlaying;          
          _isPlayerError = true;
          _playerError = 'Could not play the stream. \n\n$e';
        }
      });
      
      notifyListeners();
    }
  }

  pausePlaying() async {
    if(_player.playing){
      try {
        _isPlayerError = false;
        _playerError = '';
        await _player.stop();
        _buttonState = ButtonState.paused;
      } catch (e) {
        _buttonState = ButtonState.notPlaying;
        _isPlayerError = true;
        _playerError = 'Could not stop player: $e';
      }
      notifyListeners();
    }
  }

}