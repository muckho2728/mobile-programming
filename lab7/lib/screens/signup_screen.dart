import 'package:flutter/material.dart';
import '../validators/form_validators.dart';
import '../services/auth_service.dart';
import '../widgets/loading_button.dart';
import '../widgets/custom_text_field.dart';
import '../utils/focus_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _isLoading = false;
  bool _acceptedTerms = false;
  String _passwordStrength = "";

  List<User> _registeredUsers = [];

  // ================= INIT =================

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _passwordController.addListener(() {
      _checkPasswordStrength(_passwordController.text);
    });
  }

  Future<void> _loadUsers() async {
    final users = await FakeAuthService.getUsers();
    setState(() {
      _registeredUsers = users;
    });
  }

  // ================= PASSWORD STRENGTH =================

  void _checkPasswordStrength(String password) {
    if (password.length < 8) {
      _passwordStrength = "Weak";
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      _passwordStrength = "Medium";
    } else {
      _passwordStrength = "Strong";
    }
    setState(() {});
  }

  Color _strengthColor() {
    switch (_passwordStrength) {
      case "Weak":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Strong":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // ================= SUBMIT =================

  Future<void> _submit() async {
    FocusHelper.dismissKeyboard(context);

    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please accept Terms & Conditions"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final newUser = await FakeAuthService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (newUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This email is already registered"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await _loadUsers();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Signup successful!"),
        backgroundColor: Colors.green,
      ),
    );

    _formKey.currentState!.reset();

    setState(() {
      _acceptedTerms = false;
      _passwordStrength = "";
    });
  }

  // ================= DELETE =================

  Future<void> _deleteUser(String email) async {
    await FakeAuthService.deleteUser(email);
    await _loadUsers();
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();

    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return FocusHelper.dismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                // ================= FORM CARD =================

                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          const Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Center(
                            child: Text(
                              "Fill in the details below to register",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          CustomTextField(
                            controller: _nameController,
                            label: "Full Name",
                            focusNode: _nameFocus,
                            nextFocusNode: _emailFocus,
                            validator:
                            FormValidators.validateName,
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _emailController,
                            label: "Email",
                            focusNode: _emailFocus,
                            nextFocusNode: _passwordFocus,
                            validator:
                            FormValidators.validateEmail,
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _passwordController,
                            label: "Password",
                            focusNode: _passwordFocus,
                            nextFocusNode: _confirmFocus,
                            obscureText: true,
                            enableToggleObscure: true,
                            validator:
                            FormValidators.validatePassword,
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "At least 8 characters and 1 number",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey),
                          ),

                          const SizedBox(height: 6),

                          if (_passwordController.text
                              .isNotEmpty)
                            Text(
                              "Strength: $_passwordStrength",
                              style: TextStyle(
                                color: _strengthColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            controller: _confirmController,
                            label: "Confirm Password",
                            focusNode: _confirmFocus,
                            textInputAction:
                            TextInputAction.done,
                            obscureText: true,
                            enableToggleObscure: true,
                            validator: (value) =>
                                FormValidators
                                    .validateConfirmPassword(
                                  value,
                                  _passwordController.text,
                                ),
                            onEditingComplete: _submit,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Checkbox(
                                value: _acceptedTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptedTerms =
                                        value ?? false;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "I agree to the Terms & Conditions",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: LoadingButton(
                              isLoading: _isLoading,
                              onPressed: _submit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ================= REGISTERED USERS =================

                if (_registeredUsers.isNotEmpty) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Registered Accounts",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    itemCount: _registeredUsers.length,
                    itemBuilder: (context, index) {
                      final user =
                      _registeredUsers[index];

                      return Card(
                        child: ListTile(
                          leading:
                          const Icon(Icons.person),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                _deleteUser(user.email),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}