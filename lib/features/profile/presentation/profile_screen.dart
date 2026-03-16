import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../tracking/providers/tracker_provider.dart';
import '../../onboarding/onboarding_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isButtonHovered = false;

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF161618),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Sair e Apagar Dados?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Isso vai zerar o seu progresso de hoje e o seu perfil. Tem certeza?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); 
              
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sim, Apagar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTile({
    required IconData icon,
    required String title,
    required String trailing,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [Colors.grey.shade900, const Color(0xFF1A1A24)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.02), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28).animate(onPlay: (c) => c.repeat(reverse: true)).scaleXY(begin: 1.0, end: 1.1, duration: 1.seconds),
          const SizedBox(width: 16),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(
            trailing, 
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tracker = context.watch<TrackerProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F12),
      appBar: AppBar(
        title: const Text('Meu Perfil', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Elastic Avatar
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.deepPurpleAccent.withOpacity(0.4), blurRadius: 20, spreadRadius: 4),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 54,
                  backgroundColor: Color(0xFF161618),
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ).animate().scale(duration: 800.ms, curve: Curves.elasticOut),
            ),
            const SizedBox(height: 16),
            
            Text(
              tracker.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
            ).animate().fade().slideY(begin: 0.2),
            
            const SizedBox(height: 48),
            
            const Text('Minhas Metas', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold))
                .animate().fade().slideY(begin: 0.1),
            const SizedBox(height: 16),
            
            _buildGlassTile(
              icon: Icons.monitor_weight_outlined,
              title: 'Peso Atual',
              trailing: '${tracker.currentWeight} kg',
              iconColor: Colors.deepPurpleAccent,
            ).animate().fade(delay: 100.ms).slideX(begin: 0.05),
            
            const SizedBox(height: 16),
            
            _buildGlassTile(
              icon: Icons.flag_outlined,
              title: 'Peso Alvo',
              trailing: '${tracker.goalWeight} kg',
              iconColor: Colors.blueAccent,
            ).animate().fade(delay: 200.ms).slideX(begin: 0.05),
            
            const SizedBox(height: 64),
            
            // Ghost Shake Button
            GestureDetector(
              onTapDown: (_) => setState(() => _isButtonHovered = true),
              onTapUp: (_) {
                setState(() => _isButtonHovered = false);
                _confirmLogout(context);
              },
              onTapCancel: () => setState(() => _isButtonHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                transform: Matrix4.identity()..scale(_isButtonHovered ? 0.95 : 1.0),
                transformAlignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.8), width: 1.5),
                  boxShadow: [
                    if (_isButtonHovered)
                      BoxShadow(color: Colors.redAccent.withOpacity(0.2), blurRadius: 15, spreadRadius: 2)
                  ]
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout, color: Colors.redAccent),
                    const SizedBox(width: 12),
                    Text(
                      'Sair e Refazer Onboarding', 
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.redAccent,
                        shadows: [Shadow(color: Colors.redAccent.withOpacity(0.5), blurRadius: 5)],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(target: _isButtonHovered ? 1 : 0).shake(hz: 8, rotation: 0.05),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}