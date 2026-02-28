// ─────────────────────────────────────────────────────────────────────────────
//  ChatHistoryStore — In-Memory Session Singleton
//
//  History persists while the app is open (across chatbot open/close).
//  History is cleared automatically when the app is killed/restarted.
//  This matches standard e-commerce chatbot behaviour (Myntra, Zomato, etc.).
// ─────────────────────────────────────────────────────────────────────────────

import 'chatbot_service.dart';

class ChatHistoryStore {
  // Singleton
  static final ChatHistoryStore _instance = ChatHistoryStore._internal();
  factory ChatHistoryStore() => _instance;
  ChatHistoryStore._internal();

  final List<ChatMessage> messages = [];
  bool showQuickReplies = true;

  bool get hasHistory => messages.isNotEmpty;

  /// Called on first open to add the welcome message.
  void ensureWelcomeMessage() {
    if (messages.isEmpty) {
      messages.add(ChatbotService.welcomeMessage());
    }
  }

  /// Clears the entire session history (only called if user explicitly
  /// requests a reset — never called automatically).
  void clear() {
    messages.clear();
    showQuickReplies = true;
  }
}
