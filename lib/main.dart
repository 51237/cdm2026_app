import 'package:flutter/material.dart';
import 'models/match.dart';
import 'services/world_cup_api.dart';
import 'widgets/match_card.dart';

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('World Cup 2026'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'À venir'),
              Tab(text: 'Résultats'),
            ],
          ),
        ),
        body: FutureBuilder<List<Match>>(
          future: _matchesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur : ${snapshot.error}'));
            }

            final all = snapshot.data!;
            final upcoming = all.where((m) => m.isUpcoming).toList();
            final played = all.where((m) => !m.isUpcoming).toList();

            return TabBarView(
              children: [
                _matchList(upcoming, 'Aucun match à venir'),
                _matchList(played, 'Aucun résultat'),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _matchList(List<Match> matches, String emptyMessage) {
    if (matches.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) => MatchCard(match: matches[index]),
    );
  }
}
