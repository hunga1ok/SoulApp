import 'package:flutter/material.dart';

import 'card_decks_hub_screen.dart';
import 'cards_draw_screen.dart';

export 'card_decks_hub_screen.dart';
export 'card_flip_widget.dart';
export 'cards_draw_screen.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key, this.initialDeckId});

  final String? initialDeckId;

  @override
  Widget build(BuildContext context) {
    if (initialDeckId != null && initialDeckId!.isNotEmpty) {
      return CardsDrawScreen(deckId: initialDeckId!);
    }
    return const CardDecksHubScreen();
  }
}
