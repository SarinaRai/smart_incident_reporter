import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:beamer/beamer.dart';
import 'package:smart_incident_reporter/features/auth/viewmodel/auth_viewmodel.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/common_widgets/app_text_field.dart';
import '../../../core/common_widgets/app_button.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authViewModelProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fullName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// ✅ LISTEN SAFELY INSIDE BUILD
    ref.listen<AsyncValue<void>>(authViewModelProvider, (_, next) {
      next.whenOrNull(
        data: (_) => context.beamToNamed('/login'),
        error: (e, _) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString()))),
      );
    });

    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    'assets/smart_incident_reporter.png',
                    height: 200,
                  ),

                  Text(
                    AppStrings.appName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    AppStrings.register,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 32),

                  /// Email
                  AppTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),

                  const SizedBox(height: 16),

                  /// Full Name
                  AppTextField(
                    controller: _nameController,
                    label: AppStrings.name,
                    icon: Icons.person,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter full name' : null,
                  ),

                  const SizedBox(height: 16),

                  /// Phone
                  AppTextField(
                    controller: _phoneController,
                    label: AppStrings.phone,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter phone number' : null,
                  ),

                  const SizedBox(height: 16),

                  /// Password
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
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Confirm Password
                  AppTextField(
                    controller: _confirmPasswordController,
                    label: AppStrings.confirmPassword,
                    icon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Register Button
                  AppButton(
                    text: authState.isLoading
                        ? 'Registering...'
                        : AppStrings.register,
                    onPressed: authState.isLoading ? null : _onRegisterPressed,
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppStrings.alreadyHaveAccount),
                      TextButton(
                        onPressed: () => context.beamToNamed('/login'),
                        child: const Text(AppStrings.login),
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
