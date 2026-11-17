import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/card_model.dart';

class CardState {
  final List<SavedCardModel> cards;

  const CardState({
    required this.cards,
  });

  CardState copyWith({
    List<SavedCardModel>? cards,
  }) {
    return CardState(
      cards: cards ?? this.cards,
    );
  }
}

class CardNotifier extends StateNotifier<CardState> {
  CardNotifier() : super(const CardState(cards: SavedCardModel.initialCards));

  void addCard(SavedCardModel card) {
    state = state.copyWith(
      cards: [card, ...state.cards],
    );
  }

  void removeCard(String id) {
    state = state.copyWith(
      cards: state.cards.where((c) => c.id != id).toList(),
    );
  }
}

final cardProvider = StateNotifierProvider<CardNotifier, CardState>((ref) {
  return CardNotifier();
});
