import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/chat_header_widget.dart';
import './widgets/conversation_starter_widget.dart';
import './widgets/date_separator_widget.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatConversation extends StatefulWidget {
  const ChatConversation({Key? key}) : super(key: key);

  @override
  State<ChatConversation> createState() => _ChatConversationState();
}

class _ChatConversationState extends State<ChatConversation> {
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showConversationStarters = true;

  // Mock data for spiritual partner
  final Map<String, dynamic> _partner = {
    "id": "partner_001",
    "name": "Luna Esperanza",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
    "isOnline": true,
    "lastSeen": DateTime.now().subtract(Duration(minutes: 5)),
    "spiritualInterests": ["meditación", "astrología", "tarot"],
    "energyType": "femenino divino",
  };

  // Mock conversation data
  final List<Map<String, dynamic>> _messages = [
    {
      "id": "msg_001",
      "senderId": "partner_001",
      "senderAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "content":
          "¡Hola! Me encanta tu energía en tu perfil. ¿Cómo ha sido tu práctica de meditación últimamente? ✨",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "status": "read",
      "type": "text",
    },
    {
      "id": "msg_002",
      "senderId": "current_user",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "content":
          "¡Hola Luna! Gracias por conectar conmigo. Mi práctica ha sido muy transformadora últimamente, especialmente con la luna llena reciente 🌙",
      "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
      "status": "read",
      "type": "text",
    },
    {
      "id": "msg_003",
      "senderId": "partner_001",
      "senderAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "content":
          "¡Qué hermoso! Yo también sentí esa energía lunar muy fuerte. ¿Trabajas con algún tipo específico de meditación o sigues tu intuición?",
      "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 30)),
      "status": "read",
      "type": "text",
    },
    {
      "id": "msg_004",
      "senderId": "current_user",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "content":
          "Principalmente sigo mi intuición, pero últimamente he estado explorando la meditación con cristales. ¿Tú qué prácticas espirituales sigues? 💎",
      "timestamp": DateTime.now().subtract(Duration(hours: 1, minutes: 15)),
      "status": "delivered",
      "type": "text",
    },
    {
      "id": "msg_005",
      "senderId": "partner_001",
      "senderAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "content":
          "¡Me fascina! Yo trabajo mucho con el tarot y la astrología. También hago rituales de luna nueva y llena. Siento que nuestras energías están muy alineadas 🔮",
      "timestamp": DateTime.now().subtract(Duration(minutes: 45)),
      "status": "read",
      "type": "text",
    },
    {
      "id": "msg_006",
      "senderId": "current_user",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "content":
          "¡Totalmente! Me encantaría conocer más sobre tu trabajo con el tarot. ¿Llevas mucho tiempo practicando?",
      "timestamp": DateTime.now().subtract(Duration(minutes: 30)),
      "status": "sent",
      "type": "text",
    },
  ];

