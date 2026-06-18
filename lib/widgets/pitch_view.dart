// lib/widgets/pitch_view.dart

import 'package:flutter/material.dart';
import '../models/lineup.dart';

/// A minimalist vertical pitch. team1 fills the bottom half, team2 the top
/// half (mirrored). Within each half, players are spread by formation line:
/// goalkeeper sits on the goal line, forwards near the halfway line.
class PitchView extends StatelessWidget {
  final MatchLineup lineup;
  final Color team1Color;
  final Color team2Color;

  const PitchView({
    super.key,
    required this.lineup,
    this.team1Color = const Color(0xFF1D4ED8),
    this.team2Color = const Color(0xFFDC2626),
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: _PitchPainter(),
          child: Column(
            children: [
              // top half — team2 mirrored (GK at very top)
              Expanded(
                child: _HalfPitch(
                  team: lineup.team2,
                  color: team2Color,
                  goalLineFirst: true,
                ),
              ),
              // bottom half — team1 (GK at very bottom)
              Expanded(
                child: _HalfPitch(
                  team: lineup.team1,
                  color: team1Color,
                  goalLineFirst: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HalfPitch extends StatelessWidget {
  final TeamLineup team;
  final Color color;
  final bool goalLineFirst; // true => GK row rendered at the top of this half

  const _HalfPitch({
    required this.team,
    required this.color,
    required this.goalLineFirst,
  });

  @override
  Widget build(BuildContext context) {
    // formationRows are ordered GK -> DF -> ... -> FW
    final rows = team.formationRows;
    // For the bottom half we want GK closest to the goal line (bottom),
    // so we reverse to render FW first (top) and GK last (bottom).
    final ordered = goalLineFirst ? rows : rows.reversed.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          for (final row in ordered)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final p in row) _PlayerDot(player: p, color: color),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PlayerDot extends StatelessWidget {
  final Player player;
  final Color color;

  const _PlayerDot({required this.player, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 62,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.85), width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1)),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              player.number?.toString() ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            player.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              height: 1.1,
              shadows: [Shadow(color: Colors.black54, blurRadius: 2, offset: Offset(0, 1))],
            ),
          ),
        ],
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // grass
    final grass = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF15803D), Color(0xFF166534)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), grass);

    // mowing stripes
    final stripe = Paint()..color = Colors.white.withOpacity(0.05);
    const stripeH = 28.0;
    for (double y = 0; y < h; y += stripeH * 2) {
      canvas.drawRect(Rect.fromLTWH(0, y, w, stripeH), stripe);
    }

    final line = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // halfway line
    canvas.drawLine(Offset(0, h / 2), Offset(w, h / 2), line);
    // center circle + spot
    canvas.drawCircle(Offset(w / 2, h / 2), 45, line);
    canvas.drawCircle(Offset(w / 2, h / 2), 3,
        Paint()..color = Colors.white.withOpacity(0.7));

    final boxLine = Paint()
      ..color = Colors.white.withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // penalty boxes + goals, top and bottom
    const boxW = 170.0;
    const boxH = 56.0;
    const goalW = 60.0;
    const goalH = 8.0;
    // top
    canvas.drawRect(
        Rect.fromLTWH((w - boxW) / 2, 0, boxW, boxH), boxLine);
    canvas.drawRect(
        Rect.fromLTWH((w - goalW) / 2, 0, goalW, goalH), line);
    // bottom
    canvas.drawRect(
        Rect.fromLTWH((w - boxW) / 2, h - boxH, boxW, boxH), boxLine);
    canvas.drawRect(
        Rect.fromLTWH((w - goalW) / 2, h - goalH, goalW, goalH), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}