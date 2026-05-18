import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bloc/muro_bloc.dart';
import '../domain/models/muro_post_model.dart';
import 'widgets/attachment_preview_grid.dart';
import 'widgets/create_post_modal.dart';

class MuroScreen extends StatelessWidget {
  const MuroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MuroBloc, MuroState>(
      listener: (context, state) {
        if (state is MuroError) {
          _showNotification(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        if (state is MuroLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MuroLoaded) {
          final posts = state.posts;
          if (posts.isEmpty) return _buildEmptyState(context);
          return RefreshIndicator(
            onRefresh: () async => context.read<MuroBloc>().add(LoadMuroPosts()),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) => PostCard(post: posts[index]),
            ),
          );
        } else if (state is MuroError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Iconsax.danger, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                TextButton(
                  onPressed: () => context.read<MuroBloc>().add(LoadMuroPosts()),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  static void _showNotification(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Iconsax.warning_2 : Iconsax.tick_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500))),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.message_notif, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text('No hay novedades aún', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Sé el primero en compartir algo con el equipo.', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// Punto de entrada para mostrar el modal de creación (llamado desde MainLayoutScreen).
  static void showCreatePostModal(BuildContext context) {
    CreatePostModal.show(context);
  }
}

// ─────────────────────────────────────────────────────────────
// POST CARD
// ─────────────────────────────────────────────────────────────
class PostCard extends StatelessWidget {
  final MuroPost post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, theme),
            const SizedBox(height: 12),
            _LinkifiedText(text: post.content, style: theme.textTheme.bodyLarge),
            // Adjuntos (nuevo sistema + legacy)
            AttachmentPreviewGrid(post: post),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            const SizedBox(height: 8),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    final avatarUrl = post.author?.avatarUrl;
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
              ? NetworkImage(avatarUrl) as ImageProvider
              : const AssetImage('assets/images/default_user.png'),
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          radius: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(post.author?.fullName ?? 'Usuario',
                        style: theme.textTheme.labelLarge, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Iconsax.verify5, size: 16, color: Color(0xFF00F2FF)),
                ],
              ),
              Text('${post.author?.role ?? 'Sereno'} • ${post.author?.sector ?? 'Sector 03'}',
                  style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        IconButton(onPressed: () => _showOptions(context), icon: const Icon(Iconsax.more, size: 20)),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _InteractionButton(
          icon: post.isLiked ? Iconsax.heart5 : Iconsax.heart,
          label: post.likesCount.toString(),
          color: post.isLiked ? Colors.red : null,
          onTap: () => context.read<MuroBloc>().add(ToggleLikePost(post: post)),
          onLabelTap: () => _showLikes(context),
        ),
        _InteractionButton(
          icon: Iconsax.message,
          label: post.commentsCount.toString(),
          onTap: () => _showComments(context),
        ),
        _InteractionButton(
          icon: Iconsax.export,
          label: '',
          onTap: () {},
        ),
        _InteractionButton(
          icon: post.isSaved ? Iconsax.archive_tick5 : Iconsax.archive_tick,
          label: '',
          color: post.isSaved ? Colors.amber : null,
          onTap: () => context.read<MuroBloc>().add(ToggleSavePost(post: post)),
        ),
      ],
    );
  }

  void _showOptions(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final isAuthor = currentUser?.id == post.userId;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
            if (isAuthor)
              ListTile(
                leading: const Icon(Iconsax.edit),
                title: const Text('Editar publicación'),
                onTap: () { Navigator.pop(ctx); _showEditDialog(context); },
              ),
            if (isAuthor)
              ListTile(
                leading: const Icon(Iconsax.trash, color: Colors.red),
                title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onTap: () { Navigator.pop(ctx); _showDeleteConfirmation(context); },
              ),
            ListTile(
              leading: const Icon(Iconsax.copy),
              title: const Text('Copiar texto'),
              onTap: () => Navigator.pop(ctx),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Iconsax.danger, color: Colors.red),
          SizedBox(width: 12),
          Text('¿Eliminar post?'),
        ]),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancelar', style: TextStyle(color: Colors.grey[400]))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              context.read<MuroBloc>().add(DeleteMuroPost(postId: post.id));
              Navigator.pop(ctx);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final editCtrl = TextEditingController(text: post.content);
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<MuroBloc>(),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Editar Publicación', style: theme.textTheme.titleLarge),
                    IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Iconsax.close_circle)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(controller: editCtrl, maxLines: 6, autofocus: true),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (editCtrl.text.trim().isNotEmpty) {
                        context.read<MuroBloc>().add(UpdateMuroPost(postId: post.id, content: editCtrl.text.trim()));
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Guardar cambios'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showComments(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<MuroBloc>(),
        child: _CommentsSheet(post: post),
      ),
    );
  }

  void _showLikes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BlocProvider.value(
        value: context.read<MuroBloc>(),
        child: _LikesSheet(post: post),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTÓN DE INTERACCIÓN
// ─────────────────────────────────────────────────────────────
class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLabelTap;
  final Color? color;

  const _InteractionButton({required this.icon, required this.label, required this.onTap, this.onLabelTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onTap,
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: Icon(icon, size: 18, color: color ?? Theme.of(context).textTheme.bodyMedium?.color),
        ),
        if (label.isNotEmpty)
          GestureDetector(
            onTap: onLabelTap ?? onTap,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PANEL DE COMENTARIOS
// ─────────────────────────────────────────────────────────────
class _CommentsSheet extends StatefulWidget {
  final MuroPost post;
  const _CommentsSheet({required this.post});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final _commentController = TextEditingController();
  bool _isSending = false;
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final repo = context.read<MuroBloc>().repository;
    final data = await repo.getComments(widget.post.id);
    if (mounted) setState(() { _comments = data; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Comentarios', style: theme.textTheme.titleLarge),
                Text('${_comments.length}', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Iconsax.message_notif, size: 48, color: Colors.grey[700]),
                        const SizedBox(height: 12),
                        Text('Sin comentarios aún', style: theme.textTheme.bodyMedium),
                      ]))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _comments.length,
                        itemBuilder: (_, i) {
                          final c = _comments[i];
                          final author = c['profiles'] as Map<String, dynamic>?;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: Text(
                                    (author?['full_name'] as String? ?? 'U')[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(author?['full_name'] ?? 'Usuario',
                                            style: theme.textTheme.labelLarge?.copyWith(fontSize: 12, color: const Color(0xFF00F2FF))),
                                        const SizedBox(height: 4),
                                        Text(c['content'] ?? '', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85))),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 12, left: 16, right: 16, top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFF1E293B))),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Escribe un comentario...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Theme.of(context).colorScheme.primary,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: _isSending ? null : () async {
                      if (_commentController.text.trim().isEmpty) return;
                      setState(() => _isSending = true);
                      final repo = context.read<MuroBloc>().repository;
                      final muroBloc = context.read<MuroBloc>();
                      await repo.addComment(widget.post.id, _commentController.text.trim());
                      _commentController.clear();
                      await _load();
                      if (mounted) {
                        muroBloc.add(LoadMuroPosts());
                        setState(() => _isSending = false);
                      }
                    },
                    icon: _isSending
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Iconsax.send_1, color: Colors.white, size: 20),
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

