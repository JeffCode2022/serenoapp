import 'package:serenazgo_app/features/muro/domain/models/muro_post_model.dart';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class MuroRepository {
  final SupabaseClient supabase;

  MuroRepository({required this.supabase});

  Future<List<MuroPost>> getPosts() async {
    final userId = supabase.auth.currentUser?.id;
    
    // 1. Traer todos los posts con sus conteos globales y autor
    final postsResponse = await supabase
        .from('muro_posts')
        .select('''
          *,
          profiles:profiles!user_id(*),
          likes_count: muro_likes(count),
          comments_count: muro_comments(count)
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

    // 2. Traer solo los IDs de lo que el usuario ha interactuado (Eficiente)
    final likesResponse = await supabase.from('muro_likes').select('post_id').eq('user_id', userId);
    final savedResponse = await supabase.from('muro_saved').select('post_id').eq('user_id', userId);

    final likedPostIds = (likesResponse as List).map((l) => l['post_id'] as int).toSet();
    final savedPostIds = (savedResponse as List).map((s) => s['post_id'] as int).toSet();

    // 3. Mapear con la info de interacción del usuario actual
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

  Future<void> createPost(String content, {String? imageUrl, String? fileUrl, bool isSos = false}) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    await supabase.from('muro_posts').insert({
      'user_id': userId,
      'content': content,
      'image_url': imageUrl,
      'file_url': fileUrl,
      'is_sos': isSos,
    });
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

  Future<String?> uploadFile(String path, String fileName) async {
    final file = File(path);
    final pathInBucket = 'docs/$fileName';

    await supabase.storage.from('muro_images').upload(pathInBucket, file);
    return supabase.storage.from('muro_images').getPublicUrl(pathInBucket);
  }

  Future<void> updatePost(int postId, String content) async {
    await supabase.from('muro_posts').update({
      'content': content,
    }).eq('id', postId);
  }
}
