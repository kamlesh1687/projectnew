import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/core/locator.dart';
import 'package:projectnew/features/presentation/providers/profileNotifier.dart';

import 'package:projectnew/features/presentation/ui/authpages/CreateUser.dart';
import 'package:projectnew/features/presentation/ui/authpages/LogInView.dart';
import 'package:projectnew/features/presentation/ui/authpages/SignUpView.dart';

import 'package:projectnew/ui/screens/home_views/Feed_view.dart';
import 'package:projectnew/ui/screens/home_views/Profile_view.dart';
import 'package:projectnew/ui/screens/home_views/home_view.dart';

import 'package:projectnew/utils/Theming/ColorTheme.dart';
import 'package:provider/provider.dart';

import 'features/presentation/providers/authNotifier.dart';
import 'features/presentation/ui/authpages/Splash_screen.dart';
import 'ui/screens/home_views/Search_view.dart';
import 'ui/screens/other_views/Profile_editview.dart';
import 'ui/screens/other_views/Uploadscreen_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  setUpLocator();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => sl<AuthNotifier>(),
      ),
      ChangeNotifierProvider(
        create: (context) => ThemeModelProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => sl<ProfileNotifier>(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      print('main');
      return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          initialRoute: SplashScreen.routeName,
          routes: {
            SplashScreen.routeName: (context) => SplashScreen(),
            HomeView.routeName: (context) => HomeView(),
            ProfileView.routeName: (context) => ProfileView(),
            SearchView.routeName: (context) => SearchView(),
            FeedView.routeName: (context) => FeedView(),
            ProfileEditView.routeName: (context) => ProfileEditView(),
            UploadScreen.routeName: (context) => UploadScreen(),
            SignUpPage.routeName: (context) => SignUpPage(),
            LoginPage.routeName: (context) => LoginPage(),
            CreateNewUser.routeName: (context) => CreateNewUser(),
          },
          theme:
              Provider.of<ThemeModelProvider>(context, listen: true).darkTheme
                  ? dark
                  : light);
    });
  }
}
