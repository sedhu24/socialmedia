import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/common/custom_buttom.dart';
import 'package:socialmedia/common/loader.dart';
import 'package:socialmedia/common/utills.dart';
import 'package:socialmedia/features/login/login_screen.dart';
import 'package:socialmedia/services/auth_methods.dart';
import 'package:socialmedia/utils/colors.dart';

import '../../common/text_input_field.dart';
import '../../responsive/mobile_layout.dart';
import '../../responsive/responsive_layout.dart';
import '../../responsive/web_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();

  final TextEditingController usernamecontroller = TextEditingController();
  final signUpkey = GlobalKey<FormState>();
  Uint8List? _image;
  bool isLoading = false;
  bool ispassword = true;

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().signupmethod(
      email: emailcontroller.text,
      password: passwordcontroller.text,
      bio: biocontroller.text,
      username: usernamecontroller.text,
      file: _image!,
    );
    print("Sign up Clicked");

    setState(() {
      isLoading = false;
    });

    if (res != "Account Created Successfully") {
      showSnackBar(context, res);
    } else {
      showSnackBar(context, res);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (contex) => const ResponsiveLayout(
            webScreenLayout: WebscreenLayout(),
            mobileScreenLayout: MobilescreenLayout(),
          ),
        ),
      );
    }
  }

  void navigateToLogInScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (contex) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    biocontroller.dispose();
    usernamecontroller.dispose();
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
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //   flex: 1,
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
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 64,
                              ),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFieldInput(
                    hint: "Username",
                    controller: usernamecontroller,
                    inputType: TextInputType.text,
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
                  TextFieldInput(
                    hint: "User Bio",
                    controller: biocontroller,
                    inputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  isLoading
                      ? const Loader()
                      : CustomButton(
                          text: "Sign up",
                          onTap: signUpUser,
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
                        child: const Text("Already have an account ? "),
                      ),
                      GestureDetector(
                        onTap: navigateToLogInScreen,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            "Login",
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
      ),
    ));
  }
}
