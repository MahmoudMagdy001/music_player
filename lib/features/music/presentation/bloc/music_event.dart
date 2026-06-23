import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class LoadSongs extends MusicEvent {}

class SearchSongs extends MusicEvent {
  final String query;

  const SearchSongs(this.query);

  @override
  List<Object?> get props => [query];
}
