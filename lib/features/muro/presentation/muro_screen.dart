import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:serenazgo_app/features/muro/data/repositories/muro_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'bloc/muro_bloc.dart';
import '../domain/models/muro_post_model.dart';

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
          if (posts.isEmpty) {
            return _buildEmptyState(context);
          }
          return RefreshIndicator(
            onRefresh: () async {
              context.read<MuroBloc>().add(LoadMuroPosts());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              },
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
            Icon(
              isError ? Iconsax.warning_2 : Iconsax.tick_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
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
          Text(
            'No hay novedades aún',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en compartir algo con el equipo.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  static void showCreatePostModal(BuildContext context) {
    final controller = TextEditingController();
    String? selectedImagePath;
    String? selectedFilePath;
    String? selectedFileName;
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
            top: 32,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Nueva Novedad', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24)),
                  IconButton(onPressed: () => Navigator.pop(modalContext), icon: const Icon(Iconsax.close_circle)),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: '¿Qué está pasando en tu sector?',
                ),
              ),
              const SizedBox(height: 16),
              if (selectedImagePath != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(selectedImagePath!), height: 150, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => setModalState(() => selectedImagePath = null),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              if (selectedFilePath != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Iconsax.document_text, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(selectedFileName ?? 'Documento seleccionado', 
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setModalState(() {
                          selectedFilePath = null;
                          selectedFileName = null;
                        }),
                        icon: const Icon(Icons.close, size: 18),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setModalState(() {
                          selectedImagePath = image.path;
                          selectedFilePath = null;
                          selectedFileName = null;
                        });
                      }
                    },
                    icon: const Icon(Iconsax.camera, color: Color(0xFF00F2FF)),
                  ),
                  IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final image = await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setModalState(() {
                          selectedImagePath = image.path;
                          selectedFilePath = null;
                          selectedFileName = null;
                        });
                      }
                    },
                    icon: const Icon(Iconsax.image, color: Color(0xFF00F2FF)),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'jpg', 'jpeg', 'png'],
                      );
                      if (result != null) {
                        final path = result.files.single.path;
                        final name = result.files.single.name;
                        if (path != null) {
                          final extension = name.split('.').last.toLowerCase();
                          if (['jpg', 'jpeg', 'png'].contains(extension)) {
                            setModalState(() {
                              selectedImagePath = path;
                              selectedFilePath = null;
                              selectedFileName = null;
                            });
                          } else {
                            setModalState(() {
                              selectedFilePath = path;
                              selectedFileName = name;
                              selectedImagePath = null;
                            });
                          }
                        }
                      }
                    },
                    icon: const Icon(Iconsax.paperclip, color: Color(0xFF00F2FF)),
                  ),
                  const Spacer(),
                  if (isUploading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () async {
                        if (controller.text.isNotEmpty || selectedImagePath != null || selectedFilePath != null) {
                          setModalState(() => isUploading = true);
                          
                          String? remoteImageUrl;
                          String? remoteFileUrl;

                          final muroBloc = context.read<MuroBloc>();
                          
                          if (selectedImagePath != null) {
                            remoteImageUrl = await muroBloc.repository.uploadFile(selectedImagePath!, '${DateTime.now().millisecondsSinceEpoch}.jpg');
                          }
                          
                          if (selectedFilePath != null) {
                            remoteFileUrl = await muroBloc.repository.uploadFile(selectedFilePath!, selectedFileName!);
                          }
                          
                          if (modalContext.mounted) {
                            context.read<MuroBloc>().add(CreateMuroPost(
                              content: controller.text,
                              imageUrl: remoteImageUrl,
                              fileUrl: remoteFileUrl,
                            ));
                            Navigator.pop(modalContext);
                            MuroScreen._showNotification(context, '¡Tu novedad ha sido compartida!');
                          }
                        }
                      },
                      child: const Text('Publicar'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/default_user.png'),
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
                            child: Text(
                              post.author?.fullName ?? 'Usuario',
                              style: theme.textTheme.labelLarge,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Iconsax.verify5, size: 16, color: Color(0xFF00F2FF)),
                        ],
                      ),
                      Text(
                        '${post.author?.role ?? 'Sereno'} • ${post.author?.sector ?? 'Sector 03'}',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showOptions(context),
                  icon: const Icon(Iconsax.more, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _LinkifiedText(text: post.content, style: theme.textTheme.bodyLarge),
            if (post.imageUrl != null) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(post.imageUrl!, width: double.infinity, fit: BoxFit.cover),
              ),
            ],
            if (post.fileUrl != null) ...[
              const SizedBox(height: 12),
              Material(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                child: ListTile(
                  leading: const Icon(Iconsax.document_text, color: Color(0xFF00F2FF)),
                  title: const Text('Documento Adjunto', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Toca para ver el archivo'),
                  trailing: const Icon(Iconsax.import_1, size: 20),
                  onTap: () async {
                    final urlStr = post.fileUrl!;
                    final uri = Uri.parse(urlStr);
                    try {
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      } else {
                        // Forzado para navegadores externos si falla la detección
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    } catch (e) {
                      debugPrint('Error al abrir archivo: $e');
                    }
                  },
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            const SizedBox(height: 12),
            Row(
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
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final isAuthor = currentUser?.id == post.userId;
    // Consideramos supervisor si el rol en el autor del post es SUPERVISOR 
    // (para esta demo, lo ideal es obtener el rol del usuario actual)
    final isSupervisor = post.author?.role == 'SUPERVISOR';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
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
                onTap: () {
                  Navigator.pop(context);
                  _showEditDialog(context);
                },
              ),
            if (isAuthor || isSupervisor)
              ListTile(
                leading: const Icon(Iconsax.trash, color: Colors.red),
                title: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context);
                },
              ),
            ListTile(
              leading: const Icon(Iconsax.copy),
              title: const Text('Copiar texto'),
              onTap: () => Navigator.pop(context),
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
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Iconsax.danger, color: Colors.red),
            SizedBox(width: 12),
            Text('¿Eliminar post?'),
          ],
        ),
        content: const Text('Esta acción no se puede deshacer. ¿Estás seguro de que quieres eliminar esta publicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey[400])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<MuroBloc>().add(DeleteMuroPost(postId: post.id));
              Navigator.pop(context);
              MuroScreen._showNotification(context, 'Publicación eliminada correctamente');
            },
            child: const Text('Eliminar ahora'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final controller = TextEditingController(text: post.content);
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Editar Publicación', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.close_circle)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                maxLines: 6,
                autofocus: true,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 16),
                decoration: InputDecoration(
                  hintText: '¿Qué quieres cambiar?',
                  hintStyle: TextStyle(color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.3)),
                  filled: true,
                  fillColor: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      context.read<MuroBloc>().add(UpdateMuroPost(
                        postId: post.id,
                        content: controller.text.trim(),
                      ));
                      Navigator.pop(context);
                      MuroScreen._showNotification(context, 'Publicación actualizada');
                    }
                  },
                  child: const Text('Guardar cambios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
            ],
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
      builder: (context) => _CommentsSheet(post: post),
    );
  }

  void _showLikes(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LikesSheet(post: post),
    );
  }
}

