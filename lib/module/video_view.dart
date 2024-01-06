import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';



class VdoPlaybackView extends StatefulWidget {
  final bool controls;
  final EmbedInfo vidInfo;

  const VdoPlaybackView({Key? key, this.controls = true, required this.vidInfo}) : super(key: key);

  @override
  VdoPlaybackViewState createState() => VdoPlaybackViewState();
}

class VdoPlaybackViewState extends State<VdoPlaybackView> {
  VdoPlayerController? _controller;
  VdoPlayerValue? vdoPlayerValue;
  final double aspectRatio = 16 / 9;
  final ValueNotifier<bool> _isFullScreen = ValueNotifier(false);
  Duration? duration;

  @override
  Widget build(BuildContext context) {
    String? mediaId = ModalRoute.of(context)?.settings.arguments as String?;
    EmbedInfo embedInfo = widget.vidInfo;
    if (mediaId != null && mediaId.isNotEmpty) {
      embedInfo = EmbedInfo.offline(mediaId: mediaId);
    }
    return Scaffold(
        body: SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: _getPlayerWidth(),
            height: _getPlayerHeight(),
            child: VdoPlayer(
              embedInfo: embedInfo,
              aspectRatio: aspectRatio,
              onError: _onVdoError,
              onFullscreenChange: _onFullscreenChange,
              onPlayerCreated: _onPlayerCreated,
              controls: widget.controls,
              onPictureInPictureModeChanged: _onPictureInPictureModeChanged,

            ),
          )
        ],
      ),
    ));
  }

  _onVdoError(VdoError vdoError) {
    if (kDebugMode) {
      print("Oops, the system encountered a problem: ${vdoError.message}");
    }
    
  }

  _onPlayerCreated(VdoPlayerController? controller) {
    setState(() {
      _controller = controller;
      _onEventChange(_controller);
    });
  }

  _onPictureInPictureModeChanged(bool isInPictureInPictureMode) {}

  _onEventChange(VdoPlayerController? controller) {
    controller?.addListener(() {
      setState(() {
        vdoPlayerValue = controller.value;
      });
    });
  }

  _onFullscreenChange(isFullscreen) {
    setState(() {
      _isFullScreen.value = isFullscreen;
    });
  }

  _getPlayerWidth() {
    return MediaQuery.of(context).size.width;
  }

  _getPlayerHeight() {
    return MediaQuery.of(context).size.height / 1.1;
  }

}