import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  final ApiService apiService = ApiService();

  bool isLoading = false;
  bool _titleFocused = false;
  bool _bodyFocused = false;

  late AnimationController _submitAnim;
  late Animation<double> _submitScale;

  // ── Palette (same as PostListScreen) ─────────────────────────────────────
  static const Color _bg = Color(0xFF0F0F14);
  static const Color _surface = Color(0xFF1A1A24);
  static const Color _accent = Color(0xFFE8C97A);
  static const Color _accentDim = Color(0x33E8C97A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textSecondary = Color(0xFF8A8799);
  static const Color _divider = Color(0xFF2C2C3A);
  static const Color _error = Color(0xFFE87A7A);

  @override
  void initState() {
    super.initState();
    _submitAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 1.0,
    );
    _submitScale = CurvedAnimation(parent: _submitAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _submitAnim.dispose();
    super.dispose();
  }

  Future<void> createPost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final Post newPost = await apiService.createPost(
        _titleController.text.trim(),
        _bodyController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pop(context, newPost);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF2A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: _error, width: 1),
          ),
          content: Row(
            children: const [
              Icon(Icons.error_outline_rounded, color: _error, size: 18),
              SizedBox(width: 10),
              Text(
                "Failed to create post",
                style: TextStyle(color: _textPrimary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.dark(
          surface: _surface,
          primary: _accent,
          error: _error,
        ),
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel("Title", Icons.title_rounded),
                        const SizedBox(height: 10),
                        _buildTitleField(),
                        const SizedBox(height: 24),
                        _buildSectionLabel(
                            "Content", Icons.notes_rounded),
                        const SizedBox(height: 10),
                        _buildBodyField(),
                        const SizedBox(height: 12),
                        _buildCharCounter(),
                        const SizedBox(height: 36),
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _divider),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: _textPrimary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "New Post",
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  "Share your thoughts",
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 12,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Draft pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _accentDim,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Draft",
              style: TextStyle(
                color: _accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _accent, size: 15),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Focus(
      onFocusChange: (f) => setState(() => _titleFocused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _titleFocused ? _accent.withOpacity(0.6) : _divider,
            width: 1.2,
          ),
          boxShadow: _titleFocused
              ? [BoxShadow(color: _accentDim, blurRadius: 12)]
              : [],
        ),
        child: TextFormField(
          controller: _titleController,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: _accent,
          decoration: const InputDecoration(
            hintText: "Enter a compelling title…",
            hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
            border: InputBorder.none,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Title is required";
            }
            if (value.trim().length < 3) {
              return "Must be at least 3 characters";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildBodyField() {
    return Focus(
      onFocusChange: (f) => setState(() => _bodyFocused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _bodyFocused ? _accent.withOpacity(0.6) : _divider,
            width: 1.2,
          ),
          boxShadow: _bodyFocused
              ? [BoxShadow(color: _accentDim, blurRadius: 12)]
              : [],
        ),
        child: TextFormField(
          controller: _bodyController,
          maxLines: 8,
          style: const TextStyle(
            color: _textPrimary,
            fontSize: 14,
            height: 1.6,
          ),
          cursorColor: _accent,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: "Write your post content here…",
            hintStyle: TextStyle(color: _textSecondary, fontSize: 14),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Content is required";
            }
            if (value.trim().length < 5) {
              return "Must be at least 5 characters";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildCharCounter() {
    final count = _bodyController.text.length;
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        "$count characters",
        style: TextStyle(
          color: count > 0 ? _accent.withOpacity(0.7) : _textSecondary,
          fontSize: 11,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTapDown: (_) => _submitAnim.animateTo(0.93),
      onTapUp: (_) {
        _submitAnim.animateTo(1.0);
        if (!isLoading) createPost();
      },
      onTapCancel: () => _submitAnim.animateTo(1.0),
      child: ScaleTransition(
        scale: _submitScale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 54,
          decoration: BoxDecoration(
            gradient: isLoading
                ? null
                : const LinearGradient(
              colors: [Color(0xFFE8C97A), Color(0xFFD4A843)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: isLoading ? _surface : null,
            borderRadius: BorderRadius.circular(16),
            border: isLoading
                ? Border.all(color: _divider)
                : null,
            boxShadow: isLoading
                ? []
                : [
              BoxShadow(
                color: _accent.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Center(
            child: isLoading
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _accent,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Publishing…",
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.send_rounded,
                  color: Color(0xFF0F0F14),
                  size: 18,
                ),
                SizedBox(width: 8),
                Text(
                  "Publish Post",
                  style: TextStyle(
                    color: Color(0xFF0F0F14),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}