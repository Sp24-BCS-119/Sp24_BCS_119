// ============================================================
//  CSC303 – Quiz 4 | Supabase Email Auth Flutter App
//  File   : lib/main.dart  (single-file implementation)
//  Author : [Your Name]  |  Roll No: [Your Roll No]
// ============================================================
//
//  pubspec.yaml dependencies to add:
//  dependencies:
//    flutter:
//      sdk: flutter
//    supabase_flutter: ^2.3.4
//
//  SETUP:
//  1. Replace _supabaseUrl and _supabaseAnonKey with your
//     Supabase project credentials.
//  2. In Supabase Dashboard → Authentication → Email:
//       • Disable "Confirm email" for quick testing, OR
//       • Keep enabled and check inbox for confirmation link.
// ============================================================

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Supabase credentials ───────────────────────────────────
const String _supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
const String _supabaseAnonKey = 'YOUR_ANON_KEY';
// ────────────────────────────────────────────────────────────

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
    url: 'https://byqfjiuwtgzoaznwormj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ5cWZqaXV3dGd6b2F6bndvcm1qIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzgxMzgwNDUsImV4cCI6MjA5MzcxNDA0NX0.7ChKomzgPQwuCwhDObV4OZhp8tezKP0LYa1IUGjfsz0',
  );
  runApp(const MyApp());
}

SupabaseClient get supabase => Supabase.instance.client;

// ════════════════════════════════════════════════════════════
//  THEME & CONSTANTS
// ════════════════════════════════════════════════════════════
class AppColors {
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4B44CC);
  static const Color accent = Color(0xFF00D4AA);
  static const Color background = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF252540);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF9090B0);
  static const Color error = Color(0xFFFF5B7A);
  static const Color success = Color(0xFF00D4AA);
}

ThemeData get appTheme => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF3A3A5C), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle:
            const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        hintStyle:
            const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );

// ════════════════════════════════════════════════════════════
//  ROOT APP
// ════════════════════════════════════════════════════════════
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Auth – CSC303',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const _AuthGate(),
    );
  }
}

/// Listens to Supabase auth state and routes accordingly.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }
        final session = snapshot.data?.session;
        if (session != null) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
//  SPLASH SCREEN
// ════════════════════════════════════════════════════════════
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AppLogo(size: 72),
            SizedBox(height: 24),
            CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ════════════════════════════════════════════════════════════

/// Animated gradient logo icon.
class _AppLogo extends StatelessWidget {
  final double size;
  const _AppLogo({this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.lock_rounded,
          color: Colors.white, size: size * 0.5),
    );
  }
}

/// Screen header block.
class _ScreenHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _ScreenHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5)),
        const SizedBox(height: 8),
        Text(subtitle,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 15)),
      ],
    );
  }
}

/// Gradient button.
class _GradientButton extends StatefulWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  const _GradientButton(
      {required this.label, required this.loading, this.onPressed});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.onPressed == null
                  ? [Colors.grey, Colors.grey]
                  : [AppColors.primary, AppColors.accent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: widget.onPressed == null
                ? []
                : [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.45),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          child: Center(
            child: widget.loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Dismissible message banner (error or success).
class _MessageBanner extends StatelessWidget {
  final String message;
  final bool isError;
  const _MessageBanner({required this.message, required this.isError});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: (isError ? AppColors.error : AppColors.success)
            .withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isError ? AppColors.error : AppColors.success)
              .withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? AppColors.error : AppColors.success,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: isError ? AppColors.error : AppColors.success,
                  fontSize: 13.5,
                  height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  VALIDATION HELPERS
// ════════════════════════════════════════════════════════════
class Validators {
  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final re = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w]{2,}$');
    if (!re.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(v))
      return 'Include at least one uppercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Include at least one number';
    return null;
  }

  static String? confirmPassword(String? v, String pass) {
    if (v == null || v.isEmpty) return 'Please confirm your password';
    if (v != pass) return 'Passwords do not match';
    return null;
  }
}

