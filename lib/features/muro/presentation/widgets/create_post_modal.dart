import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/attachment_model.dart';
import '../bloc/muro_bloc.dart';

/// Modal de creación de publicación con soporte de múltiples adjuntos.
class CreatePostModal extends StatefulWidget {
  const CreatePostModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (ctx) => BlocProvider.value(
        value: context.read<MuroBloc>(),
        child: const CreatePostModal(),
      ),
    );
  }

  @override
  State<CreatePostModal> createState() => _CreatePostModalState();
}

class _CreatePostModalState extends State<CreatePostModal>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _linkController = TextEditingController();
  final _scrollController = ScrollController();
  final List<PendingAttachment> _attachments = [];
  bool _isPublishing = false;
  bool _showLinkInput = false;
  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _linkController.dispose();
    _scrollController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  bool get _canPublish =>
      _controller.text.trim().isNotEmpty ||
      _attachments.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border(
            top: BorderSide(color: const Color(0xFF1E293B), width: 1),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildHeader(context, theme),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Flexible(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: bottomPadding + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextArea(theme),
                    if (_showLinkInput) _buildLinkInput(theme),
                    if (_attachments.isNotEmpty) _buildAttachmentPreview(theme),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            _buildToolbar(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
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
                Text('Nueva Novedad',
                    style: theme.textTheme.labelLarge?.copyWith(fontSize: 16)),
                Text('Comparte algo con el equipo',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
              ],
            ),
          ),
          // Botón publicar en el header
          AnimatedOpacity(
            opacity: _canPublish ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: _isPublishing
                ? const SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : ElevatedButton(
                    onPressed: _canPublish ? _publish : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Publicar', style: TextStyle(fontSize: 14)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextArea(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: TextField(
        controller: _controller,
        maxLines: null,
        minLines: 3,
        autofocus: true,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: '¿Qué está pasando en tu sector?',
          hintStyle: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildLinkInput(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 14),
              child: Icon(Iconsax.link_1, color: Color(0xFF00F2FF), size: 18),
            ),
            Expanded(
              child: TextField(
                controller: _linkController,
                keyboardType: TextInputType.url,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Pega un enlace aquí...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.check_rounded, color: Color(0xFF00F2FF), size: 20),
              onPressed: _addLink,
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.grey, size: 18),
              onPressed: () => setState(() => _showLinkInput = false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentPreview(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Adjuntos (${_attachments.length})',
              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _attachments.asMap().entries.map((entry) {
              final index = entry.key;
              final att = entry.value;
              return _AttachmentChip(
                attachment: att,
                onRemove: () => setState(() => _attachments.removeAt(index)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context, ThemeData theme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            _ToolbarButton(
              icon: Iconsax.camera,
              label: 'Cámara',
              color: const Color(0xFF00F2FF),
              onTap: _pickFromCamera,
            ),
            _ToolbarButton(
              icon: Iconsax.image,
              label: 'Galería',
              color: Colors.purple.shade300,
              onTap: _pickFromGallery,
            ),
            _ToolbarButton(
              icon: Iconsax.video,
              label: 'Video',
              color: Colors.orange.shade400,
              onTap: _pickVideo,
            ),
            _ToolbarButton(
              icon: Iconsax.paperclip,
              label: 'Archivo',
              color: Colors.green.shade400,
              onTap: _pickDocument,
            ),
            _ToolbarButton(
              icon: Iconsax.link_1,
              label: 'Enlace',
              color: Colors.blue.shade400,
              onTap: () => setState(() => _showLinkInput = !_showLinkInput),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Acciones ───────────────────────────────────────────────

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (image != null) _addFileAttachment(image.path, image.name);
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 85);
    for (final img in images) {
      _addFileAttachment(img.path, img.name);
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) _addFileAttachment(video.path, video.name);
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'],
      allowMultiple: true,
    );
    if (result != null) {
      for (final file in result.files) {
        if (file.path != null) {
          _addFileAttachment(file.path!, file.name);
        }
      }
    }
  }

  void _addFileAttachment(String path, String name) {
    final fileType = PendingAttachment.detectType(name);
    final mimeType = PendingAttachment.detectMimeType(name);
    int? fileSize;
    try {
      fileSize = File(path).lengthSync();
    } catch (_) {}

    // Validar tamaño
    if (fileSize != null && fileSize > 52428800) {
      _showError('El archivo "$name" supera el límite de 50MB');
      return;
    }

    setState(() {
      _attachments.add(PendingAttachment(
        localPath: path,
        fileName: name,
        fileType: fileType,
        mimeType: mimeType,
        fileSize: fileSize,
      ));
    });
  }

  void _addLink() {
    final url = _linkController.text.trim();
    if (url.isEmpty) return;

    final normalized = url.startsWith('http') ? url : 'https://$url';
    setState(() {
      _attachments.add(PendingAttachment(
        localPath: normalized,
        fileName: url,
        fileType: AttachmentType.link,
      ));
      _linkController.clear();
      _showLinkInput = false;
    });
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _publish() async {
    if (!_canPublish || _isPublishing) return;
    setState(() => _isPublishing = true);

    try {
      // Subir archivos locales primero
      final muroBloc = context.read<MuroBloc>();
      for (final att in _attachments) {
        if (att.fileType != AttachmentType.link) {
          att.isUploading = true;
          final url = await muroBloc.repository.uploadFileToStorage(
            att.localPath,
            att.fileName,
            subfolder: att.fileType.name,
          );
          att.remoteUrl = url;
          att.isUploaded = true;
          att.isUploading = false;
          if (mounted) setState(() {});
        }
      }

      if (!mounted) return;
      muroBloc.add(CreateMuroPost(
        content: _controller.text.trim(),
        attachments: _attachments,
      ));
      Navigator.pop(context);
    } catch (e) {
      setState(() => _isPublishing = false);
      _showError('Error al publicar: ${e.toString()}');
    }
  }
}

// ─────────────────────────────────────────────────────────────
// CHIP DE ADJUNTO EN EL MODAL
// ─────────────────────────────────────────────────────────────
class _AttachmentChip extends StatelessWidget {
  final PendingAttachment attachment;
  final VoidCallback onRemove;
  const _AttachmentChip({required this.attachment, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final isImage = attachment.fileType == AttachmentType.image;
    final isVideo = attachment.fileType == AttachmentType.video;
    final isLink = attachment.fileType == AttachmentType.link;

    if (isImage) {
      return _ImageChip(attachment: attachment, onRemove: onRemove);
    }

    final color = isVideo
        ? Colors.orange.shade400
        : isLink
            ? Colors.blue.shade400
            : Colors.green.shade400;
    final icon = isVideo
        ? Iconsax.video
        : isLink
            ? Iconsax.link_1
            : Iconsax.document_text;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 120),
                child: Text(
                  attachment.fileName,
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (attachment.formattedSize.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(attachment.formattedSize,
                    style: TextStyle(color: color.withValues(alpha: 0.6), fontSize: 10)),
              ],
            ],
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageChip extends StatelessWidget {
  final PendingAttachment attachment;
  final VoidCallback onRemove;
  const _ImageChip({required this.attachment, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(attachment.localPath),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Icon(Icons.close, color: Colors.white, size: 12),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// BOTÓN DE TOOLBAR
// ─────────────────────────────────────────────────────────────
class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
