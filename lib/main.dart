import 'package:flutter/material.dart';
import 'models/match.dart';
import 'services/world_cup_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Cup 2026',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WorldCupApi _api = WorldCupApi();
  late Future<List<Match>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = _api.fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Cup 2026'), centerTitle: true),
      body: FutureBuilder<List<Match>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }

          final matches = snapshot.data!;
          final first = matches.first;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${matches.length} matches chargés',
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 16),
                Text('${first.team1} vs ${first.team2}'),
                Text('${first.date} • ${first.time}'),
                Text('${first.group} • ${first.ground}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
