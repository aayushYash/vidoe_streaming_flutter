import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoSearchWidget extends StatefulWidget {
  final Function(String) onVideoSelected;

  const VideoSearchWidget({Key? key, required this.onVideoSelected}) : super(key: key);

  @override
  _VideoSearchWidgetState createState() => _VideoSearchWidgetState();
}

class _VideoSearchWidgetState extends State<VideoSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final YoutubeExplode _youtubeExplode = YoutubeExplode();
  List<Video> _searchResults = [];
  bool _isLoading = false;

  void _searchVideo() async {
    if (_searchController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchResults.clear();
    });

    try {
      var searchResults = await _youtubeExplode.search.getVideos(_searchController.text);
      setState(() {
        _searchResults = searchResults.take(10).toList(); // Limit to 10 results
        _isLoading = false;
      });
    } catch (e) {
      print("Error searching YouTube video: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectVideo(Video video) {
    String videoUrl = 'https://www.youtube.com/watch?v=${video.id.value}';
    widget.onVideoSelected(videoUrl);
    _searchController.clear();
    setState(() {
      _searchResults.clear(); // Clear search results after selection
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search YouTube Video",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchVideo,
            ),
          ),
        ),
        if (_isLoading) const CircularProgressIndicator(),
        Expanded(
          child: _searchResults.isEmpty
              ? const Center(child: Text("No results"))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final video = _searchResults[index];
                    return ListTile(
                      leading: Image.network(video.thumbnails.highResUrl),
                      title: Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text(video.author),
                      onTap: () => _selectVideo(video),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
