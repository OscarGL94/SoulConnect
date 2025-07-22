import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class EnergyTypeWidget extends StatelessWidget {
  final String energyType;
  final List<String> connectionPurposes;

  const EnergyTypeWidget({
    Key? key,
    required this.energyType,
    required this.connectionPurposes,
  }) : super(key: key);

  String _getEnergyIcon(String type) {
    switch (type.toLowerCase()) {
      case 'divino femenino':
        return 'favorite';
      case 'divino masculino':
        return 'star';
      case 'mixto':
        return 'balance';
      default:
        return 'circle';
    }
  }

  Color _getEnergyColor(String type) {
    switch (type.toLowerCase()) {
      case 'divino femenino':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'divino masculino':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'mixto':
        return AppTheme.lightTheme.colorScheme.secondary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurface;
    }
  }

  String _getPurposeIcon(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'amistad':
        return 'people';
      case 'romance':
        return 'favorite';
      case 'colaboración espiritual':
        return 'handshake';
      default:
        return 'circle';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Energía y Propósito',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 0.5,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _getEnergyColor(energyType).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: _getEnergyIcon(energyType),
                      color: _getEnergyColor(energyType),
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de Energía',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          energyType,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _getEnergyColor(energyType),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buscando',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: connectionPurposes.map((purpose) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: _getPurposeIcon(purpose),
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 4.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              purpose,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
