import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class AiPage extends StatefulWidget {
  const AiPage({super.key});

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isGenerating = false;
  Stream<String>? _currentStream;
  late GenerativeModel _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-3.5-flash',
    );
    _chat = _model.startChat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Stream<String> _accumulateStream(Stream<GenerateContentResponse> source) async* {
    String text = '';
    try {
      await for (final chunk in source) {
        text += chunk.text ?? '';
        yield text;
        _scrollToBottom();
      }
    } catch (e) {
      text += '\nError: $e';
      yield text;
      _scrollToBottom();
    } finally {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(text: text, isUser: false));
          _isGenerating = false;
          _currentStream = null;
        });
        _scrollToBottom();
      }
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty || _isGenerating) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isGenerating = true;
      _textController.clear();
    });
    _scrollToBottom();

    try {
      final responseStream = _chat.sendMessageStream(Content.text(text));
      setState(() {
        _currentStream = _accumulateStream(responseStream);
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _messages.add(ChatMessage(text: 'Error generating response.', isUser: false));
        });
        _scrollToBottom();
      }
    }
  }

  Widget _buildMessageBubble({
    required String text,
    required bool isUser,
    required bool isGenerating,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
        ),
        child: isGenerating && text.isEmpty
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Helper Bot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length + (_isGenerating ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return StreamBuilder<String>(
                    stream: _currentStream,
                    builder: (context, snapshot) {
                      return _buildMessageBubble(
                        text: snapshot.data ?? '',
                        isUser: false,
                        isGenerating: true,
                      );
                    },
                  );
                }
                final message = _messages[index];
                return _buildMessageBubble(
                  text: message.text,
                  isUser: message.isUser,
                  isGenerating: false,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _isGenerating ? null : (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                _isGenerating
                    ? const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        color: Theme.of(context).primaryColor,
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
