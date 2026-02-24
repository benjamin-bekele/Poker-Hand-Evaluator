import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'about_dialog.dart';

// -------------------------------
// Card Model & Hand Evaluation (same as before)
// -------------------------------
enum Suit { spades, hearts, diamonds, clubs }

enum Rank {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace,
}

class CardModel {
  final Rank rank;
  final Suit suit;
  CardModel(this.rank, this.suit);
  String get id => '${rank.index}_${suit.index}';
  String get rankChar {
    switch (rank) {
      case Rank.two:
        return '2';
      case Rank.three:
        return '3';
      case Rank.four:
        return '4';
      case Rank.five:
        return '5';
      case Rank.six:
        return '6';
      case Rank.seven:
        return '7';
      case Rank.eight:
        return '8';
      case Rank.nine:
        return '9';
      case Rank.ten:
        return '10';
      case Rank.jack:
        return 'J';
      case Rank.queen:
        return 'Q';
      case Rank.king:
        return 'K';
      case Rank.ace:
        return 'A';
    }
  }

  String get suitChar {
    switch (suit) {
      case Suit.spades:
        return '♠️';
      case Suit.hearts:
        return '♥️';
      case Suit.diamonds:
        return '♦️';
      case Suit.clubs:
        return '♣️';
    }
  }

  int get numericRank {
    switch (rank) {
      case Rank.two:
        return 2;
      case Rank.three:
        return 3;
      case Rank.four:
        return 4;
      case Rank.five:
        return 5;
      case Rank.six:
        return 6;
      case Rank.seven:
        return 7;
      case Rank.eight:
        return 8;
      case Rank.nine:
        return 9;
      case Rank.ten:
        return 10;
      case Rank.jack:
        return 11;
      case Rank.queen:
        return 12;
      case Rank.king:
        return 13;
      case Rank.ace:
        return 14;
    }
  }

  @override
  String toString() => '$rankChar$suitChar';
}

enum HandType {
  highCard,
  onePair,
  twoPair,
  threeOfAKind,
  straight,
  flush,
  fullHouse,
  fourOfAKind,
  straightFlush,
  royalFlush,
}

class HandRank {
  final HandType type;
  final List<int> comparisonRanks;
  final List<CardModel> cards;
  HandRank(this.type, this.comparisonRanks, this.cards);
  int compareTo(HandRank other) {
    if (type.index != other.type.index) return type.index - other.type.index;
    for (int i = 0; i < comparisonRanks.length; i++) {
      if (comparisonRanks[i] != other.comparisonRanks[i])
        return comparisonRanks[i] - other.comparisonRanks[i];
    }
    return 0;
  }

  String get handName {
    switch (type) {
      case HandType.royalFlush:
        return 'Royal Flush';
      case HandType.straightFlush:
        return 'Straight Flush';
      case HandType.fourOfAKind:
        return 'Four of a Kind';
      case HandType.fullHouse:
        return 'Full House';
      case HandType.flush:
        return 'Flush';
      case HandType.straight:
        return 'Straight';
      case HandType.threeOfAKind:
        return 'Three of a Kind';
      case HandType.twoPair:
        return 'Two Pair';
      case HandType.onePair:
        return 'One Pair';
      case HandType.highCard:
        return 'High Card';
    }
  }
}

class HandEvaluator {
  static HandRank? evaluateBestHand(List<CardModel> cards) {
    if (cards.length < 5) return null;
    List<List<CardModel>> combinations = [];
    _combinations(cards, 5, 0, [], combinations);
    HandRank? best;
    for (var combo in combinations) {
      HandRank rank = _evaluateFive(combo);
      if (best == null || rank.compareTo(best) > 0) best = rank;
    }
    return best;
  }

  static void _combinations(
    List<CardModel> list,
    int k,
    int start,
    List<CardModel> current,
    List<List<CardModel>> result,
  ) {
    if (current.length == k) {
      result.add(List.from(current));
      return;
    }
    for (int i = start; i < list.length; i++) {
      current.add(list[i]);
      _combinations(list, k, i + 1, current, result);
      current.removeLast();
    }
  }

