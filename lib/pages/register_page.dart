import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.grey,
      blur: 1,

      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(height: 130),
                Image.asset('assets/images/scholar.png', height: 100),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Scholer Chat',
                    style: TextStyle(
                      fontSize: 34,
                      color: Colors.white,
                      fontFamily: 'pacifico',
                    ),
                  ),
                ),
                SizedBox(height: 90),
                // SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                SizedBox(height: 12),
                CustomFormTextField(
                  onChange: (data) {
                    email = data;
                  },
                  hintText: 'Enter your email...',
                  icon: Icons.email,
                ),
                SizedBox(height: 18),
                CustomFormTextField(
                  obscureText: true,
                  onChange: (data) {
                    password = data;
                  },
                  hintText: 'Enter your password...',
                  icon: Icons.password_outlined,
                ),
                SizedBox(height: 22),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        // 1. محاولة إنشاء الحساب
                        await registerUser();
                        // 2. لو وصل لهنا يبقى نجح، نعرض رسالة النجاح
                        showSnackBar(context, 'Email Created Successfully');

                        // هنا المفروض تنقله للصفحة اللي بعدها (Home أو Chat)
                        Navigator.pushNamed(context, LoginPage.id);
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'email-already-in-use') {
                          showSnackBar(context, 'Email already in use');
                        } else if (ex.code == 'weak-password') {
                          showSnackBar(context, 'Weak Password');
                        }
                      } catch (ex) {
                        showSnackBar(context, 'There was an error');
                      }
                    }
                    isLoading = false;
                    setState(() {});
                  },
                  title: 'Register',
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?  ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login now',
                        style: TextStyle(
                          color: Color(0xffc0e6fd),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
