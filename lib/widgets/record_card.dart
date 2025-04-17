import 'package:auto_healthbot/utils.dart';
import 'package:flutter/material.dart';


class RecordCard extends StatelessWidget {
  final String date;
  final int score;
  final String issue;

  const RecordCard({
    required this.date,
    required this.score,
    required this.issue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = getHealthColor(score).withOpacity(1.0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date, style: const TextStyle(fontSize: 24)),
          Text('건강점수: $score점', style: const TextStyle(fontSize: 24)),
          Text('주요 이슈: $issue', style: const TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
