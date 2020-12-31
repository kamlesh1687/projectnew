import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectnew/ui/screens/appstate.dart';
import 'business_logics/view_models/Feed_viewmodel.dart';
import 'ui/screens/auth_views/Splash_screen.dart';
import 'business_logics/view_models/Search_viewmodel.dart';
import 'package:projectnew/utils/Theming/ColorTheme.dart';
import 'package:provider/provider.dart';
import 'business_logics/view_models/Profile_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => AppState()),
      ChangeNotifierProvider(create: (context) => SearchViewModel()),
      ChangeNotifierProvider(create: (context) => FeedViewModel()),
      ChangeNotifierProvider(create: (context) => ProfileViewModel()),
      ChangeNotifierProvider(
        create: (context) => ThemeModelProvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileViewModel>(context, listen: false)
        .loadUserDataFormSf()
        .then((value) {
      if (value != null) {
        Provider.of<FeedViewModel>(context, listen: false)
            .createFeed(value.userId);
      }
    });
    print("Building My App");
    return Builder(builder: (context) {
      return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          theme:
              Provider.of<ThemeModelProvider>(context, listen: true).darkTheme
                  ? dark
                  : light);
    });
  }
}
