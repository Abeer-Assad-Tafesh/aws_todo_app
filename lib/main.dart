// Amplify Flutter Packages
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:aws_todo_app/models/ModelProvider.dart';
// Generated in previous step
import 'amplifyconfiguration.dart';

import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:aws_todo_app/home_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await _configureAmplify();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   _configureAmplify();
}


Future<void> _configureAmplify() async {
  try {
    // Add any Amplify plugins you want to use
    final amplifyDataStorage = AmplifyDataStore(modelProvider: ModelProvider.instance);
    final amplifyAuthCognito = AmplifyAuthCognito();
    // await Amplify.addPlugin(amplifyAuthCognito);

    // You can use addPlugins if you are going to be adding multiple plugins
    await Amplify.addPlugins([amplifyAuthCognito, amplifyDataStorage]);

    // Once Plugins are added, configure Amplify
    // Note: Amplify can only be configured once.

    await Amplify.configure(amplifyconfig).then((value) => {
      print('====== configured ======')
    });
  } catch(e){
    safePrint('error =======> $e');
  }
}


 @override
  Widget build(BuildContext context) {
    return Authenticator(
      child: MaterialApp(
        builder: Authenticator.builder(), // this will handle the flow of authentication process
        home: HomePage(),
      ),
    );
  }
}