  // AI-generated conversation starters
  final List<String> _conversationStarters = [
    "¿Qué práctica espiritual te ha transformado más?",
    "¿Cómo conectas con tu energía interior?",
    "¿Qué cristales resuenan más contigo?",
    "¿Cuál es tu ritual de luna favorito?",
    "¿Cómo manifiestas tus intenciones?",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate typing indicator
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });

        Future.delayed(Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _isTyping = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage(String content) {
    final newMessage = {
      "id": "msg_${DateTime.now().millisecondsSinceEpoch}",
      "senderId": "current_user",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "content": content,
      "timestamp": DateTime.now(),
      "status": "sent",
      "type": "text",
    };

    setState(() {
      _messages.add(newMessage);
      _showConversationStarters = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate message status updates
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final index =
              _messages.indexWhere((msg) => msg["id"] == newMessage["id"]);
          if (index != -1) {
            _messages[index]["status"] = "delivered";
          }
        });
      }
    });

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          final index =
              _messages.indexWhere((msg) => msg["id"] == newMessage["id"]);
          if (index != -1) {
            _messages[index]["status"] = "read";
          }
        });
      }
    });
  }

  void _onSuggestionTap(String suggestion) {
    _sendMessage(suggestion);
  }

  void _onMessageLongPress(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 4.h),
            _buildMessageOption(
              icon: "content_copy",
              label: "Copiar mensaje",
              onTap: () {
                Navigator.pop(context);
                // Implement copy functionality
              },
            ),
            if (message["senderId"] == "current_user") ...[
              SizedBox(height: 2.h),
              _buildMessageOption(
                icon: "delete",
                label: "Eliminar mensaje",
                onTap: () {
                  Navigator.pop(context);
                  _deleteMessage(message["id"]);
                },
              ),
            ] else ...[
              SizedBox(height: 2.h),
              _buildMessageOption(
                icon: "report",
                label: "Reportar contenido",
                onTap: () {
                  Navigator.pop(context);
                  _reportMessage(message["id"]);
                },
              ),
            ],
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMessage(String messageId) {
    setState(() {
      _messages.removeWhere((msg) => msg["id"] == messageId);
    });
  }

  void _reportMessage(String messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Reportar contenido",
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          "¿Estás seguro de que quieres reportar este mensaje? Nuestro equipo lo revisará siguiendo las pautas de la comunidad espiritual.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement report functionality
            },
            child: Text("Reportar"),
          ),
        ],
      ),
    );
  }

  void _onCameraPressed() {
    // Implement camera functionality
  }

  void _onGalleryPressed() {
    // Implement gallery functionality
  }

  void _showMenuOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 1.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            SizedBox(height: 4.h),
            _buildMenuOption(
              icon: "person",
              label: "Ver perfil",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/profile-detail');
              },
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              icon: "block",
              label: "Bloquear usuario",
              onTap: () {
                Navigator.pop(context);
                _showBlockConfirmation();
              },
            ),
            SizedBox(height: 2.h),
            _buildMenuOption(
              icon: "report",
              label: "Reportar usuario",
              onTap: () {
                Navigator.pop(context);
                _showReportConfirmation();
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: icon,
              size: 6.w,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  void _showBlockConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Bloquear usuario",
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          "¿Estás seguro de que quieres bloquear a ${_partner["name"]}? No podrán contactarte ni ver tu perfil.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text("Bloquear"),
          ),
        ],
      ),
    );
  }

  void _showReportConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Reportar usuario",
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: Text(
          "¿Quieres reportar a ${_partner["name"]} por comportamiento inapropiado? Nuestro equipo revisará el caso.",
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement report functionality
            },
            child: Text("Reportar"),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMessageList() {
    List<Widget> widgets = [];
    DateTime? lastDate;

    for (int i = 0; i < _messages.length; i++) {
      final message = _messages[i];
      final messageDate = message["timestamp"] as DateTime;
      final currentDate =
          DateTime(messageDate.year, messageDate.month, messageDate.day);

      // Add date separator if needed
      if (lastDate == null || lastDate != currentDate) {
        widgets.add(DateSeparatorWidget(date: messageDate));
        lastDate = currentDate;
      }

      // Add message bubble
      widgets.add(
        MessageBubbleWidget(
          message: message,
          isMe: message["senderId"] == "current_user",
          onLongPress: () => _onMessageLongPress(message),
        ),
      );
    }

    // Add typing indicator if partner is typing
    if (_isTyping) {
      widgets.add(TypingIndicatorWidget(partnerName: _partner["name"]));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: ChatHeaderWidget(
        partner: _partner,
        onBackPressed: () => Navigator.pop(context),
        onProfileTap: () => Navigator.pushNamed(context, '/profile-detail'),
        onMenuPressed: _showMenuOptions,
      ),
      body: Column(
        children: [
          // Community guidelines reminder
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            color: AppTheme.lightTheme.colorScheme.secondary
                .withValues(alpha: 0.1),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: "info_outline",
                  size: 4.w,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    "Mantén una comunicación consciente y auténtica 🙏",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Messages area
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Implement message history loading
                await Future.delayed(Duration(seconds: 1));
              },
              child: ListView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 2.h),
                children: _buildMessageList(),
              ),
            ),
          ),

          // Conversation starters
          if (_showConversationStarters && _messages.length <= 6)
            ConversationStarterWidget(
              suggestions: _conversationStarters,
              onSuggestionTap: _onSuggestionTap,
            ),

          // Message input
          MessageInputWidget(
            onSendMessage: _sendMessage,
            onCameraPressed: _onCameraPressed,
            onGalleryPressed: _onGalleryPressed,
          ),
        ],
      ),
    );
  }
}