  static HandRank _evaluateFive(List<CardModel> cards) {
    cards.sort((a, b) => b.numericRank.compareTo(a.numericRank));
    bool isFlush = cards.every((c) => c.suit == cards.first.suit);
    List<int> ranks = cards.map((c) => c.numericRank).toList();
    bool isStraight = _isStraight(ranks);
    if (!isStraight &&
        ranks[0] == 14 &&
        ranks[1] == 5 &&
        ranks[2] == 4 &&
        ranks[3] == 3 &&
        ranks[4] == 2) {
      isStraight = true;
      ranks = [5, 4, 3, 2, 1];
    }
    Map<int, int> rankCount = {};
    for (var r in ranks) rankCount[r] = (rankCount[r] ?? 0) + 1;
    var counts = rankCount.entries.toList()
      ..sort((a, b) {
        if (a.value != b.value) return b.value.compareTo(a.value);
        return b.key.compareTo(a.key);
      });
    HandType type;
    List<int> comparison = [];
    if (isFlush && isStraight) {
      if (ranks[0] == 14 && ranks[4] == 10)
        type = HandType.royalFlush;
      else
        type = HandType.straightFlush;
      comparison = [ranks[0]];
    } else if (counts[0].value == 4) {
      type = HandType.fourOfAKind;
      comparison = [counts[0].key, counts[1].key];
    } else if (counts[0].value == 3 && counts[1].value == 2) {
      type = HandType.fullHouse;
      comparison = [counts[0].key, counts[1].key];
    } else if (isFlush) {
      type = HandType.flush;
      comparison = ranks;
    } else if (isStraight) {
      type = HandType.straight;
      comparison = [ranks[0]];
    } else if (counts[0].value == 3) {
      type = HandType.threeOfAKind;
      comparison = [counts[0].key, counts[1].key, counts[2].key];
    } else if (counts[0].value == 2 && counts[1].value == 2) {
      type = HandType.twoPair;
      comparison = [counts[0].key, counts[1].key, counts[2].key];
    } else if (counts[0].value == 2) {
      type = HandType.onePair;
      comparison = [counts[0].key, counts[1].key, counts[2].key, counts[3].key];
    } else {
      type = HandType.highCard;
      comparison = ranks;
    }
    return HandRank(type, comparison, cards);
  }

  static bool _isStraight(List<int> ranks) {
    for (int i = 0; i < ranks.length - 1; i++) {
      if (ranks[i] != ranks[i + 1] + 1) return false;
    }
    return true;
  }
}

// -------------------------------
// History Model
// -------------------------------
class HistoryEntry {
  final List<CardModel> holeCards;
  final List<CardModel> communityCards;
  final HandRank bestHand;
  final DateTime timestamp;
  HistoryEntry({
    required this.holeCards,
    required this.communityCards,
    required this.bestHand,
    required this.timestamp,
  });
}

// -------------------------------
// Glassmorphic Card Widget
// -------------------------------
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width, height;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final bool noMargin;
  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.color,
    this.noMargin = false,
  });
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: width,
          height: height,
          margin: noMargin
              ? null
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: padding ?? const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

// -------------------------------
// Animated Card Slot (same as before)
// -------------------------------
class AnimatedCardSlot extends StatelessWidget {
  final CardModel? card;
  final bool isHighlighted;
  final VoidCallback onTap;
  final bool isLoading;
  const AnimatedCardSlot({
    super.key,
    this.card,
    this.isHighlighted = false,
    required this.onTap,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: card != null ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 80,
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isLoading
                ? Colors.transparent
                : (card == null ? Colors.grey[800] : Colors.white),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHighlighted ? Colors.yellow : Colors.grey,
              width: isHighlighted ? 3 : 1,
            ),
            boxShadow: isHighlighted
                ? [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : (card == null
                    ? const Center(
                        child: Icon(Icons.add, color: Colors.white54),
                      )
                    : Center(
                        child: Text(
                          card.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                (card!.suit == Suit.hearts ||
                                    card!.suit == Suit.diamonds)
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      )),
        ),
      ),
    );
  }
}

