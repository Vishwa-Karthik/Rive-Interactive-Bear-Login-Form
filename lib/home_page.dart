import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interactive_ui/Utils/colors.dart';
import 'package:interactive_ui/Widgets/myTextField.dart';
import 'package:rive/rive.dart';

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
  late SMITrigger fairTrigger, successTrigger;

  //* SMI Bool for eyes
  late SMIBool stareEyes, closeEyes;

  //* Art Board
  Artboard? artboard;

  //* State Machine Controller
  late StateMachineController? stateMachineController;

  @override
  void initState() {
    super.initState();
    initRiveArtBoard();
  }

  initRiveArtBoard() {
    rootBundle.load(animatePath).then((data) {
      final file = RiveFile.import(data);
      final art = file.mainArtboard;

      stateMachineController =
          StateMachineController.fromArtboard(art, "Login");

      if (stateMachineController != null) {
        art.addController(stateMachineController!);
      }

      setState(() {
        artboard = art;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //* appbar
      backgroundColor: kPrimaryColor,

      //* body
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //todo rive animation

          if (artboard != null)
            SizedBox(
              width: 350,
              height: 350,
              child: Rive(artboard: artboard!),
            ),

          Text(
            "LOGIN",
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),

          //todo login form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                color: Colors.transparent,
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
                    MyTextField(
                      controller: emailController,
                      labelText: "Email",
                      obscureText: false,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
                      ),
                    ),

                    //* password
                    MyTextField(
                      controller: passwordController,
                      labelText: "Password",
                      obscureText: true,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.visibility_off,
                        ),
                        onPressed: () {},
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //* login button
                    ButtonTheme(
                      minWidth: 80,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
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
        ],
      ),
    );
  }
}
