import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../constants.dart';
import '../helper/show_snack_bar.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
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
                    'LOGIN',
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
                        await loginUser();
                        Navigator.pushNamed(
                          context,
                          ChatPage.id,
                          arguments: email,
                        );
                      } on FirebaseAuthException catch (e) {
                        // 1. اطبع الكود عشان تشوفه بعينك في الـ Console
                        print("Error Code: ${e.code}");
                        print(" The error message is: ${e.message}");

                        // 2. التعديل الجديد: ضيف احتمال invalid-credential
                        if (e.code == 'user-not-found') {
                          showSnackBar(
                            context,
                            'No user found for that email.',
                          );
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context, 'Wrong password provided.');
                        } else if (e.code == 'invalid-credential') {
                          // هو ده اللي بييجي دلوقتي لما الباسورد يكون غلط أو الإيميل مش موجود
                          showSnackBar(context, 'Invalid Email or Password.');
                        }
                      } catch (ex) {
                        showSnackBar(context, 'There was an error');
                      }
                    }
                    isLoading = false;
                    setState(() {});
                  },
                  title: 'Login',
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?  ',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                      child: Text(
                        'Register here',
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

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
