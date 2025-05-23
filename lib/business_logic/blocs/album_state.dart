import '../../data/models/album.dart';
import '../../data/models/photo.dart';

abstract class AlbumState {}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, Photo?> albumThumbnails;
  AlbumLoaded({required this.albums, required this.albumThumbnails});
}

class AlbumError extends AlbumState {
  final String message;
  AlbumError(this.message);
}

class AlbumSelected extends AlbumState {
  final Album album;
  final List<Photo> photos;
  AlbumSelected({required this.album, required this.photos});
} 