import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SelfAwarenessWidget extends StatefulWidget {
  final Function(Map<String, String>) onAnswersChanged;
  final Map<String, String> initialAnswers;

  const SelfAwarenessWidget({
    Key? key,
    required this.onAnswersChanged,
    this.initialAnswers = const {},
  }) : super(key: key);

  @override
  State<SelfAwarenessWidget> createState() => _SelfAwarenessWidgetState();
}

class _SelfAwarenessWidgetState extends State<SelfAwarenessWidget> {
  Map<String, String> _answers = {};
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'id': 'spiritual_journey',
      'question': '¿En qué etapa de tu camino espiritual te encuentras?',
      'options': [
        'Comenzando a explorar',
        'En desarrollo activo',
        'Práctica establecida',
        'Guía para otros',
      ],
      'icon': 'explore',
    },
    {
      'id': 'connection_style',
      'question': '¿Cómo prefieres conectar con otros espiritualmente?',
      'options': [
        'Conversaciones profundas',
        'Prácticas compartidas',
        'Experiencias en la naturaleza',
        'Rituales y ceremonias',
      ],
      'icon': 'people',
    },
    {
      'id': 'growth_focus',
      'question': '¿En qué área buscas más crecimiento personal?',
      'options': [
        'Autoconocimiento',
        'Relaciones conscientes',
        'Propósito de vida',
        'Sanación emocional',
      ],
      'icon': 'trending_up',
    },
    {
      'id': 'relationship_intention',
      'question': '¿Qué buscas principalmente en las conexiones?',
      'options': [
        'Amistad espiritual',
        'Compañero de vida',
        'Colaboración creativa',
        'Comunidad consciente',
      ],
      'icon': 'favorite',
    },
    {
      'id': 'communication_style',
      'question': '¿Cómo describes tu estilo de comunicación?',
      'options': [
        'Directo y honesto',
        'Empático y receptivo',
        'Reflexivo y profundo',
        'Intuitivo y energético',
      ],
      'icon': 'chat',
    },
  ];

  @override
  void initState() {
    super.initState();
    _answers = Map.from(widget.initialAnswers);
  }

  void _selectAnswer(String questionId, String answer) {
    setState(() {
      _answers[questionId] = answer;
    });
    widget.onAnswersChanged(_answers);
  }

  double get _completionPercentage {
    return _answers.length / _questions.length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cuestionario de autoconocimiento',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Opcional - Ayuda a crear conexiones más auténticas',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Progress indicator
        Container(
          width: double.infinity,
          height: 0.8.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _completionPercentage,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        SizedBox(height: 1.h),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_answers.length} de ${_questions.length} completadas',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (_answers.isNotEmpty)
              Text(
                '${(_completionPercentage * 100).round()}%',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),

        if (_isExpanded) ...[
          SizedBox(height: 3.h),

          // Questions
          Column(
            children: _questions.map((questionData) {
              final questionId = questionData['id'] as String;
              final question = questionData['question'] as String;
              final options = questionData['options'] as List<String>;
              final icon = questionData['icon'] as String;
              final selectedAnswer = _answers[questionId];

              return Container(
                margin: EdgeInsets.only(bottom: 3.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: selectedAnswer != null
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.05)
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selectedAnswer != null
                        ? AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.3)
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: selectedAnswer != null
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: icon,
                            color: selectedAnswer != null
                                ? AppTheme.lightTheme.colorScheme.onTertiary
                                : AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            question,
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: selectedAnswer != null
                                  ? AppTheme.lightTheme.colorScheme.tertiary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Column(
                      children: options.map((option) {
                        final isSelected = selectedAnswer == option;

                        return Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          child: GestureDetector(
                            onTap: () => _selectAnswer(questionId, option),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(3.w),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.tertiary
                                        .withValues(alpha: 0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.colorScheme.tertiary
                                      : AppTheme.lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4.w,
                                    height: 4.w,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.tertiary
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: !isSelected
                                          ? Border.all(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.outline,
                                            )
                                          : null,
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: CustomIconWidget(
                                              iconName: 'check',
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onTertiary,
                                              size: 12,
                                            ),
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      option,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: isSelected
                                            ? AppTheme
                                                .lightTheme.colorScheme.tertiary
                                            : AppTheme.lightTheme.colorScheme
                                                .onSurface,
                                        fontWeight: isSelected
                                            ? FontWeight.w500
                                            : FontWeight.w400,
                                      ),
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
                ),
              );
            }).toList(),
          ),

          if (_answers.length == _questions.length) ...[
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
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'celebration',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Cuestionario completado!',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Esto ayudará a crear conexiones más auténticas y significativas.',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
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
          ],
        ],
      ],
    );
  }
}
