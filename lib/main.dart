import 'package:flutter/material.dart';
import 'package:prac/common/component/custom_text_form.dart';

void main() {
  runApp(
    _App(),
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              hintText: '이메일을 입력해주세요.',
              onChanged: (value) {},
            ),
            CustomTextFormField(
              hintText: '비밀번호 입력해주세요.',
              obscureText: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
