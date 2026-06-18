// lib/screens/match_detail_screen.dart

import 'package:flutter/material.dart';
import '../models/match.dart';
import '../models/lineup.dart';
import '../widgets/pitch_view.dart';

class MatchDetailScreen extends StatelessWidget {
  final Match match;
  final MatchLineup? lineup;
  final Map<String, String> flags;

  const MatchDetailScreen({
    super.key,
    required this.match,
    required this.lineup,
    this.flags = const {},
  });

  String _frDate(String iso) {
    final parts = iso.split('-').map(int.parse).toList();
    const days = ['lundi','mardi','mercredi','jeudi','vendredi','samedi','dimanche'];
    const months = ['janvier','février','mars','avril','mai','juin','juillet',
      'août','septembre','octobre','novembre','décembre'];
    final dt = DateTime.utc(parts[0], parts[1], parts[2]);
    return '${days[dt.weekday - 1]} ${parts[2]} ${months[parts[1] - 1]} ${parts[0]}';
  }

  String _flag(String team) => flags[team] ?? '';

  @override
  Widget build(BuildContext context) {
    final ft = match.scoreFt;
    final scoreText = ft != null ? '${ft[0]} - ${ft[1]}' : '–';

    return Scaffold(
      appBar: AppBar(
        title: Text('${match.team1} – ${match.team2}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ---- header: date + score ----
            Text(
              _frDate(match.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          match.team1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(_flag(match.team1), style: const TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    scoreText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_flag(match.team2), style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          match.team2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ---- pitch or fallback ----
            if (lineup != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _legendDot(const Color(0xFF1D4ED8),
                      '${match.team1} · ${lineup!.team1.formation}'),
                  const SizedBox(width: 20),
                  _legendDot(const Color(0xFFDC2626),
                      '${match.team2} · ${lineup!.team2.formation}'),
                ],
              ),
              const SizedBox(height: 12),
              PitchView(lineup: lineup!),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Text(
                  'Composition indisponible pour ce match.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 9, height: 9,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
      ],
    );
  }
}