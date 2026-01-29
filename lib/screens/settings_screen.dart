import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/theme_provider.dart';
import '../services/locale_provider.dart';
import '../services/color_provider.dart';
import '../utils/constants.dart';
import '../utils/app_localizations.dart';

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final colorProvider = Provider.of<ColorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr(context, 'settings'),
          style: AppConstants.titleStyle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        children: [
          // Theme Section
          _buildSectionHeader(
            context,
            tr(context, 'theme'),
            Icons.palette_outlined,
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: Text(
                themeProvider.isDarkMode
                    ? tr(context, 'dark_mode')
                    : tr(context, 'light_mode'),
              ),
              subtitle: Text(
                themeProvider.isDarkMode
                    ? tr(context, 'theme_enabled')
                    : tr(context, 'theme_disabled'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
          const SizedBox(height: 24),

          // Language Section
          _buildSectionHeader(
            context,
            tr(context, 'language'),
            Icons.language,
          ),
          const SizedBox(height: 8),
          Card(
            child: SwitchListTile(
              title: Text(
                localeProvider.isArabic ? 'العربية' : 'English',
              ),
              subtitle: Text(
                '${tr(context, 'current_language')}: ${localeProvider.isArabic ? 'العربية' : 'English'}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              secondary: Icon(
                Icons.translate,
                color: Theme.of(context).colorScheme.primary,
              ),
              value: !localeProvider.isArabic,
              onChanged: (value) {
                localeProvider.toggleLanguage();
              },
            ),
          ),
          const SizedBox(height: 24),

          // App Color Section
          _buildSectionHeader(
            context,
            localeProvider.isArabic ? 'لون التطبيق' : 'App Color',
            Icons.color_lens_outlined,
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localeProvider.isArabic
                        ? 'اللون الحالي: ${colorProvider.getColorNameAr()}'
                        : 'Current Color: ${colorProvider.getColorNameEn()}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildColorOption(
                        context,
                        AppColorScheme.blue,
                        const Color(0xFF2196F3),
                        localeProvider.isArabic ? '🔵 الأزرق' : '🔵 Blue',
                        colorProvider,
                      ),
                      _buildColorOption(
                        context,
                        AppColorScheme.purple,
                        const Color(0xFF9C27B0),
                        localeProvider.isArabic ? '🟣 البنفسجي' : '🟣 Purple',
                        colorProvider,
                      ),
                      _buildColorOption(
                        context,
                        AppColorScheme.green,
                        const Color(0xFF4CAF50),
                        localeProvider.isArabic ? '🟢 الأخضر' : '🟢 Green',
                        colorProvider,
                      ),
                      _buildColorOption(
                        context,
                        AppColorScheme.red,
                        const Color(0xFFE53935),
                        localeProvider.isArabic ? '🔴 الأحمر' : '🔴 Red',
                        colorProvider,
                      ),
                      _buildColorOption(
                        context,
                        AppColorScheme.orange,
                        const Color(0xFFFF9800),
                        localeProvider.isArabic ? '🟠 البرتقالي' : '🟠 Orange',
                        colorProvider,
                      ),
                      _buildColorOption(
                        context,
                        AppColorScheme.black,
                        const Color(0xFF424242),
                        localeProvider.isArabic ? '⚫ الأسود' : '⚫ Black',
                        colorProvider,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader(
            context,
            tr(context, 'about'),
            Icons.info_outline,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {

                          return Container(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.note_alt_rounded,
                              color: Theme.of(context).colorScheme.primary,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(
                    tr(context, 'app_name'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(tr(context, 'app_description')),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.verified_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(tr(context, 'version')),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppConstants.appVersion,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Features Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tr(context, 'features'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(context, '📱', tr(context, 'feature_1')),
                  _buildFeatureItem(context, '🎨', tr(context, 'feature_2')),
                  _buildFeatureItem(context, '⭐', tr(context, 'feature_3')),
                  _buildFeatureItem(context, '🔍', tr(context, 'feature_4')),
                  _buildFeatureItem(context, '🌙', tr(context, 'feature_5')),
                  _buildFeatureItem(context, '🌍', tr(context, 'feature_6')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(BuildContext context, String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(
      BuildContext context,
      AppColorScheme colorScheme,
      Color color,
      String label,
      ColorProvider colorProvider,
      ) {
    final isSelected = colorProvider.currentColor == colorScheme;

    return InkWell(
      onTap: () {
        colorProvider.setColor(colorScheme);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 24,
              )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}