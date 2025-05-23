import '../models/album.dart';
import '../models/photo.dart';
import '../providers/api_provider.dart';

class AlbumRepository {
  final ApiProvider apiProvider;
  List<Album>? _albumsCache;
  List<Photo>? _photosCache;

  AlbumRepository(this.apiProvider);

  Future<List<Album>> getAlbums() async {
    _albumsCache ??= await apiProvider.fetchAlbums();
    return _albumsCache!;
  }

  Future<List<Photo>> getPhotos() async {
    _photosCache ??= await apiProvider.fetchPhotos();
    return _photosCache!;
  }

  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    final photos = await getPhotos();
    return photos.where((photo) => photo.albumId == albumId).toList();
  }

  Future<Album?> getAlbumById(int id) async {
    final albums = await getAlbums();
    try {
      return albums.firstWhere((album) => album.id == id);
    } catch (_) {
      return null;
    }
  }
} 