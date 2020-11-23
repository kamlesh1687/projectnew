import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ui/Authentication/SignUp/SignUp_viewmodel.dart';
import 'ui/Authentication/Splash_screen/Splash_screen.dart';
import 'ui/Authentication/Splash_screen/Splash_screenmodel.dart';
import 'ui/Views/Home_screen/Nav_Pages/Search_page/Search_viewmodel.dart';
import 'package:projectnew/utils/ColorTheme.dart';
import 'package:provider/provider.dart';
import 'ui/Views/Home_screen/Landing_page/home_viewmodel.dart';
import 'ui/Views/Home_screen/Nav_Pages/Profile_page/Profile_viewmodel.dart';
import 'ui/Views/Home_screen/Upload_page/UploadScreen_viewmodel.dart';

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
          ChangeNotifierProvider(create: (context) => SignUpViewModel()),
          ChangeNotifierProvider(create: (context) => SplashScreenModel()),
          ChangeNotifierProvider(create: (context) => SearchViewModel()),
          ChangeNotifierProvider(create: (context) => UploadScreenViewModel()),
          ChangeNotifierProvider(create: (context) => ProfileViewModel()),
          ChangeNotifierProvider(
            create: (_) => HomeViewModel(),
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          home: SplashScreen(),
          theme: Provider.of<ThemeModelProvider>(context, listen: true)
              .currentTheme,
        ));
  }
}
