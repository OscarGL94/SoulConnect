import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final String screenContext;
  final VoidCallback? onResonatePressed;
  final VoidCallback? onPassPressed;
  final VoidCallback? onMessagePressed;
  final VoidCallback? onEditPressed;

  const ActionButtonsWidget({
    Key? key,
    required this.screenContext,
    this.onResonatePressed,
    this.onPassPressed,
    this.onMessagePressed,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _buildActionButtons(context),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    switch (screenContext) {
      case 'discovery':
        return Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPassPressed,
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 5.w,
                ),
                label: Text(
                  'Ahora No',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.error,
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onResonatePressed,
                icon: CustomIconWidget(
                  iconName: 'favorite',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: Text(
                  'Resuena',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                ),
              ),
            ),
          ],
        );
      case 'matches':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onMessagePressed,
            icon: CustomIconWidget(
              iconName: 'message',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'Enviar Mensaje',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 3.h),
            ),
          ),
        );
      case 'own_profile':
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onEditPressed,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'Editar Perfil',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 3.h),
            ),
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}