class _InteractionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLabelTap;
  final Color? color;

  const _InteractionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.onLabelTap,
    this.color,
  });

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
              child: Text(
                label, 
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}

// --- PANEL DE COMENTARIOS ---
class _CommentsSheet extends StatefulWidget {
  final MuroPost post;
  const _CommentsSheet({required this.post});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSending = false;
  RealtimeChannel? _channel;
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
    _subscribeToComments();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadComments() async {
    final repository = context.read<MuroBloc>().repository;
    final data = await repository.getComments(widget.post.id);
    if (mounted) {
      setState(() {
        _comments = data;
        _isLoading = false;
      });
    }
  }

  void _subscribeToComments() {
    final repository = context.read<MuroBloc>().repository;
    _channel = repository.supabase
        .channel('post_comments_${widget.post.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'muro_comments',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'post_id',
            value: widget.post.id,
          ),
          callback: (payload) => _loadComments(),
        )
        .subscribe();
  }

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MuroBloc>().repository;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 40, spreadRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Comentarios', style: theme.textTheme.titleLarge),
                Text('${_comments.length} comentarios', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _comments.isEmpty
                    ? _buildEmptyState(theme)
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: _comments.length,
                        itemBuilder: (context, index) {
                          final comment = _comments[index];
                          final author = comment['profiles'] as Map<String, dynamic>?;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: Text(
                                    author?['full_name']?[0].toUpperCase() ?? 'U',
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2D3748), // Un gris azulado más vibrante
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              author?['full_name'] ?? 'Usuario',
                                              style: theme.textTheme.labelLarge?.copyWith(
                                                fontSize: 13,
                                                color: const Color(0xFF00F2FF), // Nombre en cian para que resalte
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              comment['content'] ?? '',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                height: 1.3,
                                                color: Colors.white.withValues(alpha: 0.9), // Texto blanco legible
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 12, top: 4),
                                        child: Text(
                                          'Hace un momento', // TODO: Formatear fecha
                                          style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          const Divider(height: 1),
          _buildInputArea(context, repository, theme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.message_notif, size: 64, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text('Aún no hay comentarios', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'Sé el primero en dar tu opinión al equipo.',
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, MuroRepository repository, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: TextField(
                controller: _commentController,
                style: theme.textTheme.bodyMedium,
                decoration: const InputDecoration(
                  hintText: 'Escribe un comentario...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: theme.colorScheme.primary,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: _isSending ? null : () async {
                if (_commentController.text.trim().isEmpty) return;
                setState(() => _isSending = true);
                await repository.addComment(widget.post.id, _commentController.text.trim());
                _commentController.clear();
                if (mounted) {
                  final muroBloc = context.read<MuroBloc>();
                  setState(() => _isSending = false);
                  muroBloc.add(LoadMuroPosts());
                }
              },
              icon: _isSending 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Iconsax.send_1, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// --- PANEL DE LIKES ---
class _LikesSheet extends StatelessWidget {
  final MuroPost post;
  const _LikesSheet({required this.post});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<MuroBloc>().repository;
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('Reacciones', style: theme.textTheme.titleLarge),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: repository.getPostLikes(post.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final likes = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: likes.length,
                  itemBuilder: (context, index) {
                    final like = likes[index];
                    final author = like['profiles'] as Map<String, dynamic>?;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red.withValues(alpha: 0.1),
                        child: const Icon(Iconsax.heart5, color: Colors.red, size: 16),
                      ),
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

class _LinkifiedText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const _LinkifiedText({required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    final urlRegExp = RegExp(
      r'((https?:\/\/)?([a-z0-9-]+\.)+[a-z]{2,}(\/[^\s]*)?)',
      caseSensitive: false,
    );

    final theme = Theme.of(context);
    final matches = urlRegExp.allMatches(text);
    if (matches.isEmpty) return Text(text, style: style);

    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start), style: style));
      }

      final url = match.group(0)!;
      spans.add(
        TextSpan(
          text: url,
          style: style?.copyWith(
            color: theme.colorScheme.primary, 
            decoration: TextDecoration.underline,
            fontWeight: FontWeight.bold,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
        ),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    return Text.rich(
      TextSpan(
        children: spans,
        style: style ?? theme.textTheme.bodyLarge,
      ),
    );
  }
}
