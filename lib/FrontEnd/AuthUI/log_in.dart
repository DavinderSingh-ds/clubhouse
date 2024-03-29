import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_signin/Backend/firebase/Auth/email_and_pwd_auth.dart';
import 'package:google_signin/Backend/firebase/Auth/fb_auth.dart';
import 'package:google_signin/Backend/firebase/Auth/google_auth.dart';
import 'package:google_signin/FrontEnd/NewUserEntry/new_user_entry.dart';
import 'package:google_signin/Global_Uses/enum_generation.dart';
import 'package:google_signin/Global_Uses/reg_exp.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'common_auth_methods.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final GlobalKey<FormState> _logInKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pwd = TextEditingController();

  final EmailAndPasswordAuth _emailAndPasswordAuth = EmailAndPasswordAuth();
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();
  final FacebookAuthentication _facebookAuthentication =
      FacebookAuthentication();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingOverlay(
          isLoading: _isLoading,
          color: Colors.black54,
          child: Container(
            color: Colors.transparent,
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                const Center(
                  child: Text(
                    'Log-In',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 60.0, bottom: 10.0),
                  child: Form(
                    key: _logInKey,
                    child: ListView(
                      children: [
                        commonTextFormField(
                            hintText: 'Email',
                            validator: (String? inputVal) {
                              if (!emailRegex.hasMatch(inputVal.toString())) {
                                return 'Email format is not matching';
                              }
                              return null;
                            },
                            textEditingController: _email),
                        commonTextFormField(
                            hintText: 'Password',
                            validator: (String? inputVal) {
                              if (inputVal!.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            textEditingController: _pwd),
                        logInAuthButton(context, 'Log-In'),
                      ],
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Or Continue With',
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ),
                logInSocialMediaIntegrationButtons(),
                switchAnotherAuthScreen(
                    context, "Don't Have an Account? ", 'Sign-Up'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logInAuthButton(BuildContext context, String buttonName) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width - 60, 30.0),
            elevation: 5.0,
            shadowColor: Colors.amber,
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 7.0,
              bottom: 7.0,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            )),
        child: Text(
          buttonName,
          style: const TextStyle(
            fontSize: 25.0,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        onPressed: () async {
          if (_logInKey.currentState!.validate()) {
            log('Validated');
            SystemChannels.textInput.invokeMethod('TextInput.hide');

            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }

            final EmailSignInResults emailSignInResults =
                await _emailAndPasswordAuth.signInWithEmailAndPassword(
                    email: _email.text, pwd: _pwd.text);

            String msg = '';
            if (emailSignInResults == EmailSignInResults.SignInCompleted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const TakePrimaryUserData()),
                  (route) => false);
            } else if (emailSignInResults ==
                EmailSignInResults.EmailNotVerified) {
              msg =
                  'Email not Verified.\nPlease Verify your email and then Log In';
            } else if (emailSignInResults ==
                EmailSignInResults.EmailOrPasswordInvalid) {
              msg = 'Email And Password Invalid';
            } else {
              msg = 'Sign In Not Completed';
            }

            if (msg != '') {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));
            }

            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          } else {
            log('Not Validated');
          }
        },
      ),
    );
  }

  Widget logInSocialMediaIntegrationButtons() {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              log('Google Pressed');
              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }

              final GoogleSignInResults _googleSignInResults =
                  await _googleAuthentication.signInWithGoogle();

              String msg = '';

              if (_googleSignInResults == GoogleSignInResults.SignInCompleted) {
                msg = 'Sign In Completed';
              } else if (_googleSignInResults ==
                  GoogleSignInResults.SignInNotCompleted) {
                msg = 'Sign In not Completed';
              } else if (_googleSignInResults ==
                  GoogleSignInResults.AlreadySignedIn) {
                msg = 'Already Google SignedIn';
              } else {
                msg = 'Unexpected Error Happen';
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));

              if (_googleSignInResults == GoogleSignInResults.SignInCompleted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TakePrimaryUserData()),
                    (route) => false);
              }

              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: Image.asset(
              'assets/images/google.png',
              width: 50.0,
            ),
          ),
          const SizedBox(
            width: 80.0,
          ),
          GestureDetector(
            onTap: () async {
              log('Facebook Pressed');

              if (mounted) {
                setState(() {
                  _isLoading = true;
                });
              }

              final FBSignInResults _fbSignInResults =
                  await _facebookAuthentication.facebookLogIn();

              String msg = '';

              if (_fbSignInResults == FBSignInResults.SignInCompleted) {
                msg = 'Sign In Completed';
              } else if (_fbSignInResults ==
                  FBSignInResults.SignInNotCompleted) {
                msg = 'Sign In not Completed';
              } else if (_fbSignInResults == FBSignInResults.AlreadySignedIn) {
                msg = 'Already Google SignedIn';
              } else {
                msg = 'Unexpected Error Happen';
              }

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(msg)));

              if (_fbSignInResults == FBSignInResults.SignInCompleted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const TakePrimaryUserData()),
                    (route) => false);
              }

              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: Image.asset(
              'assets/images/fbook.png',
              width: 50.0,
            ),
          ),
        ],
      ),
    );
  }
}
