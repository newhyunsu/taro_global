import 'package:flutter/material.dart';

class TarotMenuDrawer extends StatelessWidget {
  const TarotMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2D1B4E),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFFFD700),
              child: Icon(
                Icons.auto_awesome,
                size: 40,
                color: Color(0xFF1A0B2E),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tarot Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuItem(
              context,
              icon: Icons.history,
              title: 'History',
              onTap: () {
                Navigator.pop(context);
                // TODO: History 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.style,
              title: 'Card Meanings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Card Meanings 화면으로 이동
              },
            ),
            _buildMenuItem(
              context,
              icon: Icons.settings,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);
                // TODO: Settings 화면으로 이동
              },
            ),
            const Spacer(),
            const Divider(color: Colors.white24),
            _buildMenuItem(
              context,
              icon: Icons.info_outline,
              title: 'About',
              onTap: () {
                Navigator.pop(context);
                // TODO: About 화면으로 이동
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
