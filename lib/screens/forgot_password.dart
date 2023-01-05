import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:auto_sales_flutter/screens/login.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Passord',
              ),
              SizedBox(height: 5.0),
              Text(
                'Please insert your email address to resset your password!',
                selectionColor: Color.fromARGB(255, 0, 6, 10),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                controller: _emailController,
                validator: (value) {
                  if (value != null && !EmailValidator.validate(value)) {
                    return ' Please enter your email';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 50.0),
              ElevatedButton(
                child: Text('Forgot Password'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    print('${_emailController.text}');
                    try {
                      final newPassword = await _auth.sendPasswordResetEmail(
                          email: _emailController.text);

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                          (route) => false);
                    } on FirebaseAuthException catch (e) {
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
