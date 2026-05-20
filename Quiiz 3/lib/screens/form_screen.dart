import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/submission.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';

class FormScreen extends StatefulWidget {
  final Submission? submissionToEdit;

  const FormScreen({super.key, this.submissionToEdit});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = SupabaseService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String _gender = 'Male';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.submissionToEdit?.fullName);
    _emailController =
        TextEditingController(text: widget.submissionToEdit?.email);
    _phoneController =
        TextEditingController(text: widget.submissionToEdit?.phoneNumber);
    _addressController =
        TextEditingController(text: widget.submissionToEdit?.address);
    if (widget.submissionToEdit != null) {
      _gender = widget.submissionToEdit!.gender;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final submission = Submission(
      id: widget.submissionToEdit?.id,
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      gender: _gender,
    );

    try {
      if (widget.submissionToEdit == null) {
        await _service.insertSubmission(submission);
      } else {
        await _service.updateSubmission(submission);
      }
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/records');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppTheme.errorRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.submissionToEdit == null ? 'Create Profile' : 'Edit Profile',
        ),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Tooltip(
                message: 'View Records',
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/records'),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      FontAwesomeIcons.list,
                      size: 18,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.accentCyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.userPlus,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.submissionToEdit == null
                                ? 'New Registration'
                                : 'Update Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.submissionToEdit == null
                                ? 'Fill in your details below'
                                : 'Update your profile information',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: AppTheme.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Personal Information Section
                _buildSectionTitle('Personal Information'),
                const SizedBox(height: 16),
                _buildField('Full Name', _nameController, FontAwesomeIcons.user,
                    'Enter your full legal name'),
                const SizedBox(height: 16),

                // Contact Information Section
                _buildSectionTitle('Contact Information'),
                const SizedBox(height: 16),
                _buildField('Email Address', _emailController,
                    FontAwesomeIcons.envelope, 'your.email@example.com'),
                const SizedBox(height: 16),
                _buildField('Phone Number', _phoneController,
                    FontAwesomeIcons.phone, '+1 (555) 000-0000'),
                const SizedBox(height: 16),
                _buildField(
                  'Address',
                  _addressController,
                  FontAwesomeIcons.mapPin,
                  'Enter your residential address',
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // Gender Selection
                _buildSectionTitle('Gender'),
                const SizedBox(height: 16),
                _buildGenderPicker(),
                const SizedBox(height: 48),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                widget.submissionToEdit == null
                                    ? FontAwesomeIcons.paperPlane
                                    : FontAwesomeIcons.floppyDisk,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.submissionToEdit == null
                                    ? 'Save Profile'
                                    : 'Update Profile',
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.textMuted,
            letterSpacing: 1.2,
            fontSize: 12,
          ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .labelLarge
              ?.copyWith(color: AppTheme.textDark),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Icon(
                icon,
                size: 16,
                color: AppTheme.textMuted,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? '$label is required' : null,
        ),
      ],
    );
  }

  Widget _buildGenderPicker() {
    final genders = ['Male', 'Female', 'Other'];
    return Column(
      children: [
        Wrap(
          spacing: 10,
          children: genders.map((g) {
            final isSelected = _gender == g;
            return FilterChip(
              label: Text(g),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _gender = g);
              },
              backgroundColor: const Color(0xFFF1F5F9),
              selectedColor: AppTheme.primaryBlue,
              side: BorderSide(
                color: isSelected ? AppTheme.primaryBlue : AppTheme.borderLight,
                width: 1.5,
              ),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
