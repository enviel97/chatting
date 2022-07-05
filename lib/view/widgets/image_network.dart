import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/view/constants/colors.dart';

class ImageNetWork extends StatefulWidget {
  final String url;
  final double size;

  const ImageNetWork(this.url, {Key? key, this.size = 126.0}) : super(key: key);

  @override
  _ImageNetWorkState createState() => _ImageNetWorkState();
}

class _ImageNetWorkState extends State<ImageNetWork> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      height: widget.size,
      width: widget.size,
      imageUrl: widget.url,
      errorWidget: _errorBuilder,
      progressIndicatorBuilder: _buildProccess,
      filterQuality: FilterQuality.medium,
    );
  }

  Image _nullImage() => Image.asset('assets/images/none/no-image-baby.png');

  Widget _errorBuilder(_, __, ___) => _nullImage();

  Widget _buildProccess(
      BuildContext context, String url, DownloadProgress download) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _nullImage(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            value: download.progress,
            strokeWidth: 2.0,
            backgroundColor: KColor.grey,
            valueColor: AlwaysStoppedAnimation<Color>(KColor.primary),
          ),
        )
      ],
    );
  }
}
