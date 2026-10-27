import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/responsive_body.dart';
import 'home_screen.dart';

/// Halaman 2 - Login Statis: hanya desain UI, tanpa autentikasi.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login statis: tombol langsung membuka Beranda tanpa validasi.
  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned(top: -80, right: -60, child: _Blob(size: 220)),
          const Positioned(bottom: -110, left: -80, child: _Blob(size: 280)),
          SafeArea(
            child: ResponsiveBody(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: AppLogo(size: 84)),
                      const SizedBox(height: 16),
                      const Text(
                        'CatatanKu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Masuk untuk melanjutkan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: AppColors.muted),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: AppTheme.inputDecoration(
                          hint: 'Email',
                          prefixIcon: const Icon(Icons.mail_outline_rounded,
                              color: AppColors.muted),
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        decoration: AppTheme.inputDecoration(
                          hint: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppColors.muted),
                          suffixIcon: IconButton(
                            tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: AppColors.muted,
                            ),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      FilledButton(onPressed: _goHome, child: const Text('Masuk')),
                      const SizedBox(height: 18),
                      const Row(
                        children: [
                          Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text('atau',
                                style: TextStyle(color: AppColors.muted)),
                          ),
                          Expanded(child: Divider(color: AppColors.border)),
                        ],
                      ),
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
                        onPressed: _goHome,
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEA4335),
                          ),
                        ),
                        label: const Text('Masuk dengan Google'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Lingkaran dekoratif lembut di latar belakang.
class _Blob extends StatelessWidget {
  const _Blob({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.08),
      ),
    );
  }
}
