import 'package:flutter/material.dart';

class RewardPopup extends StatelessWidget {
  final int points;
  final String category;

  const RewardPopup({super.key, required this.points, required this.category});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFFFC700), width: 3),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.catching_pokemon, size: 72, color: Color(0xFFFFC700)),
          const SizedBox(height: 12),
          Text(
            'Reward Unlocked!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF28C76F),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Category: $category\n+$points Pokemon Coins',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Awesome!'),
        ),
      ],
    );
  }
}
