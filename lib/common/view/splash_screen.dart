import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:prac/common/const/colors.dart';
import 'package:prac/common/const/data.dart';
import 'package:prac/common/layout/default_layout.dart';
import 'package:prac/common/view/root_tab.dart';
import 'package:prac/user/view/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // storage.deleteAll();
    checkToken();
  }

  void checkToken() async {
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    final dio = Dio();

    try {
      final response = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken',
          },
        ),
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: response.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => RootTab(),
        ),
            (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
            SizedBox(height: 16.0),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
