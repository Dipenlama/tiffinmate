import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiffinmate/features/auth/presentation/pages/login_screen.dart';
import 'package:tiffinmate/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:tiffinmate/features/auth/presentation/state/auth_state.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authViewModelProvider.notifier).register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.status == AuthStatus.registered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful. Please login."),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset("assets/images/Rectangle.png", height: 180),
                  const SizedBox(height: 20),

                  const Text(
                    "Create Your Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v!.trim().isEmpty ? "Please enter your full name" : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v!.trim().isEmpty) return "Email is required";
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v!.trim().isEmpty ? "Password is required" : null,
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) {
                      if (v!.trim().isEmpty) return "Confirm your password";
                      if (v != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: authState.status == AuthStatus.loading
                          ? null
                          : _handleSignup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        authState.status == AuthStatus.loading
                            ? "Signing up..."
                            : "Sign Up",
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
