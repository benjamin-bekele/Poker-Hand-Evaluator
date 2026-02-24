import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.black, Colors.grey[900]!, Colors.green[900]!]
              : [Colors.green[100]!, Colors.green[50]!, Colors.white],
        ),
      ),
      child: child,
    );
  }
}

class PokerHandRankingPage extends StatelessWidget {
  const PokerHandRankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'POKER HAND RANKINGS',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildGlassCard(
                    context,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Poker hand ranking',
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader =
                                      LinearGradient(
                                        colors: [
                                          Colors.purple,
                                          Colors.blue,
                                          Colors.pink,
                                        ],
                                      ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 70),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildHandRankingsContent(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, {required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildHandRankingsContent(BuildContext context) {
    return Column(
      children: [
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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
                    style: GoogleFonts.inter(
                      color: _getTextColor(color),
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
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      example,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const SizedBox(height: 12),
      ],
    );
  }

  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
