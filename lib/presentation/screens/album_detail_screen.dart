import 'package:flutter/material.dart';
import '../../data/models/album.dart';
import '../../data/models/photo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../business_logic/blocs/album_bloc.dart';
import '../../business_logic/blocs/album_event.dart';
import '../../business_logic/blocs/album_state.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as ew;
import 'package:cached_network_image/cached_network_image.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album? album;
  const AlbumDetailScreen({Key? key, required this.album}) : super(key: key);

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.album != null) {
      context.read<AlbumBloc>().add(SelectAlbum(widget.album!));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.album == null) {
      return const Scaffold(
        body: Center(child: Text('Album not found.')),
      );
    }
    return WillPopScope(
      onWillPop: () async {
        context.read<AlbumBloc>().add(LoadAlbums());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.album!.title)),
        body: BlocBuilder<AlbumBloc, AlbumState>(
          builder: (context, state) {
            if (state is AlbumLoading) {
              return const LoadingWidget();
            } else if (state is AlbumError) {
              return ew.ErrorWidget(
                message: state.message,
                onRetry: () => context.read<AlbumBloc>().add(SelectAlbum(widget.album!)),
              );
            } else if (state is AlbumSelected && state.album.id == widget.album!.id) {
              if (state.photos.isEmpty) {
                return const Center(child: Text('No photos found for this album.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  final photo = state.photos[index];
                  return Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: photo.thumbnailUrl,
                            placeholder: (context, url) => const LoadingWidget(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            photo.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const LoadingWidget();
          },
        ),
      ),
    );
  }
} 