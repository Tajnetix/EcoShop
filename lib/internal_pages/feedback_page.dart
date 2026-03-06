import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController controller = TextEditingController();

  Future<void> sendFeedback() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    final user = supabase.auth.currentUser;

    await supabase.from('feedback').insert({
      'user_id': user!.id,
      'message': text,
      'is_read': false,
    });

    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Feedback Chat"),
        backgroundColor: const Color(0xFF1B5E20),
      ),

      body: Column(
        children: [
          /// CHAT HISTORY
          Expanded(
            child: StreamBuilder(
              stream: supabase
                  .from('feedback')
                  .stream(primaryKey: ['id'])
                  .eq('user_id', user!.id)
                  .order('created_at'),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];

                    return Column(
                      children: [
                        /// USER MESSAGE
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: const Color(0xFF1B5E20),
                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Text(
                              msg['message'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        /// ADMIN REPLY
                        if (msg['admin_reply'] != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(12),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg['admin_reply'],
                                    style: const TextStyle(color: Colors.black),
                                  ),

                                  const SizedBox(height: 4),

                                  /// READ / UNREAD
                                  Text(
                                    msg['is_read'] == false ? "Unread" : "Read",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: msg['is_read'] == false
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          /// MESSAGE INPUT
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Write feedback...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  backgroundColor: const Color(0xFF1B5E20),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendFeedback,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}