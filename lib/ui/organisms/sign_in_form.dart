import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';
import '../../models/app_user.dart';
import '../atoms/app_button.dart';
import '../atoms/app_text_field.dart';
import '../molecules/role_selector.dart';

/// Email and password form. When [isRegister] is true it also asks for the
/// role (Student or Admin).
class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
    required this.isRegister,
    required this.onSubmit,
    required this.onToggleMode,
    this.isSaving = false,
  });

  final bool isRegister;
  final void Function(String email, String password, UserRole role) onSubmit;
  final VoidCallback onToggleMode;
  final bool isSaving;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  UserRole _role = UserRole.student;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(_email.text.trim(), _password.text, _role);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _email,
            label: 'Email',
            icon: Icons.email_outlined,
            validator: Validators.email,
            textCapitalization: TextCapitalization.none,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: _password,
            label: 'Password',
            icon: Icons.lock_outline,
            validator: Validators.password,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            obscureText: true,
          ),
          if (widget.isRegister) ...[
            const SizedBox(height: 20),
            Text('I am a', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            RoleSelector(
              selected: _role,
              onChanged: (role) => setState(() => _role = role),
            ),
          ],
          const SizedBox(height: 28),
          AppButton(
            label: widget.isRegister ? 'Create account' : 'Sign in',
            icon: Icons.check,
            isLoading: widget.isSaving,
            onPressed: _submit,
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: widget.isSaving ? null : widget.onToggleMode,
              child: Text(widget.isRegister
                  ? 'Already have an account? Sign in'
                  : 'No account yet? Create one'),
            ),
          ),
        ],
      ),
    );
  }
}
