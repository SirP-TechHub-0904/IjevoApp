import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import '../models/recipient_model.dart';

class ActivityState {
  final List<TransactionModel> transactions;
  final List<RecipientModel> savedRecipients;
  final String searchQuery;

  const ActivityState({
    required this.transactions,
    required this.savedRecipients,
    this.searchQuery = '',
  });

  List<TransactionModel> get filteredTransactions {
    if (searchQuery.isEmpty) return transactions;
    final q = searchQuery.toLowerCase();
    return transactions.where((tx) {
      return tx.recipientName.toLowerCase().contains(q) ||
          tx.referenceNumber.toLowerCase().contains(q) ||
          tx.recipientInstitution.toLowerCase().contains(q);
    }).toList();
  }

  ActivityState copyWith({
    List<TransactionModel>? transactions,
    List<RecipientModel>? savedRecipients,
    String? searchQuery,
  }) {
    return ActivityState(
      transactions: transactions ?? this.transactions,
      savedRecipients: savedRecipients ?? this.savedRecipients,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier()
      : super(
          ActivityState(
            transactions: TransactionModel.sampleTransactions,
            savedRecipients: RecipientModel.sampleRecipients,
          ),
        );

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void addTransaction(TransactionModel tx) {
    state = state.copyWith(
      transactions: [tx, ...state.transactions],
    );
  }

  void addRecipient(RecipientModel recipient) {
    state = state.copyWith(
      savedRecipients: [recipient, ...state.savedRecipients],
    );
  }

  void deleteRecipient(String recipientId) {
    state = state.copyWith(
      savedRecipients: state.savedRecipients.where((r) => r.id != recipientId).toList(),
    );
  }
}

final activityProvider = StateNotifierProvider<ActivityNotifier, ActivityState>((ref) {
  return ActivityNotifier();
});
