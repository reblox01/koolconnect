import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../services/auth_service.dart';
import '../../models/user_profile.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text);

      // Get user profile to determine role-based navigation
      final userProfile = await AuthService.instance.getCurrentUserProfile();
      if (userProfile != null) {
        _navigateBasedOnRole(userProfile.role);
      } else {
        // Default navigation if profile not found
        Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
      }
    } catch (error) {
      _showErrorSnackBar('Login failed: ${error.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateBasedOnRole(UserRole role) {
    switch (role) {
      case UserRole.manager:
        Navigator.pushReplacementNamed(context, AppRoutes.managerDashboard);
        break;
      case UserRole.teacher:
        Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
        break;
      case UserRole.parent:
        Navigator.pushReplacementNamed(context, AppRoutes.parentDashboard);
        break;
      default:
        Navigator.pushReplacementNamed(context, AppRoutes.teacherDashboard);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              // App Logo and Title
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 10,
                      spreadRadius: 2),
                  ]),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                      child: Icon(
                        Icons.school,
                        color: Colors.white,
                        size: 40)),
                    SizedBox(height: 2.h),
                    Text(
                      'KoolConnect',
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold)),
                    Text(
                      'School Management System',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colors.grey[600])),
                  ])),
              SizedBox(height: 4.h),
              
              // Login Form
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(26),
                      blurRadius: 10,
                      spreadRadius: 2),
                  ]),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                      SizedBox(height: 3.h),
                      
                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        }),
                      SizedBox(height: 2.h),
                      
                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock, color: Theme.of(context).primaryColor),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        }),
                      SizedBox(height: 3.h),
                      
                      // Login Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Sign In',
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))),
                      SizedBox(height: 2.h),
                      
                      // Forgot Password
                      TextButton(
                        onPressed: () => _showForgotPasswordDialog(),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500))),
                    ]))),
              SizedBox(height: 4.h),
              
              // Demo Login Options
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  children: [
                    Text(
                      'Demo Login Options',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700])),
                    SizedBox(height: 1.h),
                    _buildDemoButton('Manager Demo', 'manager@demo.com', 'demo123'),
                    _buildDemoButton('Teacher Demo', 'teacher@demo.com', 'demo123'),
                    _buildDemoButton('Parent Demo', 'parent@demo.com', 'demo123'),
                  ])),
            ]))));
  }

  Widget _buildDemoButton(String title, String email, String password) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: OutlinedButton(
        onPressed: () {
          _emailController.text = email;
          _passwordController.text = password;
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8))),
        child: Text(
          title,
          style: GoogleFonts.inter(fontSize: 12.sp))));
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter your email to receive password reset instructions.'),
            SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder())),
          ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthService.instance.resetPassword(emailController.text.trim());
                Navigator.pop(context);
                _showSuccessSnackBar('Password reset email sent!');
              } catch (error) {
                _showErrorSnackBar('Failed to send reset email');
              }
            },
            child: Text('Send Reset Email')),
        ]));
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating));
  }
}