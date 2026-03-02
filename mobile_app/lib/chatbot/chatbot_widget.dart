import 'dart:async';
import 'package:flutter/material.dart';
import 'chatbot_service.dart';
import 'chatbot_history_store.dart';
import '../men_fashion_screen.dart';
import '../women_fashion_screen.dart';
import '../kid_fashion_screen.dart';
import '../wishlist_page.dart';
import '../orders_screen.dart';
import '../notifications_page.dart';
import '../address_management.dart';
import '../account_details.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Chatbot FAB  (lives in Navigator Overlay — floats above all screens)
// ─────────────────────────────────────────────────────────────────────────────

typedef TabSwitchCallback = void Function(int index);

class ChatbotFAB extends StatefulWidget {
  final TabSwitchCallback? onSwitchTab;
  const ChatbotFAB({super.key, this.onSwitchTab});

  @override
  State<ChatbotFAB> createState() => _ChatbotFABState();
}

class _ChatbotFABState extends State<ChatbotFAB>
    with TickerProviderStateMixin {
  bool _isOpen = false;

  // Tap-press scale animation
  late final AnimationController _pressCtrl;
  late final Animation<double> _pressAnim;

  // Pulse glow animation (idle)
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut),
    );

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggleChat() async {
    if (_isOpen) return;

    // Press animation
    await _pressCtrl.forward();
    _pressCtrl.reverse();

    setState(() => _isOpen = true);
    _pulseCtrl.stop();

    if (!mounted) return;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (_) => _ChatbotPanel(
        onSwitchTab: (index) {
          Navigator.of(context, rootNavigator: false).pop();
          widget.onSwitchTab?.call(index);
        },
        onNavigatePage: (action) {
          Navigator.of(context, rootNavigator: false).pop();
          _navigatePage(action);
        },
      ),
    );

    if (mounted) {
      setState(() => _isOpen = false);
      _pulseCtrl.repeat(reverse: true);
    }
  }

  void _navigatePage(NavigationAction action) {
    Widget? page;
    switch (action) {
      case NavigationAction.goMen:
        page = const MensSection();
        break;
      case NavigationAction.goWomen:
        page = const WomensSection();
        break;
      case NavigationAction.goKids:
        page = const KidsSection();
        break;
      case NavigationAction.goWishlist:
        page = const WishlistPage();
        break;
      case NavigationAction.goOrders:
        page = const OrdersScreen();
        break;
      case NavigationAction.goNotifications:
        page = const NotificationsPage();
        break;
      case NavigationAction.goAddresses:
        page = const AddressesPage();
        break;
      case NavigationAction.goAccountDetails:
        page = const AccountDetailsPage();
        break;
      default:
        break;
    }
    if (page != null && mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Completely hide (scale + fade) when panel is open so it never
    // overlaps the chat sheet or the send button.
    return Positioned(
      right: 16,
      bottom: 24,
      child: AnimatedScale(
        scale: _isOpen ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: _isOpen ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: IgnorePointer(
            ignoring: _isOpen,
            child: ScaleTransition(
              scale: _pressAnim,
              child: GestureDetector(
                onTap: _toggleChat,
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, child) {
                    return Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF3F6C), Color(0xFFFF7A9C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          // Static shadow
                          BoxShadow(
                            color: const Color(0xFFFF3F6C).withValues(alpha: 0.35),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                          // Pulsing glow
                          BoxShadow(
                            color: const Color(0xFFFF3F6C).withValues(
                              alpha: 0.25 * _pulseAnim.value,
                            ),
                            blurRadius: 20 + 10 * _pulseAnim.value,
                            spreadRadius: 2 + 4 * _pulseAnim.value,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: const Center(
                    child: Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Chat Panel  (reads / writes via ChatHistoryStore singleton)
// ─────────────────────────────────────────────────────────────────────────────

class _ChatbotPanel extends StatefulWidget {
  final void Function(int index) onSwitchTab;
  final void Function(NavigationAction action) onNavigatePage;

  const _ChatbotPanel({
    required this.onSwitchTab,
    required this.onNavigatePage,
  });

  @override
  State<_ChatbotPanel> createState() => _ChatbotPanelState();
}

class _ChatbotPanelState extends State<_ChatbotPanel>
    with TickerProviderStateMixin {
  final ChatbotService _service = ChatbotService();
  final ChatHistoryStore _store = ChatHistoryStore();
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isTyping = false;

  late final AnimationController _typingCtrl;

  @override
  void initState() {
    super.initState();
    _typingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _store.ensureWelcomeMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    _typingCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    _inputCtrl.clear();
    FocusScope.of(context).unfocus();

    setState(() {
      _store.showQuickReplies = false;
      _store.messages.add(ChatMessage(text: trimmed, sender: MessageSender.user));
      _isTyping = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;

    final response = _service.respond(trimmed);
    setState(() {
      _isTyping = false;
      _store.messages.add(ChatMessage(
        text: response.text,
        sender: MessageSender.bot,
        navigationAction: response.navigationAction,
        navigationLabel: response.navigationLabel,
      ));
    });
    _scrollToBottom();
  }

  void _handleNavigation(NavigationAction action) {
    const tabActions = {
      NavigationAction.goHome: 0,
      NavigationAction.goFwd: 1,
      NavigationAction.goLuxe: 2,
      NavigationAction.goBag: 3,
      NavigationAction.goProfile: 4,
    };
    if (tabActions.containsKey(action)) {
      widget.onSwitchTab(tabActions[action]!);
    } else {
      widget.onNavigatePage(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final screenH = MediaQuery.of(context).size.height;
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: screenH * 0.74 + bottomPad,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Drag handle ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 2),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // ── Header ────────────────────────────────────────────────────
          _buildHeader(isDark),

          // ── Messages ──────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              itemCount: _store.messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (_isTyping && i == _store.messages.length) {
                  return _buildTypingBubble(isDark);
                }
                final msg = _store.messages[i];
                return msg.sender == MessageSender.bot
                    ? _buildBotBubble(msg, isDark)
                    : _buildUserBubble(msg, isDark);
              },
            ),
          ),

          // ── Quick replies ─────────────────────────────────────────────
          if (_store.showQuickReplies) _buildQuickReplies(isDark),

          // ── Input bar ─────────────────────────────────────────────────
          _buildInputBar(isDark, bottomPad),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 14, 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF3F6C), Color(0xFFFF7099)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          // Bot avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 1.5),
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          // Name + status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'StyleHub Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF69F0AE),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'Online · Typically replies instantly',
                      style: TextStyle(color: Colors.white70, fontSize: 10.5),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Close / dismiss button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bot bubble ──────────────────────────────────────────────────────────────
  Widget _buildBotBubble(ChatMessage msg, bool isDark) {
    final bubbleBg = isDark ? const Color(0xFF272727) : const Color(0xFFF4F4F4);
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final borderColor = isDark ? const Color(0xFF363636) : const Color(0xFFEBEBEB);
    final navInfo = msg.navigationAction != null
        ? NavigationInfo.forAction(msg.navigationAction!)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF3F6C), Color(0xFFFF7099)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 13),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                  decoration: BoxDecoration(
                    color: bubbleBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    border: Border.all(color: borderColor, width: 0.8),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 13.5,
                      height: 1.55,
                    ),
                  ),
                ),
                // CTA chip
                if (navInfo != null) ...[
                  const SizedBox(height: 7),
                  GestureDetector(
                    onTap: () => _handleNavigation(msg.navigationAction!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF3F6C), Color(0xFFFF6B8A)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF3F6C).withValues(alpha: 0.28),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(navInfo.icon, color: Colors.white, size: 13),
                          const SizedBox(width: 6),
                          Text(
                            '${navInfo.label}  →',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  _fmtTime(msg.time),
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ── User bubble ─────────────────────────────────────────────────────────────
  Widget _buildUserBubble(ChatMessage msg, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(width: 44),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF3F6C), Color(0xFFFF6B8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF3F6C).withValues(alpha: 0.22),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _fmtTime(msg.time),
                  style: TextStyle(color: Colors.grey[500], fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color(0xFFFF3F6C).withValues(alpha: 0.12),
            child: const Icon(Icons.person, color: Color(0xFFFF3F6C), size: 15),
          ),
        ],
      ),
    );
  }

  // ── Typing indicator ────────────────────────────────────────────────────────
  Widget _buildTypingBubble(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFFF3F6C), Color(0xFFFF7099)]),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 13),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF272727) : const Color(0xFFF4F4F4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(
                color: isDark ? const Color(0xFF363636) : const Color(0xFFEBEBEB),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _typingCtrl,
                  builder: (_, __) {
                    final t = ((_typingCtrl.value + i * 0.33) % 1.0);
                    final dy = -5.0 * (1.0 - (2 * t - 1).abs().clamp(0.0, 1.0));
                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 7, height: 7,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white54 : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Quick replies ───────────────────────────────────────────────────────────
  Widget _buildQuickReplies(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ChatbotService.quickReplies().map((reply) {
            return GestureDetector(
              onTap: () => _sendMessage(reply),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3F6C)
                      .withValues(alpha: isDark ? 0.18 : 0.07),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFFF3F6C).withValues(alpha: 0.38),
                    width: 0.9,
                  ),
                ),
                child: Text(
                  reply,
                  style: const TextStyle(
                    color: Color(0xFFFF3F6C),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Input bar ───────────────────────────────────────────────────────────────
  Widget _buildInputBar(bool isDark, double bottomPad) {
    final borderColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFE5E5E5);
    final inputBg = isDark ? const Color(0xFF262626) : const Color(0xFFF8F8F8);
    final hintColor = isDark ? Colors.grey[600] : Colors.grey[400];
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottomPad),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          border: Border(top: BorderSide(color: borderColor, width: 0.8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 44, maxHeight: 100),
                decoration: BoxDecoration(
                  color: inputBg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor, width: 0.9),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  style: TextStyle(color: textColor, fontSize: 14),
                  maxLines: 4,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: hintColor, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12,
                    ),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Send button
            GestureDetector(
              onTap: () => _sendMessage(_inputCtrl.text),
              child: Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF3F6C), Color(0xFFFF7099)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.send_rounded, color: Colors.white, size: 19),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m ${t.hour < 12 ? "AM" : "PM"}';
  }
}
