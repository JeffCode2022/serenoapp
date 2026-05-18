part of 'muro_bloc.dart';

abstract class MuroEvent extends Equatable {
  const MuroEvent();

  @override
  List<Object> get props => [];
}

class LoadMuroPosts extends MuroEvent {}

class CreateMuroPost extends MuroEvent {
  final String content;
  final List<PendingAttachment>? attachments;
  final bool isSos;

  const CreateMuroPost({
    required this.content, 
    this.attachments,
    this.isSos = false,
  });

  @override
  List<Object> get props => [content, isSos];
}

class ToggleLikePost extends MuroEvent {
  final MuroPost post;

  const ToggleLikePost({required this.post});

  @override
  List<Object> get props => [post];
}

class ToggleSavePost extends MuroEvent {
  final MuroPost post;

  const ToggleSavePost({required this.post});

  @override
  List<Object> get props => [post];
}

class DeleteMuroPost extends MuroEvent {
  final int postId;

  const DeleteMuroPost({required this.postId});

  @override
  List<Object> get props => [postId];
}

class UpdateMuroPost extends MuroEvent {
  final int postId;
  final String content;

  const UpdateMuroPost({required this.postId, required this.content});

  @override
  List<Object> get props => [postId, content];
}
