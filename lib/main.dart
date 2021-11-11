import 'package:bradio/app/data/services/stream_service.dart';
import 'package:bradio/app/data/services/stream_service.dart';
import 'package:bradio/app/process/app_state_provider.dart';
import 'package:bradio/app/process/player_state_provider.dart';
import 'package:bradio/app/ui/pages/home_page/home_page.dart';
import 'package:bradio/app/ui/pages/player_page/player_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async  {
  await StreamService.getStreams();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState> (create: (_) => AppState()),
        ChangeNotifierProvider<StationState> (create: (_) => StationState()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
       home: const PlayerPage(), //HomePage()
    );
  }
}



