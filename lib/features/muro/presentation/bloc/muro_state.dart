part of 'muro_bloc.dart';

abstract class MuroState extends Equatable {
  const MuroState();
  
  @override
  List<Object> get props => [];
}

class MuroInitial extends MuroState {}

class MuroLoading extends MuroState {}

class MuroLoaded extends MuroState {
  final List<MuroPost> posts;

  const MuroLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class MuroError extends MuroState {
  final String message;

  const MuroError({required this.message});

  @override
  List<Object> get props => [message];
}

class MuroActionSuccess extends MuroState {}
