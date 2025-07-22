import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SpiritualBioWidget extends StatefulWidget {
  final Function(String) onBioChanged;
  final String initialBio;

  const SpiritualBioWidget({
    Key? key,
    required this.onBioChanged,
    this.initialBio = '',
  }) : super(key: key);

  @override
  State<SpiritualBioWidget> createState() => _SpiritualBioWidgetState();
}

class _SpiritualBioWidgetState extends State<SpiritualBioWidget> {
  late TextEditingController _bioController;
  int _characterCount = 0;
  final int _maxCharacters = 300;
  bool _showPrompts = false;

  final List<String> _spiritualPrompts = [
    '¿Qué prácticas espirituales forman parte de tu rutina diaria?',
    '¿Cómo describirías tu camino de crecimiento personal?',
    '¿Qué te inspira en tu búsqueda de conexiones auténticas?',
    '¿Cuál es tu filosofía de vida en pocas palabras?',
    '¿Qué tipo de energía buscas compartir con otros?',
    '¿Cómo integras la espiritualidad en tu vida cotidiana?',
    '¿Qué valores son más importantes para ti en las relaciones?',
    '¿Cuál ha sido tu experiencia más transformadora?',
  ];

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(text: widget.initialBio);
    _characterCount = widget.initialBio.length;
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _onBioChanged(String value) {
    setState(() {
      _characterCount = value.length;
    });
    widget.onBioChanged(value);
  }

  void _insertPrompt(String prompt) {
    final currentText = _bioController.text;
    final newText = currentText.isEmpty ? prompt : '$currentText\n\n$prompt';

    if (newText.length <= _maxCharacters) {
      _bioController.text = newText;
      _onBioChanged(newText);
    }

    setState(() {
      _showPrompts = false;
    });
  }

  Color _getCharacterCountColor() {
    final percentage = _characterCount / _maxCharacters;
    if (percentage >= 1.0) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (percentage >= 0.8) {
      return Colors.orange;
    } else {
      return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Bio espiritual',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showPrompts = !_showPrompts;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Ideas',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 1.h),

        Text(
          'Comparte tu esencia espiritual y lo que buscas en conexiones auténticas',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),

        SizedBox(height: 2.h),

        // Spiritual prompts section
        if (_showPrompts) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Preguntas inspiradoras',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                ...(_spiritualPrompts.take(4).map((prompt) => Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: GestureDetector(
                        onTap: () => _insertPrompt(prompt),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            prompt,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ))),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],

        // Bio text field
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _characterCount > _maxCharacters
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
            ),
          ),
          child: TextFormField(
            controller: _bioController,
            maxLines: 8,
            maxLength: _maxCharacters,
            decoration: InputDecoration(
              hintText:
                  'Cuéntanos sobre tu camino espiritual, tus prácticas favoritas, lo que buscas en conexiones auténticas...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(4.w),
              counterText: '',
            ),
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            onChanged: _onBioChanged,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor comparte algo sobre tu camino espiritual';
              }
              if (value.trim().length < 50) {
                return 'Tu bio debe tener al menos 50 caracteres para crear conexiones auténticas';
              }
              return null;
            },
          ),
        ),

        SizedBox(height: 1.h),

        // Character counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _characterCount < 50
                  ? 'Mínimo 50 caracteres para conexiones auténticas'
                  : 'Perfecto para compartir tu esencia',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _characterCount < 50
                    ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    : AppTheme.lightTheme.colorScheme.tertiary,
              ),
            ),
            Text(
              '$_characterCount/$_maxCharacters',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: _getCharacterCountColor(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        if (_characterCount > _maxCharacters) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color:
                  AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Has excedido el límite de caracteres. Por favor, reduce el texto.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
