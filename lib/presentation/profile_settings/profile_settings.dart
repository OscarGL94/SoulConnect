import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/expandable_section_widget.dart';
import './widgets/multi_select_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/range_slider_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/slider_setting_widget.dart';
import './widgets/switch_setting_widget.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  // Mock user profile data
  final Map<String, dynamic> userProfile = {
    "id": 1,
    "name": "Luna Esperanza",
    "age": 32,
    "location": "Madrid, España",
    "profileImage":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "spiritualBio":
        "Explorando la conexión entre el alma y el universo a través de la meditación y el yoga. Buscando almas gemelas para crecer juntos en este viaje espiritual.",
    "interests": ["Meditación", "Yoga", "Astrología", "Tarot"],
    "connectionPurposes": ["Amistad", "Romance", "Colaboración Espiritual"],
    "energyType": "Femenino Divino",
    "spiritualTools": ["Tarot", "Cristales", "Respiración", "Yoga"]
  };

  // Settings state variables
  bool _locationPrivacy = true;
  bool _showOnlineStatus = false;
  bool _matchNotifications = true;
  bool _messageNotifications = true;
  bool _communityNotifications = false;
  bool _profileVisibility = true;
  bool _showAge = true;
  bool _showDistance = true;

  double _distanceRadius = 50.0;
  RangeValues _ageRange = const RangeValues(25, 45);

  List<String> _selectedInterests = ["Meditación", "Yoga", "Astrología"];
  List<String> _selectedConnectionPurposes = ["Amistad", "Romance"];
  List<String> _selectedSpiritualTools = ["Tarot", "Cristales"];
  String _selectedEnergyType = "Femenino Divino";
  String _selectedLanguage = "Español";

  // Available options
  final List<String> _availableInterests = [
    "Meditación",
    "Yoga",
    "Astrología",
    "Tarot",
    "Plantas Sagradas",
    "Tantra",
    "Cristales",
    "Reiki",
    "Chakras",
    "Mindfulness"
  ];

  final List<String> _availableConnectionPurposes = [
    "Amistad",
    "Romance",
    "Colaboración Espiritual",
    "Mentoría",
    "Círculos Sagrados"
  ];

  final List<String> _availableSpiritualTools = [
    "Tarot",
    "Cristales",
    "Respiración",
    "Yoga",
    "Meditación",
    "Canto",
    "Danza",
    "Rituales",
    "Journaling",
    "Oráculo"
  ];

  final List<String> _energyTypes = [
    "Femenino Divino",
    "Masculino Divino",
    "Energía Mixta",
    "Fluido"
  ];

  final List<String> _languages = [
    "Español",
    "Español (México)",
    "Español (Argentina)",
    "Español (Colombia)"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Configuración del Perfil',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 5.w,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),

            // Profile Header
            ProfileHeaderWidget(
              userProfile: userProfile,
              onEditProfile: () =>
                  Navigator.pushNamed(context, '/profile-creation'),
            ),

            SizedBox(height: 3.h),

            // Spiritual Preferences Section
            SettingsSectionWidget(
              title: 'Preferencias Espirituales',
              children: [
                ExpandableSectionWidget(
                  title: 'Intereses Espirituales',
                  subtitle: '${_selectedInterests.length} seleccionados',
                  iconName: 'favorite',
                  child: MultiSelectWidget(
                    title: 'Selecciona tus intereses',
                    options: _availableInterests,
                    selectedOptions: _selectedInterests,
                    onSelectionChanged: (selected) {
                      setState(() => _selectedInterests = selected);
                    },
                    showBorder: false,
                  ),
                ),
                ExpandableSectionWidget(
                  title: 'Propósitos de Conexión',
                  subtitle:
                      '${_selectedConnectionPurposes.length} seleccionados',
                  iconName: 'people',
                  child: MultiSelectWidget(
                    title: '¿Qué buscas?',
                    options: _availableConnectionPurposes,
                    selectedOptions: _selectedConnectionPurposes,
                    onSelectionChanged: (selected) {
                      setState(() => _selectedConnectionPurposes = selected);
                    },
                    showBorder: false,
                  ),
                ),
                ExpandableSectionWidget(
                  title: 'Tipo de Energía',
                  subtitle: _selectedEnergyType,
                  iconName: 'psychology',
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      children: _energyTypes.map((type) {
                        return RadioListTile<String>(
                          title: Text(
                            type,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          value: type,
                          groupValue: _selectedEnergyType,
                          onChanged: (value) {
                            setState(() => _selectedEnergyType = value!);
                          },
                          activeColor: AppTheme.lightTheme.colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                ExpandableSectionWidget(
                  title: 'Herramientas Espirituales',
                  subtitle: '${_selectedSpiritualTools.length} seleccionadas',
                  iconName: 'auto_fix_high',
                  showBorder: false,
                  child: MultiSelectWidget(
                    title: 'Herramientas que usas',
                    options: _availableSpiritualTools,
                    selectedOptions: _selectedSpiritualTools,
                    onSelectionChanged: (selected) {
                      setState(() => _selectedSpiritualTools = selected);
                    },
                    showBorder: false,
                  ),
                ),
              ],
            ),

            // Discovery Settings Section
            SettingsSectionWidget(
              title: 'Configuración de Descubrimiento',
              children: [
                SwitchSettingWidget(
                  title: 'Privacidad de Ubicación',
                  subtitle: 'Solo mostrar ciudad, no ubicación exacta',
                  iconName: 'location_on',
                  value: _locationPrivacy,
                  onChanged: (value) =>
                      setState(() => _locationPrivacy = value),
                ),
                SliderSettingWidget(
                  title: 'Radio de Distancia',
                  subtitle: 'Mostrar perfiles dentro de este rango',
                  value: _distanceRadius,
                  min: 5,
                  max: 100,
                  divisions: 19,
                  onChanged: (value) => setState(() => _distanceRadius = value),
                  valueFormatter: (value) => '${value.round()} km',
                ),
                RangeSliderWidget(
                  title: 'Rango de Edad',
                  subtitle: 'Edad preferida para conexiones',
                  values: _ageRange,
                  min: 18,
                  max: 70,
                  divisions: 52,
                  onChanged: (values) => setState(() => _ageRange = values),
                  valueFormatter: (value) => '${value.round()}',
                ),
                SwitchSettingWidget(
                  title: 'Mostrar Estado En Línea',
                  subtitle: 'Otros pueden ver cuando estás activo',
                  value: _showOnlineStatus,
                  onChanged: (value) =>
                      setState(() => _showOnlineStatus = value),
                ),
                SwitchSettingWidget(
                  title: 'Mostrar Edad',
                  subtitle: 'Incluir edad en tu perfil público',
                  value: _showAge,
                  onChanged: (value) => setState(() => _showAge = value),
                ),
                SwitchSettingWidget(
                  title: 'Mostrar Distancia',
                  subtitle: 'Mostrar distancia aproximada a otros usuarios',
                  value: _showDistance,
                  onChanged: (value) => setState(() => _showDistance = value),
                  showBorder: false,
                ),
              ],
            ),

            // Notification Settings Section
            SettingsSectionWidget(
              title: 'Notificaciones',
              children: [
                SwitchSettingWidget(
                  title: 'Nuevas Conexiones',
                  subtitle: 'Notificar cuando tengas una nueva conexión',
                  iconName: 'notifications',
                  value: _matchNotifications,
                  onChanged: (value) =>
                      setState(() => _matchNotifications = value),
                ),
                SwitchSettingWidget(
                  title: 'Mensajes',
                  subtitle: 'Notificar nuevos mensajes de conexiones',
                  value: _messageNotifications,
                  onChanged: (value) =>
                      setState(() => _messageNotifications = value),
                ),
                SwitchSettingWidget(
                  title: 'Actualizaciones de Comunidad',
                  subtitle: 'Eventos y noticias de la comunidad espiritual',
                  value: _communityNotifications,
                  onChanged: (value) =>
                      setState(() => _communityNotifications = value),
                  showBorder: false,
                ),
              ],
            ),

            // Privacy & Safety Section
            SettingsSectionWidget(
              title: 'Privacidad y Seguridad',
              children: [
                SettingsItemWidget(
                  title: 'Usuarios Bloqueados',
                  subtitle: 'Gestionar usuarios bloqueados',
                  iconName: 'block',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to blocked users management
                  },
                ),
                SettingsItemWidget(
                  title: 'Reportes y Seguridad',
                  subtitle:
                      'Historial de reportes y configuración de seguridad',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to reports and safety
                  },
                ),
                SwitchSettingWidget(
                  title: 'Visibilidad del Perfil',
                  subtitle: 'Permitir que otros vean tu perfil',
                  value: _profileVisibility,
                  onChanged: (value) =>
                      setState(() => _profileVisibility = value),
                ),
                SettingsItemWidget(
                  title: 'Descargar Mis Datos',
                  subtitle: 'Solicitar copia de tus datos personales',
                  trailing: CustomIconWidget(
                    iconName: 'download',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  onTap: () {
                    _showDataDownloadDialog();
                  },
                  showBorder: false,
                ),
              ],
            ),

            // Account Section
            SettingsSectionWidget(
              title: 'Cuenta',
              children: [
                SettingsItemWidget(
                  title: 'Cambiar Email',
                  subtitle: 'luna.esperanza@email.com',
                  iconName: 'email',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to change email
                  },
                ),
                SettingsItemWidget(
                  title: 'Cambiar Contraseña',
                  subtitle: 'Actualizar tu contraseña de acceso',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to change password
                  },
                ),
                SettingsItemWidget(
                  title: 'Cuentas Conectadas',
                  subtitle: 'Google, Apple ID y otras conexiones',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to connected accounts
                  },
                ),
                SettingsItemWidget(
                  title: 'Suscripción Premium',
                  subtitle: 'Plan Básico - Actualizar para más funciones',
                  iconName: 'star',
                  trailing: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Actualizar',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigate to subscription
                  },
                  showBorder: false,
                ),
              ],
            ),

            // Language & Region Section
            SettingsSectionWidget(
              title: 'Idioma y Región',
              children: [
                ExpandableSectionWidget(
                  title: 'Idioma',
                  subtitle: _selectedLanguage,
                  iconName: 'language',
                  showBorder: false,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      children: _languages.map((language) {
                        return RadioListTile<String>(
                          title: Text(
                            language,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          value: language,
                          groupValue: _selectedLanguage,
                          onChanged: (value) {
                            setState(() => _selectedLanguage = value!);
                          },
                          activeColor: AppTheme.lightTheme.colorScheme.primary,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),

            // Help & Support Section
            SettingsSectionWidget(
              title: 'Ayuda y Soporte',
              children: [
                SettingsItemWidget(
                  title: 'Preguntas Frecuentes',
                  subtitle: 'Encuentra respuestas a preguntas comunes',
                  iconName: 'help',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to FAQ
                  },
                ),
                SettingsItemWidget(
                  title: 'Contactar Soporte',
                  subtitle: 'Obtén ayuda de nuestro equipo',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to contact support
                  },
                ),
                SettingsItemWidget(
                  title: 'Guías de Comunidad',
                  subtitle: 'Normas y valores de nuestra comunidad espiritual',
                  trailing: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  onTap: () {
                    // Navigate to community guidelines
                  },
                  showBorder: false,
                ),
              ],
            ),

            // Danger Zone Section
            SettingsSectionWidget(
              title: 'Zona de Peligro',
              children: [
                SettingsItemWidget(
                  title: 'Cerrar Sesión',
                  subtitle: 'Salir de tu cuenta en este dispositivo',
                  iconName: 'logout',
                  titleColor: AppTheme.lightTheme.colorScheme.error,
                  onTap: () {
                    _showLogoutDialog();
                  },
                ),
                SettingsItemWidget(
                  title: 'Eliminar Cuenta',
                  subtitle: 'Eliminar permanentemente tu cuenta y datos',
                  titleColor: AppTheme.lightTheme.colorScheme.error,
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                  showBorder: false,
                ),
              ],
            ),

            // Version Info
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  Text(
                    'SoulConnect v1.2.0',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to terms
                        },
                        child: Text(
                          'Términos',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        ' • ',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to privacy policy
                        },
                        child: Text(
                          'Privacidad',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Cerrar Sesión',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '¿Estás seguro de que quieres cerrar sesión? Podrás volver a iniciar sesión en cualquier momento.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar Cuenta',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta acción eliminará permanentemente tu cuenta y todos tus datos, incluyendo:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                '• Tu perfil y fotos\n• Todas tus conexiones\n• Historial de mensajes\n• Preferencias espirituales\n• Datos de la comunidad',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Esta acción no se puede deshacer y afectará a las conexiones que hayas formado en nuestra comunidad espiritual.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              ),
              child: const Text('Eliminar Cuenta'),
            ),
          ],
        );
      },
    );
  }

  void _showDataDownloadDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Descargar Mis Datos',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Recibirás un email con un archivo que contiene todos tus datos personales en un plazo de 24-48 horas. Esto incluye tu perfil, mensajes, conexiones y preferencias.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Solicitud de datos enviada. Recibirás un email pronto.'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                );
              },
              child: const Text('Solicitar Datos'),
            ),
          ],
        );
      },
    );
  }
}
