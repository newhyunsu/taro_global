import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taro/provider/language_provider.dart';

class TarotMenuDrawer extends ConsumerStatefulWidget {
  const TarotMenuDrawer({super.key});

  @override
  ConsumerState<TarotMenuDrawer> createState() => _TarotMenuDrawerState();
}

class _TarotMenuDrawerState extends ConsumerState<TarotMenuDrawer> {
  bool notificationsEnabled = true;
  bool soundEnabled = false;
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(languageProvider);
    final currentLanguageCode = currentLocale.languageCode;

    return Drawer(
      backgroundColor: const Color(0xFF120A24),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF160C2F), Color(0xFF0C0618)],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              _buildHeader(),
              const SizedBox(height: 32),

              _buildSectionTitle('App Settings'),
              _ToggleTile(
                icon: Icons.notifications_none,
                title: 'Notifications',
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
              ),
              _ToggleTile(
                icon: Icons.volume_up_outlined,
                title: 'Sound & Haptics',
                value: soundEnabled,
                onChanged: (value) {
                  setState(() => soundEnabled = value);
                },
              ),
              _MenuTile(
                icon: Icons.language,
                title: 'Language',
                trailing: Text(
                  _languageLabel(currentLanguageCode),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                onTap: () => _showLanguageBottomSheet(currentLanguageCode),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Information'),
              _MenuTile(
                icon: Icons.help_outline,
                title: 'Help / FAQ',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Help 이동
                },
              ),
              _MenuTile(
                icon: Icons.mail_outline,
                title: 'Contact Support',
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Support 이동
                },
              ),
              const SizedBox(height: 32),
              // _buildLogoutButton(context),
              // const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: Text(
                  _appVersion.isEmpty
                      ? 'App Version -'
                      : 'App Version $_appVersion',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadInitialData() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _appVersion = '';
      });
    }
  }

  Future<void> _showLanguageBottomSheet(String currentLanguageCode) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF160C2F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String tempSelection = currentLanguageCode;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Language',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '언어를 선택하고 저장하세요.',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    value: 'en',
                    groupValue: tempSelection,
                    activeColor: const Color(0xFF5F2EEA),
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() => tempSelection = value);
                    },
                    title: const Text(
                      'English',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  RadioListTile<String>(
                    value: 'ko',
                    groupValue: tempSelection,
                    activeColor: const Color(0xFF5F2EEA),
                    onChanged: (value) {
                      if (value == null) return;
                      setModalState(() => tempSelection = value);
                    },
                    title: const Text(
                      '한국어',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5F2EEA),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(tempSelection);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null && mounted) {
      await ref.read(languageProvider.notifier).updateLanguage(selected);
    }
  }

  String _languageLabel(String code) {
    return code == 'ko' ? '한국어' : 'English';
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF5F2EEA), width: 3),
          ),
          child: const CircleAvatar(
            // backgroundImage: AssetImage(
            //   'assets/images/profile_placeholder.png',
            // ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'LunaMystic',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'lun@mystic.com',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 20),
        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: const Color(0xFF5F2EEA),
        //       padding: const EdgeInsets.symmetric(vertical: 14),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(16),
        //       ),
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //       // TODO: 프로필 편집 화면 이동
        //     },
        //     child: const Text(
        //       'Edit Profile',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontSize: 16,
        //         fontWeight: FontWeight.w600,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
      onTap: onTap,
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: const Color(0xFF7A3CF0),
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: Colors.white24,
      ),
    );
  }
}
