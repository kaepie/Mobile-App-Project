import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_mobile_app/firebase_options.dart';
import 'package:project_mobile_app/pages/create_record/create_record.dart';
import 'package:project_mobile_app/pages/home/home.dart';
import 'package:project_mobile_app/pages/login/login.dart';
import 'package:project_mobile_app/pages/create_category/createCategory.dart';
import 'package:project_mobile_app/pages/setting/setting.dart';
import 'package:project_mobile_app/pages/signup/signup.dart';
import 'package:project_mobile_app/pages/summary/summary.dart';
import 'package:project_mobile_app/pages/welcome/bloc/welcomeBloc.dart';
import 'package:project_mobile_app/widgets/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
    //
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        defaultColor: CustomColor.primaryColor,
        ledColor: Colors.white,
      ),
    ],
  );
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  // ตั้งค่า schedule notification
  await AwesomeNotifications().createNotification(
    schedule: NotificationAndroidCrontab.weekly(
      // กำหนด referenceDateTime เป็นวันที่ 1 ของเดือนปัจจุบัน
      referenceDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
        12,
        00,
      ),
    ),
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Need to Manage Your Money?',
      body: 'Let\'s manage how you spend your money.!',
      payload: {'action': 'openApp'},
    ),
  );

  await initializeFirebase();
  await FirebaseAppCheck.instance.activate();
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => WelcomeBloc()),
      ],
      child: ScreenUtilInit(
          builder: (context, child) => MaterialApp(
                theme: ThemeData(
                  fontFamily: "Inter",
                  textTheme: const TextTheme(
                    headlineLarge: TextStyle(fontSize: 24),
                    headlineMedium: TextStyle(fontSize: 20),
                    headlineSmall: TextStyle(fontSize: 18),
                    bodyLarge: TextStyle(fontSize: 18),
                    bodyMedium: TextStyle(fontSize: 16),
                    bodySmall: TextStyle(fontSize:14),
                    labelLarge: TextStyle(fontSize:16),
                    labelMedium: TextStyle(fontSize: 14),
                    labelSmall: TextStyle(fontSize: 12),
                  ),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                debugShowCheckedModeBanner: false,
                home: const Login(),
                routes: {
                  'login': (context) => const Login(),
                  'signup': (context) => const Signup(),
                  'home': (context) => Home(),
                  'summary': (context) => Summary(),
                  'setting': (context) => const Setting(),
                  'create_record': (context) => CreateRecord(),
                  'create_category': (context) => const CreateCategory()
                },
              )),
    );
  }
}
