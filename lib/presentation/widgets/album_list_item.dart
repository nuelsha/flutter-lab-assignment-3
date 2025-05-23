import 'package:flutter/material.dart';
import '../../data/models/album.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AlbumListItem extends StatelessWidget {
  final Album album;
  final String thumbnailUrl;
  final VoidCallback onTap;

  const AlbumListItem({
    Key? key,
    required this.album,
    required this.thumbnailUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color tileColor = Colors.blueGrey.shade900;
    final Color textColor = Colors.white;
    return Card(
      color: tileColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: thumbnailUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue)),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.blueAccent, size: 40),
                ),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_outlined, color: Colors.blueAccent, size: 32),
              ),
        title: Text(
          album.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueAccent),
      ),
    );
  }
} 