import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrl);
  }

  void _initializePlayer(String videoUrl) {
    _controller = YoutubePlayerController(
      // initialVideoId: YoutubePlayerController.convertUrlToId(videoUrl) ?? '',
      params: const YoutubePlayerParams(
        // autoPlay: true,
        // showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void didUpdateWidget(YoutubePlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller.loadVideoById(videoId: YoutubePlayerController.convertUrlToId(widget.videoUrl) ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Center(child: player);
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
