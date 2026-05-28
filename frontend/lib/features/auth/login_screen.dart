import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quentiq/core/theme/app_colors.dart';
import 'package:quentiq/core/theme/theme_extensions.dart';
import 'package:quentiq/core/widgets/app_card.dart';
import 'package:quentiq/core/widgets/gradient_button.dart';
import 'package:quentiq/core/widgets/quentiq_logo.dart';
import 'package:quentiq/routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;
  final _otpControllers = List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() => setState(() {}));
  }

  void _sendOtp() {
    if (_phoneController.text.length < 10) return;
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _loading = false;
          _otpSent = true;
        });
      }
    });
  }

  void _verifyOtp() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              const Center(child: QuentiqLogo(size: 64, compact: true)),
              const SizedBox(height: 40),
              Text(
                _otpSent ? 'Enter OTP' : 'Welcome back',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _otpSent
                    ? 'We sent a 6-digit code to +91 ${_phoneController.text}'
                    : 'Sign in with your mobile number',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              if (!_otpSent) ...[
                Text('Mobile number', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    prefixText: '+91  ',
                    hintText: '98765 43210',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                  ),
                ),
                const SizedBox(height: 28),
                GradientButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward_rounded,
                  isLoading: _loading,
                  onPressed:
                      _phoneController.text.length >= 10 ? _sendOtp : null,
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return SizedBox(
                      width: 48,
                      child: TextField(
                        controller: _otpControllers[i],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: Theme.of(context).textTheme.titleLarge,
                        decoration: const InputDecoration(
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onChanged: (v) {
                          if (v.isNotEmpty && i < 5) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 28),
                GradientButton(
                  label: 'Verify & continue',
                  isLoading: _loading,
                  onPressed: _verifyOtp,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _otpSent = false),
                  child: const Text('Change number'),
                ),
              ],
              const SizedBox(height: 32),
              AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: AppColors.gradientGlow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Secure OTP login. Your data stays private.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.textPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, AppRoutes.managerDashboard),
                child: Text(
                  'Property manager? Sign in here',
                  style: TextStyle(color: context.textMuted, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
