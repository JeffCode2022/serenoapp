import 'package:equatable/equatable.dart';

/// Tipos de adjunto soportados por el muro social.
enum AttachmentType {
  image,
  video,
  document,
  link;

  /// Convierte un string del backend al enum.
  static AttachmentType fromString(String value) {
    return AttachmentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AttachmentType.document,
    );
  }
}

/// Modelo de adjunto para publicaciones del muro social.
/// Soporta imágenes, videos, documentos y enlaces con metadata.
class Attachment extends Equatable {
  final int id;
  final int postId;
  final String fileUrl;
  final String fileName;
  final AttachmentType fileType;
  final String? mimeType;
  final int? fileSize;
  final String? thumbnailUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const Attachment({
    required this.id,
    required this.postId,
    required this.fileUrl,
    required this.fileName,
    required this.fileType,
    this.mimeType,
    this.fileSize,
    this.thumbnailUrl,
    this.metadata = const {},
    required this.createdAt,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] as int,
      postId: json['post_id'] as int,
      fileUrl: json['file_url'] as String,
      fileName: json['file_name'] as String,
      fileType: AttachmentType.fromString(json['file_type'] as String),
      mimeType: json['mime_type'] as String?,
      fileSize: json['file_size'] as int?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Extensión del archivo derivada del nombre.
  String get extension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Tamaño formateado legible para humanos.
  String get formattedSize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1048576) return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize! / 1048576).toStringAsFixed(1)}MB';
  }

  /// Devuelve true si es una imagen previsualizable.
  bool get isPreviewableImage =>
      fileType == AttachmentType.image &&
      ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension);

  /// Devuelve true si es un video reproducible.
  bool get isPlayableVideo =>
      fileType == AttachmentType.video &&
      ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(extension);

  /// Devuelve true si es un PDF.
  bool get isPdf => extension == 'pdf';

  /// Devuelve true si es un documento de Office.
  bool get isOfficeDoc =>
      ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].contains(extension);

  @override
  List<Object?> get props => [
        id,
        postId,
        fileUrl,
        fileName,
        fileType,
        mimeType,
        fileSize,
        thumbnailUrl,
        metadata,
        createdAt,
      ];
}

/// Modelo temporal para adjuntos que se están preparando antes de subir.
class PendingAttachment {
  final String localPath;
  final String fileName;
  final AttachmentType fileType;
  final String? mimeType;
  final int? fileSize;
  double uploadProgress;
  bool isUploading;
  bool isUploaded;
  String? remoteUrl;
  String? error;

  PendingAttachment({
    required this.localPath,
    required this.fileName,
    required this.fileType,
    this.mimeType,
    this.fileSize,
    this.uploadProgress = 0.0,
    this.isUploading = false,
    this.isUploaded = false,
    this.remoteUrl,
    this.error,
  });

  /// Extensión del archivo.
  String get extension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  /// Tamaño formateado.
  String get formattedSize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1048576) return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize! / 1048576).toStringAsFixed(1)}MB';
  }

  /// Detecta el tipo de adjunto basado en la extensión del archivo.
  static AttachmentType detectType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic'].contains(ext)) {
      return AttachmentType.image;
    }
    if (['mp4', 'mov', 'avi', 'mkv', 'webm', '3gp'].contains(ext)) {
      return AttachmentType.video;
    }
    return AttachmentType.document;
  }

  /// Detecta el MIME type basado en la extensión.
  static String? detectMimeType(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    const mimeMap = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'bmp': 'image/bmp',
      'heic': 'image/heic',
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'avi': 'video/x-msvideo',
      'mkv': 'video/x-matroska',
      'webm': 'video/webm',
      'pdf': 'application/pdf',
      'doc': 'application/msword',
      'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'xls': 'application/vnd.ms-excel',
      'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'ppt': 'application/vnd.ms-powerpoint',
      'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      'txt': 'text/plain',
    };
    return mimeMap[ext];
  }
}
