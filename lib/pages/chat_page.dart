import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/message.dart';
import '../widgets/chat_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  static String id = 'ChatPage';

  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  final _scrollController = ScrollController();

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  // دالة الإرسال الموحدة
  void sendMessage(String email) {
    if (controller.text.trim().isNotEmpty) {
      messages.add({
        kMessage: controller.text,
        kCreatedAt: DateTime.now(),
        'id': email, // بنسجل الايميل عشان نعرف الرسالة دي بتاعت مين
      });
      controller.clear();
      // بما اننا عاملين reverse: true
      // فالنزول لأخر الشات معناه الذهاب للنقطة 0
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // استقبال الايميل
    var email = ModalRoute.of(context)!.settings.arguments as String;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: kPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(KLogo, height: 65),
                  Text(' Chat', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true, // الشات بيبدأ من تحت
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      // مقارنة الايميل لتحديد شكل الفقاعة
                      return messagesList[index].id == email
                          ? ChatBuble(message: messagesList[index])
                          : ChatBubleForFriend(message: messagesList[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
                  child: TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      sendMessage(email); // استدعاء الدالة عند ضغط انتر
                    },
                    decoration: InputDecoration(
                      // تفعيل زرار الارسال الجانبي
                      suffixIcon: IconButton(
                        onPressed: () {
                          sendMessage(email); // استدعاء الدالة عند ضغط الايقونة
                        },
                        icon: Icon(Icons.send_rounded, color: kPrimaryColor),
                      ),
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
