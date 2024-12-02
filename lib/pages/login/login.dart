import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_mobile_app/pages/login/login_widgets.dart';
import 'package:project_mobile_app/services/flutterfire.dart';
import 'package:project_mobile_app/widgets/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Image.asset(
                          "assets/images/logo_nobackground.png",
                          width: 100.w,
                          height: 100.h,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 22.sp),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        // reuseableText("Email"),
                        buildTextField(
                            "Email",
                            const FaIcon(FontAwesomeIcons.solidUser),
                            "Email",
                            emailController),
                        SizedBox(
                          height: 25.h,
                        ),
                        // reuseableText("Password"),
                        buildTextField(
                            "Password",
                            const FaIcon(FontAwesomeIcons.lock),
                            "Password",
                            passwordController),
                        SizedBox(
                          height: 25.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            bool signInPass = await signIn(
                                emailController.text.trim(),
                                passwordController.text.trim());
                            // "Thanawatptd@hotmail.com",
                            // "123456");
                            if (signInPass) {
                              Navigator.pushNamed(context, 'home'); //go to page
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Sign In Error'),
                                      content: Text(
                                        "Invalid email or password. Please try again.",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStatePropertyAll(
                                                      CustomColor
                                                          .primaryColor)),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            }
                          },
                          child: loginButton("Login", CustomColor.primaryColor),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              reuseableText("Don't have account? "),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, 'signup'),
                                child: signUpButton(),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              )),
        ));
  }
}
