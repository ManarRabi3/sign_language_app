import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _hapticFeedback = true;
  bool _autoSpeak = true;
  double _speakingSpeed = 1.0;
  double _signSpeed = 1.0;
  String _selectedVoice = 'انثى';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionHeader('المظهر'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.dark_mode,
              title: 'الوضع الداكن',
              subtitle: 'تفعيل المظهر الداكن',
              value: _darkMode,
              onChanged: (value) => setState(() => _darkMode = value),
            ),
            _buildDivider(),
            _buildSwitchTile(
              icon: Icons.vibration,
              title: 'الاهتزاز',
              subtitle: 'اهتزاز عند التعرف على اشارة',
              value: _hapticFeedback,
              onChanged: (value) => setState(() => _hapticFeedback = value),
            ),
          ]),

          const SizedBox(height: 24),

          // Speech Section
          _buildSectionHeader('الصوت'),
          _buildSettingsCard([
            _buildSwitchTile(
              icon: Icons.volume_up,
              title: 'نطق تلقائيًا',
              subtitle: 'نطق الكلمات عند التعرف عليها',
              value: _autoSpeak,
              onChanged: (value) => setState(() => _autoSpeak = value),
            ),
            _buildDivider(),
            _buildDropdownTile(
              icon: Icons.record_voice_over,
              title: 'نوع الصوت',
              value: _selectedVoice,
              options: const ['انثى', 'ذكر'],
              onChanged: (value) => setState(() => _selectedVoice = value!),
            ),
            _buildDivider(),
            _buildSliderTile(
              icon: Icons.speed,
              title: 'سرعة النطق',
              value: _speakingSpeed,
              min: 0.5,
              max: 2.0,
              onChanged: (value) => setState(() => _speakingSpeed = value),
            ),
          ]),

          const SizedBox(height: 24),

          // Avatar Section
          _buildSectionHeader('الأفاتار'),
          _buildSettingsCard([
            _buildSliderTile(
              icon: Icons.accessibility_new,
              title: 'سرعة الإشارة',
              value: _signSpeed,
              min: 0.5,
              max: 2.0,
              onChanged: (value) => setState(() => _signSpeed = value),
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.person,
              title: 'تخصيص الأفاتار',
              subtitle: 'تغيير مظهر الأفاتار',
              onTap: () {
                // TODO: Avatar customization
              },
            ),
          ]),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('حول التطبيق'),
          _buildSettingsCard([
            _buildNavigationTile(
              icon: Icons.info_outline,
              title: 'عن التطبيق',
              subtitle: 'الإصدار 1.0.0',
              onTap: _showAboutDialog,
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.privacy_tip_outlined,
              title: 'سياسة الخصوصية',
              onTap: () {
                // TODO: Privacy policy
              },
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.star_outline,
              title: 'قيم التطبيق',
              onTap: () {
                // TODO: Rate app
              },
            ),
            _buildDivider(),
            _buildNavigationTile(
              icon: Icons.mail_outline,
              title: 'اتصل بنا',
              onTap: () {
                // TODO: Contact
              },
            ),
          ]),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'الإصدار 1.0.0',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'صنع بحب فى مصر © 2026',
              style: TextStyle(
                color: AppColors.grey500,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      color: AppColors.grey200,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      trailing: DropdownButton<String>(
        value: value,
        underline: const SizedBox(),
        items: options
            .map((option) => DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Slider(
        value: value,
        min: min,
        max: max,
        divisions: ((max - min) * 10).toInt(),
        label: '${value.toStringAsFixed(1)}x',
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: Icon(Icons.chevron_left, color: AppColors.grey500),
      onTap: onTap,
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.sign_language, color: AppColors.primary),
            SizedBox(width: 12),
            Text(' مترجم لغة الاشارة'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الإصدار 1.0.0'),
            SizedBox(height: 8),
            Text(
              'تطبيق لترجمة لغة الإشارة المصرية للنص والعكس، يشمل فيديوهات وشرح للعلامات الأساسية. مصمم لمساعدة الصم والبكم على  التواصل  بسهولة.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'تم تطويره كا مشروع تخرج.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
