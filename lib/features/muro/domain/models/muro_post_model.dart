import 'package:equatable/equatable.dart';
import '../../../../core/models/profile_model.dart';
import 'attachment_model.dart';

class MuroPost extends Equatable {
  final int id;
  final String userId;
  final String content;
  final String? imageUrl;
  final String? fileUrl;
  final bool isSos;
  final DateTime createdAt;
  final Profile? author;
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final bool isSaved;
  final List<Attachment> attachments;

  const MuroPost({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    this.fileUrl,
    this.isSos = false,
    required this.createdAt,
    this.author,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    this.attachments = const [],
  });

  factory MuroPost.fromJson(Map<String, dynamic> json) {
    // Parsear adjuntos desde la relación con muro_attachments
    final rawAttachments = json['muro_attachments'];
    final attachmentsList = <Attachment>[];
    if (rawAttachments != null && rawAttachments is List) {
      for (final a in rawAttachments) {
        attachmentsList.add(Attachment.fromJson(a as Map<String, dynamic>));
      }
    }

    return MuroPost(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      fileUrl: json['file_url'],
      isSos: json['is_sos'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      author: json['profiles'] != null ? Profile.fromJson(json['profiles']) : null,
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
      isSaved: json['is_saved'] ?? false,
      attachments: attachmentsList,
    );
  }

  /// Obtiene todas las imágenes adjuntas (del nuevo sistema + legacy imageUrl).
  List<Attachment> get images =>
      attachments.where((a) => a.fileType == AttachmentType.image).toList();

  /// Obtiene todos los videos adjuntos.
  List<Attachment> get videos =>
      attachments.where((a) => a.fileType == AttachmentType.video).toList();

  /// Obtiene todos los documentos adjuntos (del nuevo sistema + legacy fileUrl).
  List<Attachment> get documents =>
      attachments.where((a) => a.fileType == AttachmentType.document).toList();

  /// Obtiene todos los enlaces adjuntos.
  List<Attachment> get links =>
      attachments.where((a) => a.fileType == AttachmentType.link).toList();

  /// Devuelve true si tiene cualquier tipo de adjunto.
  bool get hasAttachments => attachments.isNotEmpty || imageUrl != null || fileUrl != null;

  @override
  List<Object?> get props => [
        id,
        userId,
        content,
        imageUrl,
        fileUrl,
        isSos,
        createdAt,
        author,
        likesCount,
        commentsCount,
        isLiked,
        isSaved,
        attachments,
      ];

  MuroPost copyWith({
    int? likesCount,
    int? commentsCount,
    bool? isLiked,
    bool? isSaved,
    List<Attachment>? attachments,
  }) {
    return MuroPost(
      id: id,
      userId: userId,
      content: content,
      imageUrl: imageUrl,
      fileUrl: fileUrl,
      isSos: isSos,
      createdAt: createdAt,
      author: author,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      attachments: attachments ?? this.attachments,
    );
  }
}
