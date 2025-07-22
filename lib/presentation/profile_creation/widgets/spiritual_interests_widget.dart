import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpiritualInterestsWidget extends StatefulWidget {
  final Function(List<String>) onInterestsChanged;
  final Function(List<String>) onToolsChanged;
  final Function(String) onEnergyTypeChanged;
  final List<String> initialInterests;
  final List<String> initialTools;
  final String initialEnergyType;

  const SpiritualInterestsWidget({
    Key? key,
    required this.onInterestsChanged,
    required this.onToolsChanged,
    required this.onEnergyTypeChanged,
    this.initialInterests = const [],
    this.initialTools = const [],
    this.initialEnergyType = '',
  }) : super(key: key);

  @override
  State<SpiritualInterestsWidget> createState() =>
      _SpiritualInterestsWidgetState();
}

class _SpiritualInterestsWidgetState extends State<SpiritualInterestsWidget> {
  List<String> _selectedInterests = [];
  List<String> _selectedTools = [];
  String _selectedEnergyType = '';

  final Map<String, String> _spiritualInterests = {
    'Meditación': 'self_improvement',
    'Astrología': 'star',
    'Human Design': 'psychology',
    'Plantas sagradas': 'local_florist',
    'Tantra': 'favorite',
    'Energía femenina': 'female',
    'Energía masculina': 'male',
    'Yoga': 'fitness_center',
    'Mindfulness': 'spa',
    'Chakras': 'brightness_7',
    'Cristales': 'diamond',
    'Numerología': 'calculate',
    'Tarot': 'auto_awesome',
    'Reiki': 'healing',
    'Ayurveda': 'eco',
    'Budismo': 'temple_buddhist',
  };

  final Map<String, String> _spiritualTools = {
    'Tarot': 'auto_awesome',
    'Respiración': 'air',
    'Yoga': 'fitness_center',
    'Meditación': 'self_improvement',
    'Cristales': 'diamond',
    'Incienso': 'local_florist',
    'Mantras': 'record_voice_over',
    'Journaling': 'edit_note',
    'Danza': 'music_note',
    'Canto': 'mic',
    'Aromaterapia': 'spa',
    'Rituales': 'auto_fix_high',
  };

  final Map<String, String> _energyTypes = {
    'Femenina divina': 'Conectada con la intuición, receptividad y fluidez',
    'Masculina divina': 'Enfocada en la acción, estructura y propósito',
    'Energía mixta': 'Equilibrio entre ambas energías según el momento',
  };

  @override
  void initState() {
    super.initState();
    _selectedInterests = List.from(widget.initialInterests);
    _selectedTools = List.from(widget.initialTools);
    _selectedEnergyType = widget.initialEnergyType;
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 8) {
          _selectedInterests.add(interest);
        }
      }
    });
    widget.onInterestsChanged(_selectedInterests);
  }

  void _toggleTool(String tool) {
    setState(() {
      if (_selectedTools.contains(tool)) {
        _selectedTools.remove(tool);
      } else {
        if (_selectedTools.length < 6) {
          _selectedTools.add(tool);
        }
      }
    });
    widget.onToolsChanged(_selectedTools);
  }

  void _selectEnergyType(String energyType) {
    setState(() {
      _selectedEnergyType = energyType;
    });
    widget.onEnergyTypeChanged(energyType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Spiritual Interests Section
        Text(
          'Intereses espirituales',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Selecciona hasta 8 prácticas que resuenen contigo',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _spiritualInterests.entries.map((entry) {
            final isSelected = _selectedInterests.contains(entry.key);
            final isDisabled = !isSelected && _selectedInterests.length >= 8;

            return GestureDetector(
              onTap: isDisabled ? null : () => _toggleInterest(entry.key),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : isDisabled
                          ? AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : isDisabled
                            ? AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: entry.value,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : isDisabled
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      entry.key,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : isDisabled
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)
                                : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        if (_selectedInterests.length >= 8) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Has alcanzado el máximo de intereses. Puedes deseleccionar algunos para agregar otros.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        SizedBox(height: 4.h),

        // Spiritual Tools Section
        Text(
          'Herramientas espirituales favoritas',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Selecciona hasta 6 herramientas que uses regularmente',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _spiritualTools.entries.map((entry) {
            final isSelected = _selectedTools.contains(entry.key);
            final isDisabled = !isSelected && _selectedTools.length >= 6;

            return GestureDetector(
              onTap: isDisabled ? null : () => _toggleTool(entry.key),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.secondary
                      : isDisabled
                          ? AppTheme.lightTheme.colorScheme.surface
                              .withValues(alpha: 0.5)
                          : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.secondary
                        : isDisabled
                            ? AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: entry.value,
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onSecondary
                          : isDisabled
                              ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : AppTheme.lightTheme.colorScheme.secondary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      entry.key,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onSecondary
                            : isDisabled
                                ? AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)
                                : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: 4.h),

        // Energy Type Section
        Text(
          'Tipo de energía',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 1.h),
        Text(
          'Selecciona el tipo de energía que mejor te represente',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),

        Column(
          children: _energyTypes.entries.map((entry) {
            final isSelected = _selectedEnergyType == entry.key;

            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: GestureDetector(
                onTap: () => _selectEnergyType(entry.key),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.surface,
                          shape: BoxShape.circle,
                          border: !isSelected
                              ? Border.all(
                                  color:
                                      AppTheme.lightTheme.colorScheme.outline,
                                )
                              : null,
                        ),
                        child: CustomIconWidget(
                          iconName:
                              isSelected ? 'check' : 'radio_button_unchecked',
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onTertiary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: AppTheme.lightTheme.textTheme.bodyLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              entry.value,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
