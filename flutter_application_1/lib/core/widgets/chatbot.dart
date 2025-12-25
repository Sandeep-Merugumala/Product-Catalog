import 'package:flutter/material.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hi! 👋 Welcome to ShopLuxe! How can I help you today?',
      'isBot': true,
      'time': '10:30 AM',
    },
  ];

  final List<String> _quickReplies = [
    '📦 Track my order',
    '💳 Payment options',
    '🎁 Special offers',
    '📞 Contact support',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleChat() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': text,
        'isBot': false,
        'time': _getCurrentTime(),
      });
    });

    _messageController.clear();
    _scrollToBottom();

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text': _getBotResponse(text),
          'isBot': true,
          'time': _getCurrentTime(),
        });
      });
      _scrollToBottom();
    });
  }

  String _getBotResponse(String message) {
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('track') || lowerMessage.contains('order')) {
      return 'I can help you track your order! Please provide your order number. 📦';
    } else if (lowerMessage.contains('payment') ||
        lowerMessage.contains('pay')) {
      return 'We accept all major credit cards, PayPal, and digital wallets. 💳✨';
    } else if (lowerMessage.contains('offer') ||
        lowerMessage.contains('deal')) {
      return 'Great timing! Check our Flash Deals section for up to 60% off! 🎉';
    } else if (lowerMessage.contains('help') ||
        lowerMessage.contains('support')) {
      return 'I\'m here! You can ask about orders, payments, or shipping. 🤝';
    } else if (lowerMessage.contains('hi') || lowerMessage.contains('hello')) {
      return 'Hello! 👋 How can I assist you today?';
    } else {
      return 'I understand you\'re asking about "$message". Let me connect you with our team! 💬';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_isExpanded)
          Positioned(
            bottom: 90,
            right: 16,
            child: Material(
              elevation: 16,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 340,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade600,
                            Colors.purple.shade600
                          ],
                        ),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                              backgroundColor: Colors.white, child: Text('🤖')),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('ShopLuxe Assistant',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _toggleChat,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) =>
                            _buildMessage(_messages[index]),
                      ),
                    ),

                    if (_messages.length <= 2)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _quickReplies.map((reply) {
                            return MouseRegion(
                              cursor: SystemMouseCursors
                                  .click, // Hand cursor for replies
                              child: GestureDetector(
                                onTap: () => _sendMessage(reply),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Text(reply,
                                      style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              onSubmitted: _sendMessage,
                              decoration: InputDecoration(
                                hintText: "Type a message...",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    borderSide: BorderSide.none),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          MouseRegion(
                            cursor: SystemMouseCursors
                                .click, // Hand cursor for send button
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () =>
                                  _sendMessage(_messageController.text),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!_isExpanded)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -5 * _pulseController.value),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12, right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ],
                        ),
                        child: const Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text("Ask me anything! 💬",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent)),
                            Positioned(
                                bottom: -15,
                                right: 10,
                                child: Icon(Icons.arrow_drop_down,
                                    color: Colors.white, size: 30)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                cursor: SystemMouseCursors.click, // Hand cursor for main button
                child: GestureDetector(
                  onTap: _toggleChat,
                  child: AnimatedScale(
                    scale: _isHovered ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.blue.shade600,
                          Colors.purple.shade600
                        ]),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 8))
                        ],
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _isExpanded
                              ? const Icon(Icons.close,
                                  color: Colors.white,
                                  size: 30,
                                  key: ValueKey(1))
                              : const Text('💬',
                                  style: TextStyle(fontSize: 30),
                                  key: ValueKey(2)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    bool isBot = message['isBot'];
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey.shade200 : Colors.blue.shade600,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(message['text'],
            style: TextStyle(color: isBot ? Colors.black87 : Colors.white)),
      ),
    );
  }
}
