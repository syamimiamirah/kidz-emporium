import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:kidz_emporium/Screens/home.dart';
import 'package:kidz_emporium/contants.dart';
import 'package:kidz_emporium/Screens/register_page.dart';
import 'package:kidz_emporium/models/login_request_model.dart';
import 'package:kidz_emporium/services/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage>{
  bool isAPICallProcess =  false;
  bool hidePassword = true;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: _loginUI(context),
          ),
        ),
      ),
    );
  }
  Widget _loginUI(BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                "assets/images/logo-centre.png",
                //width: 150,
                height: 300,
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text("Welcome Back", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,),
                ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "email", "Email",
                    (onValidateVal){
                  if(onValidateVal.isEmpty){
                    return "Email can't be empty";
                  }
                  bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9+\.[a-zA-Z]+")
                      .hasMatch(onValidateVal);
                  if(!emailValid){
                    return "Invalid Email";
                  }
                  return null;
                },
                    (onSavedVal){
                  email = onSavedVal.toString().trim();
                },
                prefixIconColor: kSecondaryColor,
                showPrefixIcon: true,
                prefixIcon: Icon(Icons.email),
                borderRadius: 10,
                borderColor: Colors.grey,
                contentPadding: 15,
                fontSize: 14,
                prefixIconPaddingLeft: 10,
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "password", "Password",
                    (onValidateVal){
                  if(onValidateVal.isEmpty){
                    return "Password can't be empty";
                  }
                  return null;
                },
                    (onSavedVal){
                  password = onSavedVal;
                },
                prefixIconColor: kSecondaryColor,
                showPrefixIcon: true,
                prefixIcon: Icon(Icons.lock),
                borderRadius: 10,
                borderColor: Colors.grey,
                contentPadding: 15,
                fontSize: 14,
                prefixIconPaddingLeft: 10,
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: (){
                    hidePassword = !hidePassword;
                  },
                    color: Colors.white,
                  icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility)
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: FormHelper.submitButton(
                  "Sign In", (){
                    if(validateAndSave()){
                      setState(() {
                        isAPICallProcess = true;//API
                      });
                      LoginRequestModel model = LoginRequestModel(
                        email: email!,
                        password: password!,
                      );
                      APIService.login(model).then((response){
                        setState(() {
                          isAPICallProcess = false;//API
                        });

                        if(response){
                          FormHelper.showSimpleAlertDialog(
                              context,
                              Config.appName,
                              "User Logged-In Successfully",
                              "OK",
                                  () {
                                Navigator.of(context).pop();
                                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                              },
                          );
                        }else{
                          FormHelper.showSimpleAlertDialog(
                            context,
                            Config.appName,
                            "Invalid Email/Password!",
                            "OK",
                                (){
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      });
                    }
                  },
              btnColor: Colors.pink,
              txtColor: Colors.white,
              borderRadius: 10,
                borderColor: Colors.pink,
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Dont have an account?",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                        color: Colors.orange,fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = (){
                        Navigator.of(context).pushNamedAndRemoveUntil("/register", (route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

          ]
      ),
    );
  }



  bool validateAndSave(){
    final form = globalFormKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }
}