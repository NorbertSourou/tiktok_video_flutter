import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController pageController =
      PageController(initialPage: 0, keepPage: true);
  int currentPage = 0;
  bool isOnPageTurning = false;

  void scrollListener() {
    if (isOnPageTurning &&
        pageController.page == pageController.page!.roundToDouble()) {
      setState(() {
        currentPage = pageController.page!.toInt();
        isOnPageTurning = false;
      });
    } else if (!isOnPageTurning &&
        currentPage.toDouble() != pageController.page) {
      if ((currentPage.toDouble() - pageController.page!).abs() > 0.7) {
        setState(() {
          isOnPageTurning = true;
        });
      }
    }
  }

  @override
  void initState() {
    //  pageController.addListener(scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: pageController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return VideoItemWidget(
            // videoInfo: items[index],
            pageIndex: index,
            currentPageIndex: currentPage,
            isPaused: isOnPageTurning,
            videoEnded: () {},
          );
        },
      ),
    );
  }
}

class VideoItemWidget extends StatefulWidget {
  // final VideoInfo videoInfo;
  final int pageIndex;
  final int currentPageIndex;
  final bool isPaused;
  final void Function()? videoEnded;

  const VideoItemWidget({
    super.key,
    // required this.videoInfo,
    required this.pageIndex,
    required this.currentPageIndex,
    required this.isPaused,
    this.videoEnded,
  });

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  late VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  Future initializeVideo() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'));

    await videoPlayerController?.initialize();

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      allowFullScreen: true,
      allowMuting: true,
      looping: true,
      showControls: true,
      placeholder: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      showControlsOnInitialize: false,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      // deviceOrientationsAfterFullScreen: [
      //   DeviceOrientation.portraitUp,
      //   DeviceOrientation.portraitDown,
      // ],
    );
    setState(() {});
  }

  @override
  void initState() {
    initializeVideo();
    super.initState();

    //  chewieController?.play();
    //  videoPlayerController?.addListener(_videoListener);
  }

  @override
  void dispose() {
    // initialized

    //  videoPlayerController?.removeListener(_videoListener);
    videoPlayerController?.dispose();
    videoPlayerController = null;
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: chewieController == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Center(
              child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: videoPlayerController?.value.size.width ?? 0,
                      height: videoPlayerController?.value.size.height ?? 0,
                      child: Chewie(controller: chewieController!),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'Ceci est une description sur la vidéo numéro ${widget.pageIndex}',
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )),
    );
  }
}
