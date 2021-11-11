
// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:bradio/app/core/enums/button_state.dart';
import 'package:bradio/app/data/model/radio_stream/radio_stream.dart';
import 'package:bradio/app/process/player_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var stationState = Provider.of<StationState>(context);
    var stationStateNoListen = Provider.of<StationState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('B-Radio player'),
        actions: [_playerButton(stationState, stationStateNoListen)],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: stationState.isLoadError
            ? Center(child: Text(
                'There was an error loading the station list:\n\n'
                '${stationState.loadError}'
                )
              )
            : _playerWithList(stationState, stationStateNoListen, MediaQuery.of(context).size.height / 5),
        ),
      )
    );
  }

  Widget _playerButton(StationState stationState, StationState stationStaeNoListen){
    return stationState.buttonState == ButtonState.notPlaying
      ? Container()
      : stationState.buttonState == ButtonState.playing
        ? IconButton(
            onPressed: () async  => await stationStaeNoListen.pausePlaying(), 
            icon: Icon(FontAwesomeIcons.pause, size: 30)
          )
        : IconButton(
            onPressed: () async  => await stationStaeNoListen.startPlaying(), 
            icon: Icon(FontAwesomeIcons.play, size: 30)
          )
    ;
  }

  Widget _playerWithList(StationState stationState, StationState stationStateNoListen, double playerHeight){
    return Column(
      children: [
        stationState.processingState == ProcessingState.buffering || stationState.processingState == ProcessingState.loading
          ? Container(
              height: playerHeight,
              width: playerHeight,
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: CircularProgressIndicator(),
              )
            )
          : _player(stationState, playerHeight),
        Expanded(
          child: _stationList(stationState, stationStateNoListen)
        )
      ],
    );
  }

  Widget _player (StationState stationState, double playerHeight){
    return Container(
      height: playerHeight, //,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: 
          Text(
            stationState.isPlayerError
              ? 'There was a problem playing ${stationState.currentStation}.\n\n${stationState.playerError}'
              : '${stationState.currentStation}${stationState.whatsOnNow}'
          ),
        ),
      ),
    );
  }

  Widget _stationList(StationState stationState, StationState playerStateNoListen){
    return ListView.builder(
      itemCount: stationState.stationCount,
      itemBuilder: (_, idx) {
        var _station = stationState.stationList[idx];
        return _stationCard(stationState, playerStateNoListen, _station);
      }
    );
  }

  Widget _stationCard(StationState stationState,  StationState stationStateNoListen, RadioStream station) {
    bool isActive = stationState.currentStation == station.name;
    return Card(
      elevation: stationState.currentStation == station.name ? 0 : 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isActive ? Colors.teal.shade900 : Colors.grey, width: isActive ? 4 : 0),
      ),
      child: ListTile(
        title: Text(station.name),
        subtitle: Text(station.tags),
        onTap: () => stationStateNoListen.playStream(station.name),
      ),
    );
  }
}