import 'package:flutter/material.dart';
import '../models/match.dart';

class MatchCard extends StatelessWidget {
  final Match match;
  final Map<String, String> flags;

  const MatchCard({super.key, required this.match, required this.flags});

  @override
  Widget build(BuildContext context) {
    final played = !match.isUpcoming;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${match.group ?? match.round} • ${match.date}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            Row(
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
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _flagFor(match.team1),
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    played
                        ? '${match.scoreFt![0]} - ${match.scoreFt![1]}'
                        : match.time,
                    style: TextStyle(
                      fontSize: played ? 18 : 13,
                      fontWeight: played ? FontWeight.bold : FontWeight.normal,
                      color: played ? Colors.black : Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _flagFor(match.team2),
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          match.team2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (played &&
                (match.goals1.isNotEmpty || match.goals2.isNotEmpty)) ...[
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _goalsColumn(match.goals1, TextAlign.end)),
                  const SizedBox(width: 24),
                  Expanded(child: _goalsColumn(match.goals2, TextAlign.start)),
                ],
              ),
            ],

            const SizedBox(height: 8),
            Text(
              match.ground,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalsColumn(List<Goal> goals, TextAlign align) {
    return Column(
      crossAxisAlignment: align == TextAlign.end
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: goals
          .map(
            (g) => Text(
              '${g.name} ${g.minute}\'',
              textAlign: align,
              style: TextStyle(fontSize: 11, color: Colors.grey[700]),
            ),
          )
          .toList(),
    );
  }

  String _flagFor(String teamName) => flags[teamName] ?? '';
}
