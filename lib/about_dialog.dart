import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart'; // For GlassCard

class PokerAboutDialog extends StatelessWidget {
  const PokerAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white60 : Colors.black54;
    final bodyColor = isDark ? Colors.white70 : Colors.black87;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App Icon with glow
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(Icons.casino_rounded, size: 60, color: textColor),
              ),
              const SizedBox(height: 16),

              // App Name
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.purple, Colors.blue, Colors.pink],
                ).createShader(bounds),
                child: Text(
                  'Poker Hand Evaluator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              // Tagline
              Text(
                'Real-time Poker Hand Analysis',
                style: TextStyle(
                  fontSize: 14,
                  color: subtitleColor,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),

              // Version
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: 11, color: subtitleColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Description
              Text(
                'A powerful poker hand evaluator that shows your hand in real-time and evaluates it instantly. Built to help players understand poker hands better and make informed decisions at the table.',
                style: TextStyle(fontSize: 13, color: bodyColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // The Story Behind
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '❓ Why was this app built?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'During poker games at Chewata Awaqi x ALX Ethiopia, we realized we lacked proper knowledge of poker hand evaluation. We were constantly searching the internet for hand rankings and comparisons. That\'s when I decided to create this app - a tool we could use right at the table to instantly evaluate hands and learn poker better while playing.',
                      style: TextStyle(fontSize: 13, color: bodyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // What is Poker to Me
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 What is poker to me?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Poker is a way to aura farm (especially around the huzz 😎). I take risks and bluff big time - it\'s pure adrenaline with a reward at the end!',
                      style: TextStyle(fontSize: 13, color: bodyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Who Am I
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👤 Who am I?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BENJAMIN BEKELE',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Software Engineer/Developer & Linguistics Enthusiast',
                      style: TextStyle(fontSize: 13, color: bodyColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '💻 Specialties:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Mobile App Development (Flutter/React Native)\n• Web Development (Frontend/Backend)',
                      style: TextStyle(fontSize: 12, color: bodyColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🛠️ Tech Stack:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _techBadge('Dart/Flutter'),
                        _techBadge('Python'),
                        _techBadge('JavaScript'),
                        _techBadge('React'),
                        _techBadge('Next.js'),
                        _techBadge('Node.js'),
                        _techBadge('Express'),
                        _techBadge('PHP'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🌍 Languages:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Amharic, English, Spanish (+ learning more!)',
                      style: TextStyle(fontSize: 12, color: bodyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Special Thanks
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '💚 Special Thanks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'To God, myself, and my poker jemma!',
                      style: TextStyle(fontSize: 13, color: bodyColor),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Open Source Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.code_outlined, color: bodyColor, size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Open Source • Contributions Welcome',
                        style: TextStyle(
                          color: bodyColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Social links
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  _socialButton(
                    context,
                    Icons.code,
                    'GitHub',
                    'https://github.com/benjamin-bekele/Poker-Hand-Evaluator',
                    isDark,
                  ),
                  _socialButton(
                    context,
                    Icons.email,
                    'Email',
                    'mailto:mr.benjaminbekele@gmail.com',
                    isDark,
                  ),
                  _socialButton(
                    context,
                    Icons.work,
                    'LinkedIn',
                    'https://linkedin.com/in/benjaminbekelealemu',
                    isDark,
                  ),
                  _socialButton(
                    context,
                    Icons.telegram,
                    'Telegram',
                    'https://t.me/benjamin_bekele',
                    isDark,
                  ),
                  _socialButton(
                    context,
                    Icons.alternate_email,
                    'Twitter',
                    'https://twitter.com/benjamin_bekele',
                    isDark,
                  ),
                  _socialButton(
                    context,
                    Icons.camera_alt,
                    'Instagram',
                    'https://instagram.com/benjamin_bekele',
                    isDark,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Footer
              Text(
                '♠️ ♥️ ♦️ ♣️',
                style: TextStyle(fontSize: 24, color: textColor),
              ),
              const SizedBox(height: 8),
              Text(
                '"You\'ve got to know when to hold \'em\nand when to fold \'em"',
                style: TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: bodyColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '— Benjamin Bekele',
                style: TextStyle(fontSize: 11, color: subtitleColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '© 2026 Benjamin Bekele. All Rights Reserved.',
                style: TextStyle(fontSize: 10, color: subtitleColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontFamily: 'Park'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _techBadge(String tech) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.5)),
      ),
      child: Text(
        tech,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _socialButton(
    BuildContext context,
    IconData icon,
    String label,
    String url,
    bool isDark,
  ) {
    return InkWell(
      onTap: () async {
        try {
          final uri = Uri.parse(url);
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not open $label: $e'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black87,
          size: 20,
        ),
      ),
    );
  }
}
