import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'business_logics/view_models/Auth_viewmodel.dart';
import 'business_logics/view_models/Feed_viewmodel.dart';
import 'ui/screens/auth_views/Splash_screen.dart';
import 'business_logics/view_models/Search_viewmodel.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';
import 'package:provider/provider.dart';
import 'business_logics/view_models/home_viewmodel.dart';
import 'business_logics/view_models/Profile_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModelProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("Building My App");
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthViewModel()),
          ChangeNotifierProvider(create: (context) => SearchViewModel()),
          ChangeNotifierProvider(create: (context) => FeedViewModel()),
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
          ChangeNotifierProvider(
            create: (_) => HomeViewModel(),
          )
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            home: SplashScreen(),
            theme: Provider.of<ThemeModelProvider>(context, listen: true)
                .currentTheme));
  }
}