// -------------------------------
// Card Picker Dialog
// -------------------------------
class CardPickerDialog extends StatelessWidget {
  final List<CardModel> selectedCards;
  final Function(CardModel) onCardPicked;
  const CardPickerDialog({
    super.key,
    required this.selectedCards,
    required this.onCardPicked,
  });
  @override
  Widget build(BuildContext context) {
    final ranks = Rank.values;
    final suits = Suit.values;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        width: 320,
        height: 450,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text(
              'Pick a Card',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.7,
                ),
                itemCount: ranks.length * suits.length,
                itemBuilder: (context, index) {
                  final rank = ranks[index ~/ 4];
                  final suit = suits[index % 4];
                  final card = CardModel(rank, suit);
                  final isSelected = selectedCards.any((c) => c.id == card.id);
                  return AnimatedScale(
                    scale: isSelected ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: GestureDetector(
                      onTap: isSelected
                          ? null
                          : () {
                              onCardPicked(card);
                              Navigator.pop(context);
                            },
                      child: Card(
                        color: isSelected ? Colors.grey : Colors.white,
                        child: Center(
                          child: Text(
                            card.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color:
                                  (suit == Suit.hearts || suit == Suit.diamonds)
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------
// History Dialog
// -------------------------------
class HistoryDialog extends StatelessWidget {
  final List<HistoryEntry> history;
  final Function(HistoryEntry) onLoadEntry;
  final String Function(DateTime) formatTime;

  const HistoryDialog({
    super.key,
    required this.history,
    required this.onLoadEntry,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        width: 400,
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: colorScheme.primary, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'Hand History',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: history.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.history_outlined,
                            size: 60,
                            color: Colors.white54,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No history yet',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Evaluate some hands to see them here',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final entry = history[index];
                        return GestureDetector(
                          onTap: () {
                            onLoadEntry(entry);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary.withOpacity(0.3),
                                  colorScheme.secondary.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        entry.bestHand.handName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getHandColor(
                                          entry.bestHand.type,
                                        ).withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getHandColor(
                                            entry.bestHand.type,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        formatTime(entry.timestamp),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Hole: ${entry.holeCards.join(' ')}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Community: ${entry.communityCards.join(' ')}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 6,
                                  children: entry.bestHand.cards
                                      .map(
                                        (c) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green[800],
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            c.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getHandColor(HandType type) {
    switch (type) {
      case HandType.royalFlush:
      case HandType.straightFlush:
        return const Color(0xFFFFD700);
      case HandType.fourOfAKind:
      case HandType.fullHouse:
        return const Color(0xFFFF6B6B);
      case HandType.flush:
      case HandType.straight:
        return const Color(0xFF00CED1);
      case HandType.threeOfAKind:
      case HandType.twoPair:
        return const Color(0xFFFF8C42);
      default:
        return const Color(0xFFECF0F1);
    }
  }
}

// -------------------------------
// Main Poker Home Page
// -------------------------------
class Poker extends StatefulWidget {
  const Poker({super.key});
  @override
  _PokerState createState() => _PokerState();
}

class _PokerState extends State<Poker> with TickerProviderStateMixin {
  // Cards
  List<CardModel?> handCards = [null, null];
  List<CardModel?> communityCards = List.filled(5, null);
  Set<String> selectedCardIds = {};

  // Evaluation
  HandRank? bestHand;
  Set<String> winningCardIds = {};

  // History
  final List<HistoryEntry> _history = [];
  static const int maxHistory = 10;

  // UI States
  bool _isEvaluating = false;
  bool _showResult = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  List<CardModel> _allSelectedCards() => [
    ...handCards.whereType<CardModel>(),
    ...communityCards.whereType<CardModel>(),
  ];

  void _pickCardForSlot(int slotIndex, bool isHand) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) => CardPickerDialog(
        selectedCards: _allSelectedCards(),
        onCardPicked: (card) {
          setState(() {
            if (isHand) {
              if (handCards[slotIndex] != null)
                selectedCardIds.remove(handCards[slotIndex]!.id);
              handCards[slotIndex] = card;
            } else {
              if (communityCards[slotIndex] != null)
                selectedCardIds.remove(communityCards[slotIndex]!.id);
              communityCards[slotIndex] = card;
            }
            selectedCardIds.add(card.id);
            bestHand = null;
            winningCardIds.clear();
            _showResult = false;
          });
        },
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );
  }

  Future<void> _evaluateHand() async {
    final cards = _allSelectedCards();
    if (cards.length < 5) {
      _showMessage('Need at least 5 cards to evaluate.');
      return;
    }
    setState(() {
      _isEvaluating = true;
      _showResult = false;
    });
    await Future.delayed(const Duration(milliseconds: 600)); // simulate loading
    final result = HandEvaluator.evaluateBestHand(cards);
    setState(() {
      _isEvaluating = false;
      bestHand = result;
      winningCardIds.clear();
      if (result != null) {
        winningCardIds.addAll(result.cards.map((c) => c.id));
        // Add to history
        _history.insert(
          0,
          HistoryEntry(
            holeCards: handCards.whereType<CardModel>().toList(),
            communityCards: communityCards.whereType<CardModel>().toList(),
            bestHand: result,
            timestamp: DateTime.now(),
          ),
        );
        if (_history.length > maxHistory) _history.removeLast();
      }
      _showResult = true;
      _fadeController.forward(from: 0);
      _scaleController.forward(from: 0);
    });
  }

  void _clearAll() {
    setState(() {
      handCards = [null, null];
      communityCards = List.filled(5, null);
      selectedCardIds.clear();
      bestHand = null;
      winningCardIds.clear();
      _showResult = false;
    });
  }

  void _loadHistoryEntry(HistoryEntry entry) {
    setState(() {
      // Clear current selection
      selectedCardIds.clear();
      // Set hole cards
      for (int i = 0; i < entry.holeCards.length; i++) {
        handCards[i] = entry.holeCards[i];
        selectedCardIds.add(entry.holeCards[i].id);
      }
      // Set community cards
      for (int i = 0; i < entry.communityCards.length; i++) {
        communityCards[i] = entry.communityCards[i];
        selectedCardIds.add(entry.communityCards[i].id);
      }
      bestHand = entry.bestHand;
      winningCardIds.addAll(entry.bestHand.cards.map((c) => c.id));
      _showResult = true;
      _fadeController.forward(from: 0);
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _showAbout() {
    showDialog(context: context, builder: (_) => const PokerAboutDialog());
  }

  void _showHistory() {
    showDialog(
      context: context,
      builder: (_) => HistoryDialog(
        history: _history,
        onLoadEntry: _loadHistoryEntry,
        formatTime: _formatTime,
      ),
    );
  }

  // Hand strength suggestion
  String _getHandSuggestion(HandRank hand) {
    switch (hand.type) {
      case HandType.royalFlush:
      case HandType.straightFlush:
      case HandType.fourOfAKind:
      case HandType.fullHouse:
      case HandType.flush:
        return '🔥 Very Strong';
      case HandType.straight:
      case HandType.threeOfAKind:
        return '⚡ Medium';
      case HandType.twoPair:
      case HandType.onePair:
        return '💧 Weak';
      case HandType.highCard:
        return '🌪️ Very Weak';
    }
  }

  Color _suggestionColor(HandRank hand) {
    switch (hand.type) {
      case HandType.royalFlush:
      case HandType.straightFlush:
      case HandType.fourOfAKind:
      case HandType.fullHouse:
      case HandType.flush:
        return Colors.green;
      case HandType.straight:
      case HandType.threeOfAKind:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Poker Hand Evaluator',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showAbout,
          ),
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: _showHistory,
            ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              final themeProvider = ThemeProvider.of(context);
              if (themeProvider != null) {
                themeProvider.toggleTheme();
              }
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _clearAll),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.grey[900]!,
                    Colors.black,
                    Colors.green[900]!.withOpacity(0.3),
                  ]
                : [Colors.green[100]!, Colors.green[50]!, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hand
                  Text(
                    'Your Hand',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      2,
                      (index) => AnimatedCardSlot(
                        card: handCards[index],
                        isHighlighted:
                            handCards[index] != null &&
                            winningCardIds.contains(handCards[index]!.id),
                        onTap: () => _pickCardForSlot(index, true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Community Cards
                  Text(
                    'Community Cards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (index) => AnimatedCardSlot(
                        card: communityCards[index],
                        isHighlighted:
                            communityCards[index] != null &&
                            winningCardIds.contains(communityCards[index]!.id),
                        onTap: () => _pickCardForSlot(index, false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Evaluate Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _isEvaluating ? null : _evaluateHand,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: colorScheme.primary,
                      ),
                      child: _isEvaluating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'EVALUATE',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Result + Suggestion
                  if (_showResult && bestHand != null) ...[
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: GlassCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      bestHand!.handName,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _suggestionColor(
                                        bestHand!,
                                      ).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _suggestionColor(bestHand!),
                                      ),
                                    ),
                                    child: Text(
                                      _getHandSuggestion(bestHand!),
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                children: bestHand!.cards
                                    .map(
                                      (c) => Chip(
                                        label: Text(
                                          c.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.green[800],
                                        avatar: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Text(
                                            c.rankChar,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Poker Hand Rankings
                  _buildRankingItem(
                    context,
                    rank: 1,
                    name: 'Royal Flush',
                    description: 'A, K, Q, J, 10 of same suit',
                    example: 'A♠ K♠ Q♠ J♠ 10♠',
                    icon: '👑',
                    color: const Color(0xFFFFD700),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 2,
                    name: 'Straight Flush',
                    description: '5 cards in sequence, same suit',
                    example: 'J♥ 10♥ 9♥ 8♥ 7♥',
                    icon: '💎',
                    color: const Color(0xFF00CED1),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 3,
                    name: 'Four of a Kind',
                    description: '4 cards of same rank',
                    example: 'K♣ K♦ K♥ K♠ 5♦',
                    icon: '🎯',
                    color: const Color(0xFFFF6B6B),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 4,
                    name: 'Full House',
                    description: '3 of a kind + pair',
                    example: 'Q♠ Q♥ Q♦ 8♣ 8♦',
                    icon: '🏠',
                    color: const Color(0xFFFF8C42),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 5,
                    name: 'Flush',
                    description: '5 cards of same suit',
                    example: 'A♦ J♦ 9♦ 6♦ 3♦',
                    icon: '♠️',
                    color: const Color(0xFF9B59B6),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 6,
                    name: 'Straight',
                    description: '5 cards in sequence',
                    example: '10♣ 9♦ 8♥ 7♠ 6♣',
                    icon: '📊',
                    color: const Color(0xFF3498DB),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 7,
                    name: 'Three of a Kind',
                    description: '3 cards of same rank',
                    example: '9♠ 9♥ 9♦ A♣ 7♠',
                    icon: '🎲',
                    color: const Color(0xFF2ECC71),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 8,
                    name: 'Two Pair',
                    description: '2 different pairs',
                    example: 'J♣ J♦ 4♥ 4♠ K♦',
                    icon: '👥',
                    color: const Color(0xFF95A5A6),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 9,
                    name: 'One Pair',
                    description: '2 cards of same rank',
                    example: '10♠ 10♥ K♣ 8♦ 3♠',
                    icon: '🎴',
                    color: const Color(0xFFBDC3C7),
                  ),
                  _buildRankingItem(
                    context,
                    rank: 10,
                    name: 'High Card',
                    description: 'Highest card wins',
                    example: 'A♣ Q♦ 9♠ 6♥ 2♣',
                    icon: '🃏',
                    color: const Color(0xFFECF0F1),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRankingItem(
    BuildContext context, {
    required int rank,
    required String name,
    required String description,
    required String example,
    required String icon,
    required Color color,
    bool isLast = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      color: _getTextColorForBackground(color),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example,
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return 'Today ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// -------------------------------
// Theme Provider (InheritedWidget)
// -------------------------------
class ThemeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final Function() toggleTheme;

  const ThemeProvider({
    super.key,
    required this.themeMode,
    required this.toggleTheme,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

// -------------------------------
// Main App with Theme Switching
// -------------------------------
void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else if (_themeMode == ThemeMode.dark) {
        _themeMode = ThemeMode.system;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        title: 'Poker Hand Evaluator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: 'Park',
          scaffoldBackgroundColor: Colors.transparent,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'Park',
          scaffoldBackgroundColor: Colors.transparent,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: _themeMode,
        home: const Poker(),
      ),
    );
  }
}