// ════════════════════════════════════════════════════════════
//  REGISTRATION SCREEN
// ════════════════════════════════════════════════════════════
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showPass = false;
  bool _showConfirm = false;
  bool _loading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      final res = await supabase.auth.signUp(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      if (!mounted) return;

      if (res.user != null) {
        setState(() {
          _isError = false;
          _message = res.session == null
              ? '✉️  Confirmation email sent! Please check your inbox and verify your email before logging in.'
              : 'Account created! Redirecting…';
        });
      } else {
        setState(() {
          _isError = true;
          _message = 'Registration failed. Please try again.';
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _isError = true;
        _message = e.message;
      });
    } catch (e) {
      setState(() {
        _isError = true;
        _message = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ──
                const Center(child: _AppLogo(size: 64)),
                const SizedBox(height: 32),
                // ── Header ──
                const _ScreenHeader(
                  title: 'Create Account',
                  subtitle:
                      'Register with your email to get started.',
                ),
                const SizedBox(height: 32),

                // ── Message ──
                if (_message != null) ...[
                  _MessageBanner(
                      message: _message!, isError: _isError),
                  const SizedBox(height: 20),
                ],

                // ── Email ──
                _FieldLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),

                // ── Password ──
                _FieldLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Min 8 chars, 1 uppercase, 1 number',
                    prefixIcon:
                        const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _showPass = !_showPass),
                    ),
                  ),
                  validator: Validators.password,
                ),
                const SizedBox(height: 20),

                // ── Confirm Password ──
                _FieldLabel('Confirm Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: !_showConfirm,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _register(),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Re-enter your password',
                    prefixIcon:
                        const Icon(Icons.lock_person_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_showConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _showConfirm = !_showConfirm),
                    ),
                  ),
                  validator: (v) =>
                      Validators.confirmPassword(v, _passCtrl.text),
                ),
                const SizedBox(height: 32),

                // ── Register Button ──
                _GradientButton(
                  label: 'Create Account',
                  loading: _loading,
                  onPressed: _loading ? null : _register,
                ),
                const SizedBox(height: 28),

                // ── Login Link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?',
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Log In',
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  LOGIN SCREEN
// ════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _showPass = false;
  bool _loading = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _message = null;
    });

    try {
      await supabase.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );
      // AuthGate's stream will automatically navigate to HomeScreen
    } on AuthException catch (e) {
      setState(() {
        _isError = true;
        _message = e.message;
      });
    } catch (_) {
      setState(() {
        _isError = true;
        _message = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ──
                const Center(child: _AppLogo(size: 64)),
                const SizedBox(height: 32),
                // ── Header ──
                const _ScreenHeader(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to continue to your account.',
                ),
                const SizedBox(height: 32),

                // ── Message ──
                if (_message != null) ...[
                  _MessageBanner(
                      message: _message!, isError: _isError),
                  const SizedBox(height: 20),
                ],

                // ── Email ──
                _FieldLabel('Email Address'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'you@example.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),

                // ── Password ──
                _FieldLabel('Password'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_showPass,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _login(),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon:
                        const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      icon: Icon(_showPass
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                      onPressed: () =>
                          setState(() => _showPass = !_showPass),
                    ),
                  ),
                  validator: (v) => v == null || v.isEmpty
                      ? 'Password is required'
                      : null,
                ),
                const SizedBox(height: 32),

                // ── Login Button ──
                _GradientButton(
                  label: 'Sign In',
                  loading: _loading,
                  onPressed: _loading ? null : _login,
                ),
                const SizedBox(height: 28),

                // ── Register Link ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?",
                        style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14)),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegistrationScreen()),
                      ),
                      child: const Text('Register',
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  HOME SCREEN
// ════════════════════════════════════════════════════════════
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    await supabase.auth.signOut();
    // AuthGate stream redirects to LoginScreen automatically
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final email = user?.email ?? 'N/A';
    final userId = user?.id ?? 'N/A';
    final createdAt = user?.createdAt != null
        ? _formatDate(DateTime.parse(user!.createdAt))
        : 'N/A';
    final provider =
        user?.appMetadata['provider']?.toString().toUpperCase() ?? 'EMAIL';
    final emailConfirmed = user?.emailConfirmedAt != null;
    final lastSignIn = user?.lastSignInAt != null
        ? _formatDate(DateTime.parse(user!.lastSignInAt!))
        : 'N/A';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top Row ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dashboard',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700)),
                  IconButton(
                    onPressed: () => _signOut(context),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout_rounded,
                        color: AppColors.error, size: 22),
                    tooltip: 'Sign Out',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Avatar Card ──
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          email.isNotEmpty
                              ? email[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      email,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            emailConfirmed
                                ? Icons.verified_rounded
                                : Icons.pending_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            emailConfirmed
                                ? 'Email Verified'
                                : 'Pending Verification',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Info Cards ──
              const _SectionLabel('Account Details'),
              const SizedBox(height: 12),
              _InfoCard(items: [
                _InfoItem(
                    icon: Icons.fingerprint_rounded,
                    label: 'User ID',
                    value: userId,
                    mono: true),
              ]),
              const SizedBox(height: 12),
              _InfoCard(items: [
                _InfoItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Registered On',
                    value: createdAt),
                _Divider(),
                _InfoItem(
                    icon: Icons.access_time_rounded,
                    label: 'Last Sign In',
                    value: lastSignIn),
              ]),
              const SizedBox(height: 12),
              _InfoCard(items: [
                _InfoItem(
                    icon: Icons.vpn_key_rounded,
                    label: 'Auth Provider',
                    value: provider),
                _Divider(),
                _InfoItem(
                    icon: Icons.mail_outline_rounded,
                    label: 'Email Status',
                    value: emailConfirmed ? 'Confirmed ✓' : 'Not Confirmed',
                    valueColor: emailConfirmed
                        ? AppColors.success
                        : AppColors.error),
              ]),
              const SizedBox(height: 32),

              // ── Sign Out Button ──
              OutlinedButton.icon(
                onPressed: () => _signOut(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text('Sign Out',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ────────────────────────────────────────────────────────────
//  Home Screen sub-widgets
// ────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2),
      );
}

class _InfoCard extends StatelessWidget {
  final List<Widget> items;
  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A45)),
      ),
      child: Column(children: items),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool mono;
  final Color? valueColor;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.mono = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor ?? AppColors.textPrimary,
                    fontSize: mono ? 11.5 : 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: mono ? 'monospace' : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 56,
      endIndent: 0,
      color: Color(0xFF2A2A45),
    );
  }
}

// ────────────────────────────────────────────────────────────
//  Shared helper
// ────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w500),
    );
  }
}