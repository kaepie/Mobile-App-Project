import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_mobile_app/Widgets/colors.dart';
import 'package:project_mobile_app/pages/signup/signup_widget.dart';
import 'package:project_mobile_app/services/flutterfire.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                  child: Form(
                key: _formkey,
                child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Image.asset(
                          "assets/images/logo_nobackground.png",
                          width: 100.w,
                          height: 100.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 25),
                          child: Text(
                            "Sign up",
                            style: TextStyle(fontSize: 22.sp),
                          ),
                        ),
                        buildTextField(
                            "Email",
                            const FaIcon(FontAwesomeIcons.solidUser),
                            "Email",
                            emailController),
                        const SizedBox(
                          height: 20,
                        ),
                        buildTextField(
                            "Username",
                            const FaIcon(FontAwesomeIcons.circleUser),
                            "Email",
                            usernameController),
                        SizedBox(
                          height: 20.h,
                        ),
                        buildTextField(
                            "Password",
                            const FaIcon(FontAwesomeIcons.key),
                            "Password",
                            passwordController),
                        SizedBox(
                          height: 20.h,
                        ),
                        buildTextField(
                            "Confirm Password",
                            const FaIcon(FontAwesomeIcons.key),
                            "Password",
                            confirmPasswordController),
                        SizedBox(
                          height: 30.h,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_formkey.currentState!.validate()) {
                              if (passwordController.text.trim() ==
                                  confirmPasswordController.text.trim()) {
                                bool registerPass = await register(
                                    usernameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    context);
                                if (registerPass) {
                                  Navigator.pushNamed(context, 'login');
                                }
                              }
                            }
                          },
                          child: button("Sign up", CustomColor.primaryColor),
                        ),
                      ]),
                ),
              ))),
        ));
  }
}
