import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/muro_repository.dart';
import '../../domain/models/muro_post_model.dart';

part 'muro_event.dart';
part 'muro_state.dart';

class MuroBloc extends Bloc<MuroEvent, MuroState> {
  final MuroRepository repository;
  RealtimeChannel? _subscription;

  MuroBloc({required this.repository}) : super(MuroInitial()) {
    on<LoadMuroPosts>(_onLoadPosts);
    on<CreateMuroPost>(_onCreatePost);
    on<ToggleLikePost>(_onToggleLike);
    on<ToggleSavePost>(_onToggleSave);
    on<DeleteMuroPost>(_onDeletePost);
    on<UpdateMuroPost>(_onUpdatePost);

    // Activar Tiempo Real
    _initRealtime();
  }

  void _initRealtime() {
    print('Intentando conectar al flujo de noticias...');
    
    // Usamos una suscripción más directa para evitar timeouts
    _subscription = repository.supabase
        .channel('muro_social')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'muro_posts',
          callback: (payload) {
            print('¡Actualización de Post!');
            add(LoadMuroPosts());
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'muro_likes',
          callback: (payload) {
            print('¡Actualización de Like!');
            add(LoadMuroPosts());
          },
        )
        .subscribe((status, error) {
          print('--- ESTADO: $status ---');
          if (error != null) print('--- DETALLE: $error ---');
        });
  }

  @override
  Future<void> close() {
    _subscription?.unsubscribe();
    return super.close();
  }

  Future<void> _onLoadPosts(LoadMuroPosts event, Emitter<MuroState> emit) async {
    // Solo mostramos "cargando" si no hay posts previos (primera carga)
    if (state is! MuroLoaded) {
      emit(MuroLoading());
    }

    try {
      final posts = await repository.getPosts();
      emit(MuroLoaded(posts: posts));
    } catch (e) {
      // Si ya teníamos posts, no mostramos error total, solo ignoramos o manejamos el log
      if (state is! MuroLoaded) {
        emit(MuroError(message: e.toString()));
      }
    }
  }

  Future<void> _onCreatePost(CreateMuroPost event, Emitter<MuroState> emit) async {
    try {
      await repository.createPost(
        event.content,
        imageUrl: event.imageUrl,
        fileUrl: event.fileUrl,
        isSos: event.isSos,
      );
      add(LoadMuroPosts());
    } catch (e) {
      emit(MuroError(message: e.toString()));
    }
  }

  Future<void> _onToggleLike(ToggleLikePost event, Emitter<MuroState> emit) async {
    if (state is MuroLoaded) {
      final posts = (state as MuroLoaded).posts;
      final index = posts.indexWhere((p) => p.id == event.post.id);
      if (index == -1) return;

      // Optimistic Update
      final updatedPost = event.post.copyWith(
        isLiked: !event.post.isLiked,
        likesCount: event.post.isLiked ? event.post.likesCount - 1 : event.post.likesCount + 1,
      );
      final updatedPosts = List<MuroPost>.from(posts)..[index] = updatedPost;
      emit(MuroLoaded(posts: updatedPosts));

      try {
        if (event.post.isLiked) {
          await repository.unlikePost(event.post.id);
        } else {
          await repository.likePost(event.post.id);
        }
      } catch (e) {
        // Rollback en caso de error
        emit(MuroLoaded(posts: posts));
      }
    }
  }

  Future<void> _onToggleSave(ToggleSavePost event, Emitter<MuroState> emit) async {
    if (state is MuroLoaded) {
      final posts = (state as MuroLoaded).posts;
      final index = posts.indexWhere((p) => p.id == event.post.id);
      if (index == -1) return;

      final updatedPost = event.post.copyWith(isSaved: !event.post.isSaved);
      final updatedPosts = List<MuroPost>.from(posts)..[index] = updatedPost;
      emit(MuroLoaded(posts: updatedPosts));

      try {
        if (event.post.isSaved) {
          await repository.unsavePost(event.post.id);
        } else {
          await repository.savePost(event.post.id);
        }
      } catch (e) {
        emit(MuroLoaded(posts: posts));
      }
    }
  }

  Future<void> _onDeletePost(DeleteMuroPost event, Emitter<MuroState> emit) async {
    try {
      await repository.deletePost(event.postId);
      add(LoadMuroPosts());
    } catch (e) {
      emit(MuroError(message: e.toString()));
    }
  }

  Future<void> _onUpdatePost(UpdateMuroPost event, Emitter<MuroState> emit) async {
    try {
      await repository.updatePost(event.postId, event.content);
      add(LoadMuroPosts());
    } catch (e) {
      emit(MuroError(message: e.toString()));
    }
  }
}
