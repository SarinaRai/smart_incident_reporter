import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';

import 'package:smart_incident_reporter/features/auth/viewmodel/auth_viewmodel.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/common_widgets/app_text_field.dart';
import '../../../core/common_widgets/app_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  late final ProviderSubscription _authListener;

  @override
  void initState() {
    super.initState();
    _authListener = ref.listenManual<AsyncValue<void>>(authViewModelProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (_) {
          context.beamToNamed('/incidents');
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        },
      );
    });
  }

  @override
  void dispose() {
    _authListener.close();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authViewModelProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/smart_incident_reporter.png",
                    height: 200,
                  ),

                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    AppStrings.login,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 32),

                  AppTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _passwordController,
                    label: AppStrings.password,
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    validator: Validators.password,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  AppButton(
                    text: state.isLoading ? "Logging in..." : AppStrings.login,
                    onPressed: state.isLoading ? null : _onLoginPressed,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.dontHaveAccount),
                      TextButton(
                        onPressed: () {
                          context.beamToNamed('/register');
                        },
                        child: const Text(AppStrings.register),
                      ),
                    ],
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
