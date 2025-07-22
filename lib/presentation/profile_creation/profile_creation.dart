import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/basic_info_widget.dart';
import './widgets/photo_gallery_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/self_awareness_widget.dart';
import './widgets/spiritual_bio_widget.dart';
import './widgets/spiritual_interests_widget.dart';

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({Key? key}) : super(key: key);

  @override
  State<ProfileCreation> createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  late TabController _tabController;

  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isDraftSaved = false;
  bool _showPreview = false;

  // Profile data
  List<String> _photos = [];
  String _name = '';
  int _age = 25;
  String _location = '';
  String _bio = '';
  List<String> _interests = [];
  List<String> _tools = [];
  String _energyType = '';
  Map<String, String> _selfAwarenessAnswers = {};

  final List<Map<String, dynamic>> _mockProfiles = [
    {
      "id": 1,
      "name": "Luna Serena",
      "age": 28,
      "location": "Barcelona",
      "bio":
          "Explorando la conexión entre el yoga y la astrología. Busco almas afines para compartir prácticas de meditación y crecimiento personal. Mi camino espiritual se centra en la sanación a través del movimiento consciente.",
      "photos": [
        "https://images.unsplash.com/photo-1544005313-94ddf0286df2?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      ],
      "interests": ["Yoga", "Astrología", "Meditación"],
      "tools": ["Yoga", "Cristales", "Meditación"],
      "energyType": "Femenina divina",
    },
    {
      "id": 2,
      "name": "Alejandro Luz",
      "age": 32,
      "location": "Madrid",
      "bio":
          "Practicante de mindfulness y facilitador de círculos de hombres conscientes. Interesado en explorar la masculinidad sagrada y crear conexiones auténticas basadas en la vulnerabilidad y el crecimiento mutuo.",
      "photos": [
        "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
        "https://images.unsplash.com/photo-1507591064344-4c6ce005b128?fm=jpg&q=60&w=400&ixlib=rb-4.0.3",
      ],
      "interests": ["Mindfulness", "Energía masculina", "Meditación"],
      "tools": ["Meditación", "Respiración", "Journaling"],
      "energyType": "Masculina divina",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _totalSteps, vsync: this);
    _loadDraftData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _loadDraftData() {
    // Simulate loading draft data
    setState(() {
      _isDraftSaved = false;
    });
  }

  void _saveDraft() {
    // Simulate saving draft
    setState(() {
      _isDraftSaved = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'save',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text('Borrador guardado automáticamente'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  double get _progress {
    double baseProgress = (_currentStep + 1) / _totalSteps;

    // Add bonus progress for completed sections
    double bonusProgress = 0.0;
    if (_photos.isNotEmpty) bonusProgress += 0.05;
    if (_name.isNotEmpty && _location.isNotEmpty) bonusProgress += 0.05;
    if (_bio.length >= 50) bonusProgress += 0.05;
    if (_interests.isNotEmpty) bonusProgress += 0.05;
    if (_selfAwarenessAnswers.isNotEmpty) bonusProgress += 0.05;

    return (baseProgress + bonusProgress).clamp(0.0, 1.0);
  }

  bool get _canProceedToNext {
    switch (_currentStep) {
      case 0: // Photos
        return _photos.isNotEmpty;
      case 1: // Basic info
        return _name.trim().isNotEmpty && _location.isNotEmpty;
      case 2: // Bio
        return _bio.trim().length >= 50;
      case 3: // Interests
        return _interests.isNotEmpty;
      case 4: // Self-awareness (optional)
        return true;
      default:
        return false;
    }
  }

  bool get _isProfileComplete {
    return _photos.isNotEmpty &&
        _name.trim().isNotEmpty &&
        _location.isNotEmpty &&
        _bio.trim().length >= 50 &&
        _interests.isNotEmpty;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1 && _canProceedToNext) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _tabController.animateTo(_currentStep);
      _saveDraft();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _tabController.animateTo(_currentStep);
    }
  }

  void _showProfilePreview() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 85.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: 40.w,
                height: 0.5.h,
                margin: EdgeInsets.only(top: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vista previa del perfil',
                      style: AppTheme.lightTheme.textTheme.titleLarge,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: _buildPreviewCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photos section
            if (_photos.isNotEmpty)
              Container(
                height: 50.h,
                child: PageView.builder(
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: CustomImageWidget(
                        imageUrl: _photos[index],
                        width: double.infinity,
                        height: 50.h,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),

            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and age
                  Row(
                    children: [
                      Text(
                        _name.isNotEmpty ? _name : 'Tu nombre',
                        style: AppTheme.lightTheme.textTheme.headlineSmall,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '$_age',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Location
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _location.isNotEmpty ? _location : 'Tu ubicación',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Bio
                  Text(
                    _bio.isNotEmpty
                        ? _bio
                        : 'Tu bio espiritual aparecerá aquí...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),

                  SizedBox(height: 3.h),

                  // Interests
                  if (_interests.isNotEmpty) ...[
                    Text(
                      'Intereses espirituales',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _interests
                          .map((interest) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.primary
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  interest,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 2.h),
                  ],

                  // Tools
                  if (_tools.isNotEmpty) ...[
                    Text(
                      'Herramientas favoritas',
                      style: AppTheme.lightTheme.textTheme.titleSmall,
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: _tools
                          .map((tool) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme
                                      .lightTheme.colorScheme.secondary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  tool,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeProfile() {
    if (_isProfileComplete) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'celebration',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                '¡Perfil creado!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu perfil espiritual está listo para conectar con almas afines.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'auto_awesome',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Comenzarás a ver perfiles que resuenen con tu energía espiritual.',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/matches-list');
              },
              child: Text('Comenzar a conectar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            ProgressIndicatorWidget(
              progress: _progress,
              currentStep: _currentStep + 1,
              totalSteps: _totalSteps,
            ),

            // Tab bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                onTap: (index) {
                  if (index <= _currentStep) {
                    setState(() {
                      _currentStep = index;
                    });
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'photo_camera',
                          color: _currentStep >= 0
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text('Fotos'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'person',
                          color: _currentStep >= 1
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text('Info'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'edit_note',
                          color: _currentStep >= 2
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text('Bio'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'interests',
                          color: _currentStep >= 3
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text('Intereses'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'psychology',
                          color: _currentStep >= 4
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text('Opcional'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentStep = index;
                    });
                    _tabController.animateTo(index);
                  },
                  children: [
                    // Step 1: Photos
                    SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: PhotoGalleryWidget(
                        initialPhotos: _photos,
                        onPhotosChanged: (photos) {
                          setState(() {
                            _photos = photos;
                          });
                          _saveDraft();
                        },
                      ),
                    ),

                    // Step 2: Basic Info
                    SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: BasicInfoWidget(
                        initialName: _name,
                        initialAge: _age,
                        initialLocation: _location,
                        onNameChanged: (name) {
                          setState(() {
                            _name = name;
                          });
                          _saveDraft();
                        },
                        onAgeChanged: (age) {
                          setState(() {
                            _age = age;
                          });
                          _saveDraft();
                        },
                        onLocationChanged: (location) {
                          setState(() {
                            _location = location;
                          });
                          _saveDraft();
                        },
                      ),
                    ),

                    // Step 3: Spiritual Bio
                    SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: SpiritualBioWidget(
                        initialBio: _bio,
                        onBioChanged: (bio) {
                          setState(() {
                            _bio = bio;
                          });
                          _saveDraft();
                        },
                      ),
                    ),

                    // Step 4: Spiritual Interests
                    SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: SpiritualInterestsWidget(
                        initialInterests: _interests,
                        initialTools: _tools,
                        initialEnergyType: _energyType,
                        onInterestsChanged: (interests) {
                          setState(() {
                            _interests = interests;
                          });
                          _saveDraft();
                        },
                        onToolsChanged: (tools) {
                          setState(() {
                            _tools = tools;
                          });
                          _saveDraft();
                        },
                        onEnergyTypeChanged: (energyType) {
                          setState(() {
                            _energyType = energyType;
                          });
                          _saveDraft();
                        },
                      ),
                    ),

                    // Step 5: Self-awareness (Optional)
                    SingleChildScrollView(
                      padding: EdgeInsets.all(4.w),
                      child: SelfAwarenessWidget(
                        initialAnswers: _selfAwarenessAnswers,
                        onAnswersChanged: (answers) {
                          setState(() {
                            _selfAwarenessAnswers = answers;
                          });
                          _saveDraft();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _previousStep,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'arrow_back',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text('Anterior'),
                          ],
                        ),
                      ),
                    ),
                  if (_currentStep > 0) SizedBox(width: 2.w),
                  Expanded(
                    flex: 2,
                    child: _currentStep == _totalSteps - 1
                        ? ElevatedButton(
                            onPressed:
                                _isProfileComplete ? _completeProfile : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomIconWidget(
                                  iconName: 'check_circle',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text('Completar perfil'),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _canProceedToNext ? _nextStep : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Continuar'),
                                SizedBox(width: 1.w),
                                CustomIconWidget(
                                  iconName: 'arrow_forward',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating preview button
      floatingActionButton: _isProfileComplete
          ? FloatingActionButton.extended(
              onPressed: _showProfilePreview,
              icon: CustomIconWidget(
                iconName: 'preview',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 20,
              ),
              label: Text(
                'Vista previa',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            )
          : null,
    );
  }
}
