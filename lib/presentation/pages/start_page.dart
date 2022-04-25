import 'package:flutter/material.dart';
import 'package:lab_3/presentation/pages/auth_page.dart';
import 'package:lab_3/presentation/utils/image_constants.dart';

import '../widgets/custom_button.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            ImageConstants.onBoarding,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: 126,
            right: 0,
            left: 0,
            child: Center(
              child: CustomButton(
                onPressed: () => _navigateToLoginPage(context),
                text: 'Войти в аккаунт',
              ),
            ),
          ),
          Positioned(
            bottom: 85,
            right: 0,
            left: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => _navigateToRegisterPage(context),
                child: const Text(
                  'Ещё нет аккаунта? Зарегистрируйтесь',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLoginPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => const AuthPage(isLoginForm: true));
    Navigator.pushReplacement(context, route);
  }

  void _navigateToRegisterPage(BuildContext context) {
    final route = MaterialPageRoute(builder: (context) => const AuthPage(isLoginForm: false));
    Navigator.pushReplacement(context, route);
  }
}
