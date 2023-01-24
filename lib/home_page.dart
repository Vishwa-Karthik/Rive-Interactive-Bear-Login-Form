// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_ui/Utils/colors.dart';
import 'package:interactive_ui/Widgets/myTextField.dart';
import 'package:rive/rive.dart';

import 'Widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //* Text controlllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //* Rive Animation Path
  var animatePath = "assets/Rive/bear.riv";

  //* State Machine Input -> SMI Input bool to trigger actions
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  //* SMI Bool for eyes
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;

  //* SMI for numbers of chars in textfield
  SMIInput<double>? lookAtNumber;

  //* Art Board
  Artboard? artboard;

  //* State Machine Controller
  late StateMachineController? controller;

  //* toggle obscure text
  bool isObscureText = false;

  //*
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  //* function to login
  loginFunction() async {
    //* unfocus the textfield
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();

    //* show loading screen
    showLoadingDialog(context);

    //* delay by 2s
    await Future.delayed(
      const Duration(milliseconds: 2000),
    );
    if (mounted) Navigator.pop(context);

    //* check
    if (emailController.text == 'admin' && passwordController.text == "admin") {
      trigSuccess?.change(true);
    } else {
      trigFail?.change(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //* appbar
      backgroundColor: kPrimaryColor,

      //* body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
          ),

          Text(
            "LOGIN",
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          //todo rive animation
          SizedBox(
            height: 300,
            width: 400,
            child: RiveAnimation.asset(
              animatePath,
              fit: BoxFit.contain,
              stateMachines: const ["Login Machine"],
              onInit: (artboard) {
                controller = StateMachineController.fromArtboard(
                  artboard,
                  "Login Machine",
                );

                if (controller == null) return;

                artboard.addController(controller!);

                isChecking = controller?.findInput("isChecking");
                lookAtNumber = controller?.findInput("numLook");
                isHandsUp = controller?.findInput("isHandsUp");
                trigFail = controller?.findInput("trigFail");
                trigSuccess = controller?.findInput("trigSuccess");
              },
            ),
          ),

          //todo login form
          Padding(
            padding: const EdgeInsets.only(left: 23.0, right: 23),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //* email
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: ((value) => lookAtNumber?.change(
                              value.length.toDouble(),
                            )),
                        focusNode: emailFocusNode,
                        obscureText: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: kTextBgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //* password
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        onChanged: ((value) {}),
                        obscureText: isObscureText,
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isObscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscureText = !isObscureText;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: kTextBgColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: kSecondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //* login button
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.width * 0.13,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: loginFunction,
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
