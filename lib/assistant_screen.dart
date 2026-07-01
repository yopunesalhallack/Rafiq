import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kInputBgColor = Color(0xFFF5F6F7);

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});
  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  //   temp data to view
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'ما هي المهام ذات الأولوية لهذا اليوم؟', isUser: true),
    ChatMessage(
      text:
          'أهلاً أحمد! أولوياتك هي "مراجعة عرض المشروع".\nهل تريد مراجعة الجدول؟',
      isUser: false,
    ),
  ];

  //   add new message
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: _messageController.text.trim(), isUser: true),
      );
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Ai response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'تم استلام طلبك. سأقوم بمساعدتك في ذلك الآن.',
            isUser: false,
          ),
        );
      });
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final locale = ref.watch(localeProvider);
    //final isArabic = locale.languageCode == 'ar';
    return Directionality(
      //textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.from(alpha: 1, red: 0.89, green: 0.957, blue: 0.965),
                Color.fromARGB(255, 162, 234, 236),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),

              const SizedBox(height: 10),

              // chat list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return _buildChatBubble(message);
                  },
                ),
              ),

              _buildSuggestions(),

              const SizedBox(height: 16),

              _buildInputArea(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 50,
                height: 50,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.asset('assets/images/logogd.png'),
              ),
              // const SizedBox(width: 8),
              // const Text(
              //   'رفيق',
              //   style: TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //     color: kPrimaryColor,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    final bool isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8, top: 2),
              decoration: const BoxDecoration(
                color: Color(0xFFE3F4F6),
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/logogd.png'), //logo icon
            ),
          ],

          // فقاعة الكلام
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isUser ? kPrimaryColor : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: isUser ? Colors.white : kDarkText,
                ),
              ),
            ),
          ),

          if (isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                color: Colors.orangeAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, size: 18, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildSuggestionChip('خطط ليومي'),
          const SizedBox(width: 12),
          _buildSuggestionChip('تحديث حالة هدف'),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return OutlinedButton(
      onPressed: () {
        _messageController.text = label;
        _sendMessage();
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: kPrimaryColor),
        foregroundColor: kPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 8),

          //  input field
          Expanded(
            child: TextField(
              controller: _messageController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'اكتب رسالتك...',
                hintStyle: TextStyle(color: kGreyText),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(Icons.sentiment_satisfied_outlined, color: kGreyText),
          ),
        ],
      ),
    );
  }
}

// --- data module ---
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
