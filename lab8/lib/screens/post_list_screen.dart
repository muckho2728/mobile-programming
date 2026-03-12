import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_service.dart';
import 'create_post_screen.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen>
    with SingleTickerProviderStateMixin {
  final ApiService apiService = ApiService();

  List<Post> allPosts = [];
  List<Post> filteredPosts = [];

  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimController;
  late Animation<double> _fabScaleAnim;

  bool isLoading = true;
  String? errorMessage;
  bool _isSearchFocused = false;

  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color _bg = Color(0xFF0F0F14);
  static const Color _surface = Color(0xFF1A1A24);
  static const Color _surfaceAlt = Color(0xFF22222F);
  static const Color _accent = Color(0xFFE8C97A); // warm gold
  static const Color _accentDim = Color(0x33E8C97A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textSecondary = Color(0xFF8A8799);
  static const Color _divider = Color(0xFF2C2C3A);

  @override
  void initState() {
    super.initState();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fabScaleAnim = CurvedAnimation(
      parent: _fabAnimController,
      curve: Curves.elasticOut,
    );
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final posts = await apiService.fetchPosts();
      setState(() {
        allPosts = posts;
        filteredPosts = posts;
      });
      _fabAnimController.forward();
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  void filterPosts(String query) {
    setState(() {
      filteredPosts = query.isEmpty
          ? allPosts
          : allPosts
          .where((p) =>
          p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> navigateToCreate() async {
    final newPost = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
    );

    if (newPost != null && newPost is Post) {
      setState(() {
        allPosts.insert(0, newPost);
        filteredPosts = allPosts;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.dark(
          surface: _surface,
          primary: _accent,
        ),
      ),
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(child: _buildBody()),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  Widget _buildFab() {
    return ScaleTransition(
      scale: _fabScaleAnim,
      child: FloatingActionButton(
        backgroundColor: _accent,
        foregroundColor: _bg,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: navigateToCreate,
        child: const Icon(Icons.edit_outlined, size: 22),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) return _buildLoader();
    if (errorMessage != null) return _buildError();
    return _buildContent();
  }

  Widget _buildLoader() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: _accent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Loading posts…",
            style: TextStyle(
              color: _textSecondary,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _accentDim,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.wifi_off_rounded,
                color: _accent,
                size: 34,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: _textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Check your connection and try again.",
              style: TextStyle(color: _textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: _accent,
                foregroundColor: _bg,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: loadPosts,
              child: const Text(
                "Retry",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildSearchBar(),
        _buildResultsLabel(),
        const SizedBox(height: 4),
        Expanded(child: _buildList()),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Posts",
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${allPosts.length} articles",
                  style: const TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentDim,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _accent.withOpacity(0.3)),
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              color: _accent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Focus(
        onFocusChange: (focused) =>
            setState(() => _isSearchFocused = focused),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isSearchFocused
                  ? _accent.withOpacity(0.6)
                  : _divider,
              width: 1.2,
            ),
            boxShadow: _isSearchFocused
                ? [BoxShadow(color: _accentDim, blurRadius: 12)]
                : [],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: filterPosts,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 14,
            ),
            cursorColor: _accent,
            decoration: InputDecoration(
              hintText: "Search posts…",
              hintStyle: const TextStyle(
                color: _textSecondary,
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: _isSearchFocused ? _accent : _textSecondary,
                size: 20,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? GestureDetector(
                onTap: () {
                  _searchController.clear();
                  filterPosts('');
                },
                child: const Icon(
                  Icons.close_rounded,
                  color: _textSecondary,
                  size: 18,
                ),
              )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsLabel() {
    if (_searchController.text.isEmpty) return const SizedBox(height: 12);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      child: Text(
        "${filteredPosts.length} result${filteredPosts.length != 1 ? 's' : ''} for \"${_searchController.text}\"",
        style: const TextStyle(
          color: _textSecondary,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildList() {
    if (filteredPosts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              color: _textSecondary,
              size: 44,
            ),
            const SizedBox(height: 12),
            const Text(
              "No posts found",
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Try a different search term",
              style: TextStyle(color: _textSecondary, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: _accent,
      backgroundColor: _surface,
      onRefresh: loadPosts,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: filteredPosts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 2),
        itemBuilder: (context, index) {
          final post = filteredPosts[index];
          return _PostCard(
            post: post,
            index: index,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PostDetailScreen(post: post),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Post Card ─────────────────────────────────────────────────────────────────
class _PostCard extends StatefulWidget {
  const _PostCard({
    required this.post,
    required this.index,
    required this.onTap,
  });

  final Post post;
  final int index;
  final VoidCallback onTap;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _pressed = false;

  static const Color _surface = Color(0xFF1A1A24);
  static const Color _surfaceAlt = Color(0xFF22222F);
  static const Color _accent = Color(0xFFE8C97A);
  static const Color _accentDim = Color(0x33E8C97A);
  static const Color _textPrimary = Color(0xFFF0EDE6);
  static const Color _textSecondary = Color(0xFF8A8799);

  // Subtle color tags cycling by index
  static const List<Color> _tagColors = [
    Color(0xFF7AB8E8),
    Color(0xFFE87A9C),
    Color(0xFF7AE8C9),
    Color(0xFFE8B87A),
    Color(0xFFB07AE8),
  ];

  @override
  Widget build(BuildContext context) {
    final tagColor = _tagColors[widget.index % _tagColors.length];

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _pressed ? _surfaceAlt : _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _pressed
                  ? tagColor.withOpacity(0.3)
                  : const Color(0xFF2C2C3A),
            ),
          ),
          child: Row(
            children: [
              // Index badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "${widget.index + 1}",
                    style: TextStyle(
                      color: tagColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Post #${widget.post.id}",
                      style: const TextStyle(
                        color: _textSecondary,
                        fontSize: 11,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: _textSecondary.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}