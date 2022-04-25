import 'package:flutter/material.dart';
import 'package:lab_3/data/repos/auth_repository.dart';
import 'package:lab_3/presentation/pages/home/home_controller.dart';
import 'package:lab_3/presentation/pages/home/home_page.dart';
import 'package:lab_3/presentation/widgets/custom_button.dart';

import '../../data/datasources/remote_datasource.dart';
import '../utils/image_constants.dart';

class AuthPage extends StatefulWidget {
  final bool isLoginForm;

  const AuthPage({Key? key, required this.isLoginForm}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController = TextEditingController();
  String _message = '';
  bool _isLoginForm = true;
  final AuthRepository _repository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _isLoginForm = widget.isLoginForm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white54,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            ImageConstants.login,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 292,
            child: _isLoginForm ? _loginForm() : _registerForm(),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _inputField(
          controller: _usernameController,
          hintText: 'Username',
        ),
        _inputField(
          controller: _passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
        SizedBox(
          height: 55,
          child: Center(
            child: Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        CustomButton(
          onPressed: _login,
          text: 'Log in',
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 33),
            GestureDetector(
              onTap: _switchToRegisterForm,
              child: const Text(
                'Register',
                style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _switchToRegisterForm() {
    setState(() {
      _isLoginForm = false;
      _message = '';
      _usernameController.text = '';
      _passwordController.text = '';
      _passwordCheckController.text = '';
    });
  }

  Widget _registerForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _inputField(
          controller: _usernameController,
          hintText: 'Username',
        ),
        _inputField(
          controller: _passwordController,
          hintText: 'Password',
          obscureText: true,
        ),
        _inputField(
          controller: _passwordCheckController,
          hintText: 'Repeat password',
          obscureText: true,
        ),
        SizedBox(
          height: 55,
          child: Center(
            child: Text(
              _message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
        CustomButton(
          onPressed: _register,
          text: 'Register',
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 33),
            GestureDetector(
              onTap: _switchToLoginForm,
              child: const Text(
                'Log in',
                style: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _switchToLoginForm() {
    setState(() {
      _isLoginForm = true;
      _message = '';
      _usernameController.text = '';
      _passwordController.text = '';
      _passwordCheckController.text = '';
    });
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: SizedBox(
        width: 320,
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white54, fontWeight: FontWeight.normal),
            contentPadding: const EdgeInsets.all(12.0),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final password2 = _passwordCheckController.text;
    if (username.isEmpty || password.isEmpty || password2.isEmpty) {
      setState(() => _message = 'Fill all fields');
      return;
    }
    if (username.length < 6 || username.length > 12) {
      setState(() => _message = 'Username should have length from 6 to 12');
      return;
    }
    if (password.length < 8) {
      setState(() => _message = 'Password should be 8 characters or longer');
      return;
    }
    if (password != password2) {
      setState(() => _message = 'Passwords don\'t match');
      return;
    }
    final response = await _repository.register(username: username, password: password);
    if (response == RegisterResponse.usernameUnavailable) {
      setState(() => _message = 'Username is unavailable, choose another one');
      return;
    } else {
      _navigateToHomePage();
    }
  }

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      setState(() => _message = 'Fill all fields');
      return;
    }
    final response = await _repository.login(username: username, password: password);
    switch (response) {
      case (LoginResponse.usernameNotFound):
        setState(() => _message = 'Username not registered');
        return;
      case (LoginResponse.passwordIsWrong):
        setState(() => _message = 'Password is incorrect');
        return;
      default:
        _navigateToHomePage();
    }
  }

  void _navigateToHomePage() {
    HomeController().currentTab.value = 0;
    final route = MaterialPageRoute(builder: (context) => const HomePage());
    Navigator.pushReplacement(context, route);
  }
}
