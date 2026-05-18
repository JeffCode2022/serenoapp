import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/models/attachment_model.dart';
import '../../domain/models/muro_post_model.dart';

/// Grid de adjuntos que se muestra en cada PostCard del muro.
class AttachmentPreviewGrid extends StatelessWidget {
  final MuroPost post;

  const AttachmentPreviewGrid({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final attachments = post.attachments;

    // --- Legacy support: imageUrl y fileUrl de posts anteriores ---
    if (attachments.isEmpty) {
      return _LegacyAttachments(post: post);
    }

    final images = post.images;
    final videos = post.videos;
    final docs = post.documents;
    final links = post.links;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imágenes en grid adaptativo
        if (images.isNotEmpty) ...[
          const SizedBox(height: 12),
          _ImageGrid(images: images),
        ],
        // Videos con thumbnail + play
        if (videos.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...videos.map((v) => _VideoThumbnail(attachment: v)),
        ],
        // Documentos con ícono por tipo
        if (docs.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...docs.map((d) => _DocumentCard(attachment: d)),
        ],
        // Previews de enlaces
        if (links.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...links.map((l) => _LinkPreviewCard(attachment: l)),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GRID DE IMÁGENES
// ─────────────────────────────────────────────────────────────
class _ImageGrid extends StatelessWidget {
  final List<Attachment> images;

  const _ImageGrid({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return _buildSingleImage(context, images[0]);
    }
    if (images.length == 2) {
      return Row(
        children: images.map((img) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: img == images.first ? 4 : 0),
            child: _buildImageTile(context, img, height: 160),
          ),
        )).toList(),
      );
    }
    // 3+ imágenes: 1 grande arriba + fila abajo
    return Column(
      children: [
        _buildSingleImage(context, images[0], height: 180),
        const SizedBox(height: 4),
        Row(
          children: images.skip(1).take(images.length > 4 ? 2 : images.length - 1).map((img) {
            final isLast = images.indexOf(img) == (images.length > 4 ? 3 : images.length - 1);
            final remaining = images.length - 4;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Stack(
                  children: [
                    _buildImageTile(context, img, height: 100),
                    if (isLast && remaining > 0)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            color: Colors.black54,
                            alignment: Alignment.center,
                            child: Text(
                              '+$remaining',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSingleImage(BuildContext context, Attachment img, {double? height}) {
    return GestureDetector(
      onTap: () => _openFullscreen(context, img),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          img.fileUrl,
          width: double.infinity,
          height: height ?? 220,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _imagePlaceholder(height ?? 220),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              height: height ?? 220,
              color: const Color(0xFF1E293B),
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageTile(BuildContext context, Attachment img, {required double height}) {
    return GestureDetector(
      onTap: () => _openFullscreen(context, img),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          img.fileUrl,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _imagePlaceholder(height),
        ),
      ),
    );
  }

  Widget _imagePlaceholder(double height) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: Icon(Iconsax.image, color: Colors.white30, size: 36)),
    );
  }

  void _openFullscreen(BuildContext context, Attachment img) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _FullscreenImageViewer(imageUrl: img.fileUrl, title: img.fileName),
    ));
  }
}

// ─────────────────────────────────────────────────────────────
// VISOR FULLSCREEN DE IMAGEN
// ─────────────────────────────────────────────────────────────
class _FullscreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String title;
  const _FullscreenImageViewer({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export, color: Colors.white),
            onPressed: () => launchUrl(Uri.parse(imageUrl), mode: LaunchMode.externalApplication),
          ),
        ],
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// THUMBNAIL DE VIDEO
// ─────────────────────────────────────────────────────────────
class _VideoThumbnail extends StatelessWidget {
  final Attachment attachment;
  const _VideoThumbnail({required this.attachment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(attachment.fileUrl), mode: LaunchMode.externalApplication),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: const Color(0xFF0F172A),
              child: attachment.thumbnailUrl != null
                  ? Image.network(attachment.thumbnailUrl!, fit: BoxFit.cover)
                  : const Icon(Iconsax.video, size: 60, color: Colors.white24),
            ),
            // Overlay degradado
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                  ),
                ),
              ),
            ),
            // Botón play
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 36),
            ),
            // Info en la parte inferior
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  const Icon(Iconsax.video, color: Colors.white, size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      attachment.fileName,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (attachment.formattedSize.isNotEmpty)
                    Text(
                      attachment.formattedSize,
                      style: const TextStyle(color: Colors.white60, fontSize: 11),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// TARJETA DE DOCUMENTO
// ─────────────────────────────────────────────────────────────
class _DocumentCard extends StatelessWidget {
  final Attachment attachment;
  const _DocumentCard({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final docInfo = _getDocInfo(attachment.extension);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: docInfo.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => launchUrl(
            Uri.parse(attachment.fileUrl),
            mode: LaunchMode.externalApplication,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Ícono del tipo de documento
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: docInfo.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      attachment.extension.toUpperCase(),
                      style: TextStyle(
                        color: docInfo.color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Nombre y metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.fileName,
                        style: theme.textTheme.labelLarge?.copyWith(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            docInfo.label,
                            style: TextStyle(color: docInfo.color, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          if (attachment.formattedSize.isNotEmpty) ...[
                            const Text(' • ', style: TextStyle(color: Colors.grey, fontSize: 11)),
                            Text(attachment.formattedSize, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Botón descargar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: docInfo.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Iconsax.import_1, color: docInfo.color, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _DocInfo _getDocInfo(String ext) {
    switch (ext) {
      case 'pdf':
        return _DocInfo(Colors.red.shade400, 'PDF', Iconsax.document_text);
      case 'doc':
      case 'docx':
        return _DocInfo(const Color(0xFF2B7CD3), 'Word', Iconsax.document_text);
      case 'xls':
      case 'xlsx':
        return _DocInfo(Colors.green.shade400, 'Excel', Iconsax.document_text);
      case 'ppt':
      case 'pptx':
        return _DocInfo(Colors.orange.shade400, 'PowerPoint', Iconsax.document_text);
      case 'txt':
        return _DocInfo(Colors.grey.shade400, 'Texto', Iconsax.document_text);
      default:
        return _DocInfo(const Color(0xFF00F2FF), ext.toUpperCase(), Iconsax.paperclip);
    }
  }
}

class _DocInfo {
  final Color color;
  final String label;
  final IconData icon;
  _DocInfo(this.color, this.label, this.icon);
}

// ─────────────────────────────────────────────────────────────
// PREVIEW DE ENLACE
// ─────────────────────────────────────────────────────────────
class _LinkPreviewCard extends StatelessWidget {
  final Attachment attachment;
  const _LinkPreviewCard({required this.attachment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = attachment.metadata;
    final ogImage = meta['og_image'] as String?;
    final ogTitle = meta['og_title'] as String?;
    final ogDescription = meta['og_description'] as String?;

    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(attachment.fileUrl), mode: LaunchMode.externalApplication),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1E293B)),
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF0F172A),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ogImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  ogImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.link_1, color: Color(0xFF00F2FF), size: 14),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          attachment.fileUrl,
                          style: const TextStyle(color: Color(0xFF00F2FF), fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (ogTitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      ogTitle,
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (ogDescription != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      ogDescription,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// LEGACY: Compatibilidad con posts antiguos (imageUrl / fileUrl)
// ─────────────────────────────────────────────────────────────
class _LegacyAttachments extends StatelessWidget {
  final MuroPost post;
  const _LegacyAttachments({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        if (post.imageUrl != null) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => _FullscreenImageViewer(imageUrl: post.imageUrl!, title: 'Imagen'),
            )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                post.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
        if (post.fileUrl != null) ...[
          const SizedBox(height: 12),
          Material(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                final uri = Uri.parse(post.fileUrl!);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Iconsax.document_text, color: theme.colorScheme.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Documento Adjunto', style: theme.textTheme.labelLarge?.copyWith(fontSize: 13)),
                          Text('Toca para abrir', style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11)),
                        ],
                      ),
                    ),
                    Icon(Iconsax.import_1, color: theme.colorScheme.primary, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
