import '../../data/models/album.dart';

abstract class AlbumEvent {}

class LoadAlbums extends AlbumEvent {}

class SelectAlbum extends AlbumEvent {
  final Album album;
  SelectAlbum(this.album);
} 