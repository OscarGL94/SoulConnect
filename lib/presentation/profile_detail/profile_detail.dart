import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/energy_type_widget.dart';
import './widgets/photo_gallery_widget.dart';
import './widgets/questionnaire_responses_widget.dart';
import './widgets/spiritual_interests_widget.dart';
import './widgets/spiritual_tools_widget.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  // Mock profile data
  final Map<String, dynamic> profileData = {
    "id": 1,
    "spiritualName": "Luna Serena",
    "age": 32,
    "location": "Barcelona, España",
    "photos": [
      "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "https://images.pexels.com/photos/1181686/pexels-photo-1181686.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    ],
    "bio":
        "Exploradora de la consciencia en constante evolución. Practico meditación vipassana y trabajo con plantas sagradas para sanar y expandir mi ser. Busco conexiones auténticas con almas afines que caminen el sendero del despertar espiritual.",
    "interests": [
      "Meditación",
      "Astrología",
      "Plantas Sagradas",
      "Tantra",
      "Energía Femenina",
      "Yoga",
      "Tarot",
      "Breathwork"
    ],
    "sharedInterests": ["Meditación", "Astrología", "Yoga", "Tarot"],
    "spiritualTools": [
      {"name": "Tarot", "icon": "auto_awesome"},
      {"name": "Breathwork", "icon": "air"},
      {"name": "Yoga", "icon": "self_improvement"},
      {"name": "Cristales", "icon": "diamond"},
    ],
    "energyType": "Divino Femenino",
    "connectionPurposes": ["Amistad", "Romance", "Colaboración Espiritual"],
    "questionnaireResponses": [
      {
        "question": "¿Cuál es tu práctica espiritual más transformadora?",
        "answer":
            "La meditación vipassana ha sido mi ancla durante los últimos 8 años. Me ha enseñado a observar mis patrones mentales sin juicio y a encontrar paz en el momento presente."
      },
      {
        "question": "¿Cómo integras la espiritualidad en tu vida diaria?",
        "answer":
            "Comienzo cada día con 20 minutos de meditación y gratitud. Durante el día, practico mindfulness en actividades simples como caminar o comer. Por las noches, reflexiono sobre las lecciones aprendidas."
      },
      {
        "question": "¿Qué buscas en una conexión espiritual?",
        "answer":
            "Busco autenticidad y vulnerabilidad. Alguien que esté dispuesto a explorar las profundidades del alma, que valore el crecimiento mutuo y que pueda sostener espacios sagrados de intimidad emocional y espiritual."
      }
    ],
    "screenContext": "discovery" // Can be: discovery, matches, own_profile
  };

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool shouldShowTitle = _scrollController.offset > 40.h;
    if (shouldShowTitle != _showAppBarTitle) {
      setState(() {
        _showAppBarTitle = shouldShowTitle;
      });
    }
  }

  void _showShareDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.w),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Compartir Perfil',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'link',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Copiar Enlace'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Enlace copiado al portapapeles')),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Compartir'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reportar Usuario'),
        content: Text('¿Estás seguro de que quieres reportar este perfil?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Usuario reportado')),
              );
            },
            child: Text('Reportar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = (profileData['photos'] as List).cast<String>();
    final interests = (profileData['interests'] as List).cast<String>();
    final sharedInterests =
        (profileData['sharedInterests'] as List).cast<String>();
    final spiritualTools =
        (profileData['spiritualTools'] as List).cast<Map<String, dynamic>>();
    final connectionPurposes =
        (profileData['connectionPurposes'] as List).cast<String>();
    final questionnaireResponses =
        (profileData['questionnaireResponses'] as List)
            .cast<Map<String, dynamic>>();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 50.h,
                floating: false,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
                foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
                elevation: 0,
                title: _showAppBarTitle
                    ? Text(
                        profileData['spiritualName'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
                actions: [
                  IconButton(
                    onPressed: _showShareDialog,
                    icon: CustomIconWidget(
                      iconName: 'share',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 6.w,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'report':
                          _showReportDialog();
                          break;
                        case 'block':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Usuario bloqueado')),
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'report',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Text('Reportar'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'block',
                              color: AppTheme.lightTheme.colorScheme.error,
                              size: 5.w,
                            ),
                            SizedBox(width: 3.w),
                            Text('Bloquear'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: PhotoGalleryWidget(
                    photos: photos,
                    initialIndex: 0,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profileData['spiritualName'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'cake',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '${profileData['age']} años',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'location_on',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: Text(
                                        profileData['location'] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Bio Section
                      Text(
                        'Sobre Mí',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        profileData['bio'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // Spiritual Interests
                      SpiritualInterestsWidget(
                        interests: interests,
                        sharedInterests: sharedInterests,
                      ),
                      SizedBox(height: 4.h),

                      // Spiritual Tools
                      SpiritualToolsWidget(
                        tools: spiritualTools,
                      ),
                      SizedBox(height: 4.h),

                      // Energy Type and Connection Purposes
                      EnergyTypeWidget(
                        energyType: profileData['energyType'] as String,
                        connectionPurposes: connectionPurposes,
                      ),
                      SizedBox(height: 4.h),

                      // Questionnaire Responses
                      QuestionnaireResponsesWidget(
                        responses: questionnaireResponses,
                      ),
                      SizedBox(height: 12.h), // Space for action buttons
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Action Buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ActionButtonsWidget(
              screenContext: profileData['screenContext'] as String,
              onResonatePressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        '¡Has resonado con ${profileData['spiritualName']}!'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                );
              },
              onPassPressed: () {
                Navigator.pop(context);
              },
              onMessagePressed: () {
                Navigator.pushNamed(context, '/chat-conversation');
              },
              onEditPressed: () {
                Navigator.pushNamed(context, '/profile-settings');
              },
            ),
          ),
        ],
      ),
    );
  }
}
