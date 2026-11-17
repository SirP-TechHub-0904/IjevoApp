import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/linked_bank_model.dart';

class LinkedBankState {
  final List<LinkedBankModel> banks;

  const LinkedBankState({required this.banks});

  LinkedBankState copyWith({List<LinkedBankModel>? banks}) {
    return LinkedBankState(banks: banks ?? this.banks);
  }
}

class LinkedBankNotifier extends StateNotifier<LinkedBankState> {
  LinkedBankNotifier() : super(const LinkedBankState(banks: LinkedBankModel.initialBanks));

  void addBank(LinkedBankModel bank) {
    state = state.copyWith(banks: [...state.banks, bank]);
  }

  void removeBank(String id) {
    state = state.copyWith(banks: state.banks.where((b) => b.id != id).toList());
  }
}

final linkedBankProvider = StateNotifierProvider<LinkedBankNotifier, LinkedBankState>((ref) {
  return LinkedBankNotifier();
});
