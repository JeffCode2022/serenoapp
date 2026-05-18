import 'package:serenazgo_app/features/muro/domain/models/muro_post_model.dart';
import 'package:serenazgo_app/features/muro/domain/models/attachment_model.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class MuroRepository {
  final SupabaseClient supabase;

  /// Tamaño máximo de archivo: 50MB
  static const int maxFileSize = 52428800;

  /// Bucket de storage para adjuntos del muro
  static const String storageBucket = 'muro_attachments';

  MuroRepository({required this.supabase});

  Future<List<MuroPost>> getPosts() async {
    final userId = supabase.auth.currentUser?.id;
    
    // Traer posts con adjuntos, conteos y autor
    final postsResponse = await supabase
        .from('muro_posts')
        .select('''
          *,
          profiles:profiles!user_id(*),
          likes_count: muro_likes(count),
          comments_count: muro_comments(count),
          muro_attachments(*)
        ''')
        .order('created_at', ascending: false);

    if (userId == null) {
      return (postsResponse as List).map((post) {
        return MuroPost.fromJson({
          ...post,
          'likes_count': (post['likes_count'] as List).first['count'] as int,
          'comments_count': (post['comments_count'] as List).first['count'] as int,
        });
      }).toList();
    }

    // Traer interacciones del usuario actual
    final likesResponse = await supabase.from('muro_likes').select('post_id').eq('user_id', userId);
    final savedResponse = await supabase.from('muro_saved').select('post_id').eq('user_id', userId);

    final likedPostIds = (likesResponse as List).map((l) => l['post_id'] as int).toSet();
    final savedPostIds = (savedResponse as List).map((s) => s['post_id'] as int).toSet();

    return (postsResponse as List).map((post) {
      final postId = post['id'] as int;
      return MuroPost.fromJson({
        ...post,
        'likes_count': (post['likes_count'] as List).first['count'] as int,
        'comments_count': (post['comments_count'] as List).first['count'] as int,
        'is_liked': likedPostIds.contains(postId),
        'is_saved': savedPostIds.contains(postId),
      });
    }).toList();
  }

  /// Crea un post con texto y opcionalmente múltiples adjuntos.
  Future<void> createPost(
    String content, {
    List<PendingAttachment>? attachments,
    bool isSos = false,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 1. Crear el post
    final response = await supabase.from('muro_posts').insert({
      'user_id': userId,
      'content': content,
      'is_sos': isSos,
    }).select('id').single();

    final postId = response['id'] as int;

    // 2. Subir y registrar cada adjunto
    if (attachments != null && attachments.isNotEmpty) {
      for (final attachment in attachments) {
        if (attachment.fileType == AttachmentType.link) {
          // Para enlaces, solo registrar en la tabla sin subir archivo
          await _insertAttachment(
            postId: postId,
            fileUrl: attachment.localPath, // La URL del enlace
            fileName: attachment.fileName,
            fileType: 'link',
            mimeType: null,
            fileSize: null,
            metadata: attachment.remoteUrl != null ? {'og_url': attachment.remoteUrl} : {},
          );
        } else {
          // Subir archivo al storage
          final remoteUrl = await uploadFileToStorage(
            attachment.localPath,
            attachment.fileName,
            subfolder: attachment.fileType.name,
          );

          if (remoteUrl != null) {
            await _insertAttachment(
              postId: postId,
              fileUrl: remoteUrl,
              fileName: attachment.fileName,
              fileType: attachment.fileType.name,
              mimeType: attachment.mimeType,
              fileSize: attachment.fileSize,
            );
          }
        }
      }
    }
  }

  /// Registra un adjunto en la base de datos.
  Future<void> _insertAttachment({
    required int postId,
    required String fileUrl,
    required String fileName,
    required String fileType,
    String? mimeType,
    int? fileSize,
    String? thumbnailUrl,
    Map<String, dynamic>? metadata,
  }) async {
    await supabase.from('muro_attachments').insert({
      'post_id': postId,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_type': fileType,
      'mime_type': mimeType,
      'file_size': fileSize,
      'thumbnail_url': thumbnailUrl,
      'metadata': metadata ?? {},
    });
  }

  /// Sube un archivo al storage de Supabase y devuelve la URL pública.
  Future<String?> uploadFileToStorage(
    String localPath,
    String fileName, {
    String subfolder = 'general',
  }) async {
    try {
      final file = File(localPath);
      
      // Validar tamaño
      final fileSize = await file.length();
      if (fileSize > maxFileSize) {
        throw Exception('El archivo supera el límite de 50MB');
      }

      // Generar nombre único para evitar colisiones
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sanitizedName = fileName.replaceAll(RegExp(r'[^\w\d.-]'), '_');
      final pathInBucket = '$subfolder/${timestamp}_$sanitizedName';

      await supabase.storage.from(storageBucket).upload(pathInBucket, file);
      return supabase.storage.from(storageBucket).getPublicUrl(pathInBucket);
    } catch (e) {
      // Re-lanzar para que el caller pueda manejar
      rethrow;
    }
  }

  // --- Mantener compatibilidad legacy ---
  Future<String?> uploadFile(String path, String fileName) async {
    return uploadFileToStorage(path, fileName, subfolder: 'docs');
  }

  Future<void> likePost(int postId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('muro_likes').upsert({
      'user_id': userId,
      'post_id': postId,
    });
  }

  Future<void> unlikePost(int postId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase
        .from('muro_likes')
        .delete()
        .match({'user_id': userId, 'post_id': postId});
  }

  Future<void> savePost(int postId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('muro_saved').upsert({
      'user_id': userId,
      'post_id': postId,
    });
  }

  Future<void> unsavePost(int postId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase
        .from('muro_saved')
        .delete()
        .match({'user_id': userId, 'post_id': postId});
  }

  Future<void> deletePost(int postId) async {
    // Los adjuntos se eliminan en cascada por la FK
    await supabase.from('muro_posts').delete().eq('id', postId);
  }

  // --- Funciones de Comentarios ---
  Future<List<Map<String, dynamic>>> getComments(int postId) async {
    final response = await supabase
        .from('muro_comments')
        .select('*, profiles:profiles!user_id(full_name)')
        .eq('post_id', postId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addComment(int postId, String content) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('muro_comments').insert({
      'user_id': userId,
      'post_id': postId,
      'content': content,
    });
  }

  // --- Funciones de Likes ---
  Future<List<Map<String, dynamic>>> getPostLikes(int postId) async {
    final response = await supabase
        .from('muro_likes')
        .select('*, profiles:profiles!user_id(full_name, role)')
        .eq('post_id', postId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> updatePost(int postId, String content) async {
    await supabase.from('muro_posts').update({
      'content': content,
    }).eq('id', postId);
  }
}
