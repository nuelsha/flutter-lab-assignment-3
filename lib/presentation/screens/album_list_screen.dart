import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/album_bloc.dart';
import '../../business_logic/blocs/album_event.dart';
import '../../business_logic/blocs/album_state.dart';
import '../widgets/album_list_item.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as ew;
import 'package:go_router/go_router.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  bool _hasRequested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<AlbumBloc>().state;
    if (!_hasRequested && state is! AlbumLoaded) {
      context.read<AlbumBloc>().add(LoadAlbums());
      _hasRequested = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumError) {
            return ew.ErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<AlbumBloc>().add(LoadAlbums());
                _hasRequested = true;
              },
            );
          } else if (state is AlbumLoaded) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
              itemCount: state.albums.length,
              itemBuilder: (context, index) {
                final album = state.albums[index];
                final thumbnail = state.albumThumbnails[album.id];
                return AlbumListItem(
                  album: album,
                  thumbnailUrl: thumbnail?.thumbnailUrl ?? '',
                  onTap: () {
                    context.go('/album/${album.id}', extra: album);
                  },
                );
              },
            );
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }
} 