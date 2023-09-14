import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socialmedia/common/custom_buttom.dart';
import 'package:socialmedia/common/utills.dart';
import 'package:socialmedia/features/signup/signup_screen.dart';
import 'package:socialmedia/services/auth_methods.dart';
import 'package:socialmedia/utils/colors.dart';
import 'package:socialmedia/utils/globalvariables.dart';

import '../../common/loader.dart';
import '../../common/text_input_field.dart';
import '../../responsive/mobile_layout.dart';
import '../../responsive/responsive_layout.dart';
import '../../responsive/web_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool ispassword = true;
  bool isLoading = false;

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().loginMethod(
      email: emailcontroller.text,
      password: passwordcontroller.text,
    );

    setState(() {
      isLoading = false;
    });

    if (res == "Login Succes") {
      //
      showSnackBar(context, res);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (contex) => const ResponsiveLayout(
            webScreenLayout: WebscreenLayout(),
            mobileScreenLayout: MobilescreenLayout(),
          ),
        ),
      );
    } else {
      showSnackBar(context, res);
    }
  }

  void navigateToSignUpScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (contex) => const SignUpScreen(),
      ),
    );
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3,
                  )
                : const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
            child: Column(
              // shrinkWrap: true,

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flexible(
                //   flex: 2,
                //   child: Container(),
                // ),

                // logo
                SvgPicture.asset(
                  "assets/ic_instagram.svg",
                  colorFilter: const ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                  height: 64,
                ),
                const SizedBox(
                  height: 25,
                ),
                // input file for email

                TextFieldInput(
                  hint: "Email",
                  controller: emailcontroller,
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 25,
                ),
                // input file for password
                TextFieldInput(
                  hint: "Password",
                  controller: passwordcontroller,
                  inputType: TextInputType.text,
                  isPass: ispassword,
                  suffixicon: ispassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  sufficonpressed: () {
                    if (ispassword == true) {
                      setState(() {
                        ispassword = false;
                      });
                    } else {
                      setState(() {
                        ispassword = true;
                      });
                    }
                    // setState(() {
                    //   if(ispassword == true){

                    //   }
                    //   ispassword = false;
                    // });
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                isLoading
                    ? const Loader()
                    : CustomButton(
                        text: "Login",
                        onTap: loginUser,
                        backgroundcolor: blueColor,
                        fontWeight: FontWeight.bold,
                      ),
                const SizedBox(
                  height: 15,
                ),
                // Flexible(
                //   flex: 2,
                //   child: Container(),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Don't have an Account? "),
                    ),
                    GestureDetector(
                      onTap: navigateToSignUpScreen,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
