import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Shared preferences demo',
      home: MyHomePage(title: 'Shared preferences demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _name = '';
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _counter = prefs.getInt('counter') ?? 0;
        _name = prefs.getString('name') ?? '';
      }
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
    });
    if (_rememberMe) {
      await prefs.setInt('counter', _counter);
    }
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = 0;
    });
    if (_rememberMe) {
      await prefs.remove('counter');
    }
  }

  Future<void> _saveName(String value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = value;
    });
    if (_rememberMe) {
      await prefs.setString('name', _name);
    }
  }

  Future<void> _toggleRememberMe(bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = value ?? false;
    });
    await prefs.setBool('rememberMe', _rememberMe);

    if (!_rememberMe) {
      //Si es falso se eliminan los datos
      await prefs.remove('counter');
      await prefs.remove('name');
    } else {
      //Si es verdadero se guardan los datos
      await prefs.setInt('counter', _counter);
      await prefs.setString('name', _name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: _rememberMe ? Colors.green : Colors.blue,
      ),
      backgroundColor: _rememberMe ? Colors.green[100] : Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Has presionado el boton: ',
            ),
            Text(
              '$_counter veces',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text('Reiniciar'),
            ),
            // Input de nombre con los valores de _name y _saveName
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: TextField(
                controller: TextEditingController(text: _name),
                onChanged: _saveName,
              ),
            ),
            //Recuerdame checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Recuerdame'),
                Checkbox(
                  value: _rememberMe,
                  onChanged: _toggleRememberMe,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
