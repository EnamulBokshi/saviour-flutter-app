import 'package:flutter/material.dart';
import 'signin_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/auth_service.dart';
import '../services/api_exceptions.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _hidePassword = true;
  bool _agreedToTerms = false;
  bool _loading = false;
  bool _isDonor = false;

  // Remove country field
  String? _selectedBloodGroup;

  // Remove countries list
  final _ageCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  DateTime? _lastDonationDate;

  final List<Map<String, String>> _bloodGroups = [
    {'label': 'A+', 'enum': 'A_POSITIVE'},
    {'label': 'A−', 'enum': 'A_NEGATIVE'},
    {'label': 'B+', 'enum': 'B_POSITIVE'},
    {'label': 'B−', 'enum': 'B_NEGATIVE'},
    {'label': 'AB+', 'enum': 'AB_POSITIVE'},
    {'label': 'AB−', 'enum': 'AB_NEGATIVE'},
    {'label': 'O+', 'enum': 'O_POSITIVE'},
    {'label': 'O−', 'enum': 'O_NEGATIVE'},
  ];

  // ── Google Sign-In ──────────────────────────────────────────────────────────
  // To enable real Google Sign-In:
  // 1. Add to pubspec.yaml:
  //      google_sign_in: ^6.2.1
  // 2. Follow setup: https://pub.dev/packages/google_sign_in
  //    (add google-services.json for Android, GoogleService-Info.plist for iOS)
  // 3. Import and replace _signUpWithGoogle() below:
  //
  // import 'package:google_sign_in/google_sign_in.dart';
  // final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  //
  // Future<void> _signUpWithGoogle() async {
  //   try {
  //     final account = await _googleSignIn.signIn();
  //     if (account == null) return;
  //     // Use account.email, account.displayName with your backend
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  //   }
  // }

  // ── Facebook Login ──────────────────────────────────────────────────────────
  // To enable real Facebook Login:
  // 1. Add to pubspec.yaml:
  //      flutter_facebook_auth: ^7.0.1
  // 2. Follow setup: https://pub.dev/packages/flutter_facebook_auth
  //    (register on developers.facebook.com, add App ID to manifests)
  // 3. Import and replace _signUpWithFacebook() below:
  //
  // import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
  //
  // Future<void> _signUpWithFacebook() async {
  //   final result = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
  //   if (result.status == LoginStatus.success) {
  //     final data = await FacebookAuth.instance.getUserData();
  //     // Use data['email'], data['name'] with your backend
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${result.message}')));
  //   }
  // }

  void _signUpWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add google_sign_in package & follow setup to enable'),
        backgroundColor: Color(0xFFEA4335),
      ),
    );
  }

  void _signUpWithFacebook() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Add flutter_facebook_auth package & follow setup to enable',
        ),
        backgroundColor: Color(0xFF1877F2),
      ),
    );
  }

  XFile? _pickedImage;
  final AuthService _authService = AuthService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = picked);
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms & conditions')),
      );
      return;
    }
    if (_isDonor) {
      if ((_selectedBloodGroup == null || _selectedBloodGroup!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blood group is required for donors')),
        );
        return;
      }
      if (_phoneCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contact number is required for donors'),
          ),
        );
        return;
      }
      if (_ageCtrl.text.trim().isEmpty ||
          int.tryParse(_ageCtrl.text.trim()) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Age is required for donors')),
        );
        return;
      }
      if (_addressCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address is required for donors')),
        );
        return;
      }
      if (_lastDonationDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Last donation date is required for donors'),
          ),
        );
        return;
      }
    }
    setState(() => _loading = true);
    try {
      final Map<String, dynamic> data = {
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'password': _passwordCtrl.text,
        if (_isDonor) 'role': 'DONOR',
      };
      if (_isDonor) {
        final selectedEnum = _bloodGroups.firstWhere(
          (bg) => bg['label'] == _selectedBloodGroup,
        )['enum'];
        data['donorProfile'] = {
          'fullName': _nameCtrl.text.trim(),
          'age': int.parse(_ageCtrl.text.trim()),
          'bloodGroup': selectedEnum,
          'contactNumber': _phoneCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'lastDonationDate': _lastDonationDate!.toIso8601String(),
        };
      }
      await _authService.signUp(data: data, imagePath: _pickedImage?.path);
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isDonor
                ? 'Registered as Donor successfully!'
                : 'Account created successfully!',
          ),
          backgroundColor: const Color(0xFFE8304A),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                const Text(
                  'Sign Up Your Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create an account to find or become\na blood donor in your area',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade500,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Donor Toggle ─────────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _isDonor
                        ? const Color(0xFFFFECEE)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isDonor
                          ? const Color(0xFFE8304A).withOpacity(0.35)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: _isDonor
                            ? const Color(0xFFE8304A)
                            : Colors.grey.shade400,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register as a Donor',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _isDonor
                                    ? const Color(0xFFE8304A)
                                    : Colors.black87,
                              ),
                            ),
                            Text(
                              'Help save lives by donating blood',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isDonor,
                        onChanged: (v) => setState(() => _isDonor = v),
                        activeColor: const Color(0xFFE8304A),
                        activeTrackColor: const Color(
                          0xFFE8304A,
                        ).withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // ── Full Name ────────────────────────────────────────────────
                _label('Full Name'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _nameCtrl,
                  hint: 'e.g. David John',
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your full name' : null,
                ),
                const SizedBox(height: 16),

                // ── Email ────────────────────────────────────────────────────
                _label('Email Address'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailCtrl,
                  hint: 'e.g. david@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    final value = v?.trim() ?? '';
                    if (value.isEmpty) return 'Enter your email';
                    final emailRegex = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}",
                    );
                    if (!emailRegex.hasMatch(value))
                      return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Password ─────────────────────────────────────────────────
                _label('Password'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _passwordCtrl,
                  hint: 'Min. 6 characters',
                  obscureText: _hidePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Enter a password';
                    if (v.length < 6) return 'Minimum 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ── Age (Donor only) ─────────────────────────────────────────
                if (_isDonor) ...[
                  _label('Age'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _ageCtrl,
                    hint: 'e.g. 28',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (_isDonor &&
                          (v == null || v.isEmpty || int.tryParse(v) == null)) {
                        return 'Enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                // ── Phone ────────────────────────────────────────────────────
                _label('Phone Number'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _phoneCtrl,
                  hint: 'e.g. +8801700000000',
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (_isDonor) {
                      if (v == null || v.isEmpty)
                        return 'Contact number is required for donors';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // ── Blood Group ──────────────────────────────────────────────
                _label(_isDonor ? 'Blood Group *' : 'Blood Group'),
                const SizedBox(height: 6),
                _buildBloodGroupDropdown(),
                const SizedBox(height: 16),
                // ── Address (Donor only) ─────────────────────────────────────
                if (_isDonor) ...[
                  _label('Address'),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: _addressCtrl,
                    hint: 'e.g. Dhaka',
                    validator: (v) {
                      if (_isDonor && (v == null || v.isEmpty)) {
                        return 'Enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                // ── Last Donation Date (Donor only) ─────────────────────────
                if (_isDonor) ...[
                  _label('Last Donation Date'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null)
                        setState(() => _lastDonationDate = picked);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _lastDonationDate == null
                            ? 'Select date'
                            : '${_lastDonationDate!.year}-${_lastDonationDate!.month.toString().padLeft(2, '0')}-${_lastDonationDate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: _lastDonationDate == null
                              ? Colors.grey.shade500
                              : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Terms ────────────────────────────────────────────────────
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _agreedToTerms,
                        onChanged: (v) =>
                            setState(() => _agreedToTerms = v ?? false),
                        activeColor: const Color(0xFFE8304A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'I agree to the ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'terms & conditions',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE8304A),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFFE8304A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Profile Image Picker (optional) ──────────────────────────
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
                            : null,
                        child: _pickedImage == null
                            ? const Icon(
                                Icons.camera_alt,
                                color: Color(0xFFE8304A),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _pickedImage == null
                          ? 'Add profile image (optional)'
                          : 'Image selected',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // ── Sign Up Button ───────────────────────────────────────────
                _buildPrimaryButton(
                  label: 'Sign Up',
                  onTap: _signUp,
                  loading: _loading,
                ),
                const SizedBox(height: 22),

                // ── Divider ──────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: Colors.grey.shade300, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Social Buttons ───────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _socialButton(
                        label: 'Google',
                        icon: 'G',
                        color: const Color(0xFFEA4335),
                        onTap: _signUpWithGoogle,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _socialButton(
                        label: 'Facebook',
                        icon: 'f',
                        color: const Color(0xFF1877F2),
                        onTap: _signUpWithFacebook,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Sign In Link ─────────────────────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already Have An Account? ',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Color(0xFFE8304A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Reusable Widgets ───────────────────────────────────────────────────────

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade100,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE8304A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildBloodGroupDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedBloodGroup,
      hint: Text(
        'Select blood group',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
      ),
      onChanged: (v) => setState(() => _selectedBloodGroup = v),
      validator: _isDonor
          ? (v) => v == null ? 'Blood group is required for donors' : null
          : null,
      items: _bloodGroups.map((bg) {
        return DropdownMenuItem<String>(
          value: bg['label'],
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFECEE),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    bg['label']!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE8304A),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                bg['label']!,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE8304A), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
      dropdownColor: Colors.white,
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
    bool loading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE8304A),
          disabledBackgroundColor: const Color(0xFFE8304A).withOpacity(0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icon,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
