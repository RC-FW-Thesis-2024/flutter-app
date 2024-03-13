import 'package:flutter/material.dart';

import 'api_client.dart';
import 'screens/HomeScreen.dart';
import 'screens/ActivityScreen.dart';

Future<void> main() async {
  runApp(const MyApp());

  var client = APIClient(baseUrl: 'https://eu-west-2.aws.data.mongodb-api.com/app/data-xcipb/endpoint/data/v1/action/find');
  var apiKey = 'QuDD0qTgxpIsOm0viZLuyCOUmRIA5pfOMwPLRCaKzZqufPgksEVq7NSLCxLkqB2b';
  var requestBody = {
    "dataSource": "Cluster0",
    "database": "Thesis",
    "collection": "workouts",
  };

  try {
    String data = await client.fetchData(apiKey, requestBody);
    print(data); // Process your data
  } catch (e) {
    print(e); // Handle any errors
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Thesis app'),
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
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // HomeScreen.dart
    ActivityScreen(), // ActivityScreen.dart
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted),
              label: 'All workouts')
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped
      ),
    );
  }
}
