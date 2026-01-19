import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final Function() onTogglePasswordVisibility;
  final Function() onSubmit;

  const LoginForm({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration(
              hint: "example@email.com",
              icon: Icons.email,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              if (!value.contains("@")) {
                return "Invalid email format";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          const Text(
            "Password",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: _inputDecoration(
              hint: "********",
              icon: Icons.lock,
              suffix: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: onTogglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }
              if (value.length < 6) {
                return "Password must be at least 6 characters";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}