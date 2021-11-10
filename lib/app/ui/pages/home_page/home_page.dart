
import 'package:bradio/app/process/app_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Button presses:',
            ),
            Text(
              appState.counter.toString(),
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: _actionButtons(context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _actionButtons(BuildContext context){
    var appState = Provider.of<AppState>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        
        FloatingActionButton(
            onPressed: () => appState.incrementCounter(incBy: -1),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
            backgroundColor: Colors.red,
          ),
        SizedBox(width: 10,),
        FloatingActionButton(
            onPressed: () => appState.incrementCounter(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
      ],
    );
  }

}
