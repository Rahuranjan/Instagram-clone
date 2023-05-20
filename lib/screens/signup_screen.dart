import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/responsive/mobile_screen_layout.dart';
import 'package:instagram_flutter/responsive/responsive_layput_screen.dart';
import 'package:instagram_flutter/responsive/web_screen_layout.dart';
import 'package:instagram_flutter/screens/login_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async{
    Uint8List im = await picImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
     setState(() {
       _isLoading = true;
     });
     String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text, 
      username: _usernameController.text, 
      bio: _bioController.text,
      file: _image!
    );

    setState(() {
       _isLoading = false;
     });


    if(res != 'success'){
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(), 
            mobileScreenLayout: MobileScreenLayout(),            ),
          ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex:2, child: Container()),
              // svg image
              SvgPicture.asset('assets/ic_instagram.svg',
               color: primaryColor,
               height: 64),
               const SizedBox(height: 64),

              // circular widget to accept and show our selected file
              Stack(
                children: [
                  _image !=null
                   ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    
                  )
                  : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.vecteezy.com%2Ffree-vector%2Fdefault-profile-picture&psig=AOvVaw1E1SX-sh7bfKuTh3bgjGhe&ust=1684141032410000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCIDPybS49P4CFQAAAAAdAAAAABAE') ,
                    backgroundColor: Colors.red,   
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage, 
                      icon: const Icon(
                        Icons.add_a_photo,
                        ),
                       ),
                      ),
                ],
              ),

              const SizedBox(
                  height: 24,
                ),

              // text field input for username
              TextFieldInput(
                textEditingController: _usernameController, 
                hintText: 'Enter your username', 
                textInputType: TextInputType.text,
                ),

                const SizedBox(
                  height: 24,
                ),

              // text field input for email
              TextFieldInput(
                textEditingController: _emailController, 
                hintText: 'Enter your email', 
                textInputType: TextInputType.emailAddress,
                ),

                const SizedBox(
                  height: 24,
                ),

              // text field input for password
              TextFieldInput(
                textEditingController: _passwordController, 
                hintText: 'Enter your password', 
                textInputType: TextInputType.text,
                isPass: true,
                ),

                const SizedBox(
                  height: 24,
                ),
              
              //bio
              TextFieldInput(
                textEditingController: _bioController, 
                hintText: 'Enter your Bio', 
                textInputType: TextInputType.text,
                ),

                const SizedBox(
                  height: 24,
                ),


              //button login
              InkWell(
                onTap: signUpUser, 
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor
                    ),
                  child: !_isLoading
                   ? const Text(
                    'Sign Up',
                    )
                  : const CircularProgressIndicator(
                    color: primaryColor,
                    ),
                ),
              ),

              const SizedBox(
                  height: 24,
                ),
              Flexible(flex:2, child: Container()),
              // transitionong to signing up

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const Text("have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      
                      child: const Text("Login.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
         ),
        ),
    );
  }
}