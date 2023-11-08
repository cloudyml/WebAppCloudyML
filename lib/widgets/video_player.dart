import 'dart:html';
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;

class VideoPlayerWidget extends StatefulWidget {
  String? url;
  VideoPlayerWidget({this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  String elemtntId = Random().nextInt(100000).toString();
  html.IFrameElement _iFrameElement = html.IFrameElement();
  GlobalKey iFrameKey = GlobalKey();
  initPlayer(String url) {
    _iFrameElement.style.height = '100%';
    _iFrameElement.style.width = '100%';
    _iFrameElement.allowFullscreen = true;
    _iFrameElement.src = url;
    _iFrameElement.style.border = 'none';

    // Add the video widget to the widget tree
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      elemtntId,
          (int viewId) => _iFrameElement,
    );
  }

  @override
  void initState() {
    initPlayer(widget.url!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 640,
      height: 360,
      child: HtmlElementView(
          viewType: elemtntId,
          key: iFrameKey,
      ),
    );
  }
}