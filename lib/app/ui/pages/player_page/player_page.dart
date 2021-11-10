
// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:bradio/app/core/enums/button_state.dart';
import 'package:bradio/app/data/model/radio_stream/radio_stream.dart';
import 'package:bradio/app/process/player_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var playerState = Provider.of<PlayerState>(context);
    var playerStateNoListen = Provider.of<PlayerState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('B-Radio player'),
        actions: [_playerButton(playerState, playerStateNoListen)],
      ),
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: playerState.isLoadError
            ? Center(child: Text(
                'There was an error loading the station list:\n\n'
                '${playerState.loadError}'
                )
              )
            : _playerWithList(playerState, playerStateNoListen, MediaQuery.of(context).size.height / 5),
        ),
      )
    );
  }

  Widget _playerButton(PlayerState playerState, PlayerState playerStateNoListen){
    return playerState.buttonState == ButtonState.notPlaying
      ? Container()
      : playerState.buttonState == ButtonState.playing
        ? IconButton(
            onPressed: () async  => await playerStateNoListen.pausePlaying(), 
            icon: Icon(FontAwesomeIcons.pause, size: 30)
          )
        : IconButton(
            onPressed: () async  => await playerStateNoListen.startPlaying(), 
            icon: Icon(FontAwesomeIcons.play, size: 30)
          )
    ;
  }

  Widget _playerWithList(PlayerState playerState, PlayerState playerStateNoListen, double playerHeight){
    return Column(
      children: [
        _player(playerState, playerHeight),
        Expanded(
          child: _stationList(playerState, playerStateNoListen)
        )
      ],
    );
  }

  Widget _player (PlayerState playerState, double playerHeight){
    return Container(
      height: playerHeight, //,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            playerState.isPlayerError
              ? 'There was a problem playing ${playerState.currentStation}.\n\n${playerState.playerError}'
              : '${playerState.currentStation}${playerState.whatsOnNow}'
          ),
        ),
      ),
    );
  }

  Widget _stationList(PlayerState playerState, PlayerState playerStateNoListen){
    return ListView.builder(
      itemCount: playerState.stationCount,
      itemBuilder: (_, idx) {
        var _station = playerState.stationList[idx];
        return _stationCard(playerState, playerStateNoListen, _station);
      }
    );
  }

  Widget _stationCard(PlayerState playerState,  PlayerState playerStateNoListen, RadioStream station) {
    bool isActive = playerState.currentStation == station.name;
    return Card(
      elevation: playerState.currentStation == station.name ? 0 : 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isActive ? Colors.teal.shade900 : Colors.grey, width: isActive ? 4 : 0),
      ),
      child: ListTile(
        title: Text(station.name),
        subtitle: Text(station.tags),
        onTap: () => playerStateNoListen.playStream(station.name),
      ),
    );
  }
}