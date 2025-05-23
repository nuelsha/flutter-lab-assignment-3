import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/album_repository.dart';
import '../../data/models/album.dart';
import '../../data/models/photo.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<SelectAlbum>(_onSelectAlbum);
  }

  Future<void> _onLoadAlbums(LoadAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.getAlbums();
      final photos = await albumRepository.getPhotos();
      // Map albumId to its first photo as thumbnail
      final Map<int, Photo?> albumThumbnails = {
        for (var album in albums)
          album.id: photos.firstWhere(
            (photo) => photo.albumId == album.id,
            orElse: () => Photo(
              albumId: album.id,
              id: 0,
              title: '',
              url: '',
              thumbnailUrl: '',
            ),
          )
      };
      emit(AlbumLoaded(albums: albums, albumThumbnails: albumThumbnails));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  Future<void> _onSelectAlbum(SelectAlbum event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final photos = await albumRepository.getPhotosForAlbum(event.album.id);
      emit(AlbumSelected(album: event.album, photos: photos));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
} 