// ─────────────────────────────────────────────────────────────
// PANEL DE LIKES
// ─────────────────────────────────────────────────────────────
class _LikesSheet extends StatelessWidget {
  final MuroPost post;
  const _LikesSheet({required this.post});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MuroBloc>().repository;
    final theme = Theme.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.all(20), child: Text('Reacciones', style: theme.textTheme.titleLarge)),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: repository.getPostLikes(post.id),
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                final likes = snap.data ?? [];
                return ListView.builder(
                  itemCount: likes.length,
                  itemBuilder: (_, i) {
                    final author = likes[i]['profiles'] as Map<String, dynamic>?;
                    return ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.red.withValues(alpha: 0.1), child: const Icon(Iconsax.heart5, color: Colors.red, size: 16)),
                      title: Text(author?['full_name'] ?? 'Usuario', style: theme.textTheme.labelLarge),
                      subtitle: Text(author?['role'] ?? 'Sereno'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TEXTO CON LINKS CLICKEABLES
// ─────────────────────────────────────────────────────────────
class _LinkifiedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const _LinkifiedText({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final urlRegExp = RegExp(r'((https?:\/\/)?([a-z0-9-]+\.)+[a-z]{2,}(\/[^\s]*)?)', caseSensitive: false);
    final theme = Theme.of(context);
    final matches = urlRegExp.allMatches(text);
    if (matches.isEmpty) return Text(text, style: style);

    final spans = <TextSpan>[];
    int lastEnd = 0;
    for (final match in matches) {
      if (match.start > lastEnd) spans.add(TextSpan(text: text.substring(lastEnd, match.start), style: style));
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: style?.copyWith(color: theme.colorScheme.primary, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()..onTap = () async {
          final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) spans.add(TextSpan(text: text.substring(lastEnd), style: style));
    return Text.rich(TextSpan(children: spans, style: style ?? theme.textTheme.bodyLarge));
  }
}
