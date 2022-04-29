import 'package:flutter/material.dart';
import 'package:lab_3/presentation/utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'home/home_controller.dart';

class ListeningPage extends StatelessWidget {
  final Mood? mood;
  static final Map<Mood, String> _urls = {
    Mood.calm: 'https://music.yandex.by/users/no-subject/playlists/1004',
    Mood.anxious: 'https://music.yandex.by/users/no-subject/playlists/1005',
    Mood.relax: 'https://music.yandex.by/users/no-subject/playlists/1006',
    Mood.focus: 'https://facebook.com',
  };





  const ListeningPage({Key? key, required this.mood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.defaultBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          if (mood == null)
            const Center(
              child: SizedBox(
                width: 300,
                child: Text(
                  'First select your today\'s mood',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Alegreya',
                    color: Colors.white,
                    decoration: null,
                  ),
                ),
              ),
            ),
          if (mood != null) ...[
            Center(
              child: Text(
                _urls[mood!]!,
                //mood!.name,
                softWrap: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 35,
                  fontFamily: 'Alegreya',
                  color: Colors.white,
                  decoration: null,
                ),
              ),
            ),
            Expanded(
              child: _moodPlaylist(_urls[mood]!),
            ),
          ],
        ],
      ),
    );
  }



  // Widget _moodPlaylist(String url) {
  //   return ClipRRect(
  //     clipBehavior: Clip.hardEdge,
  //     child: SizedBox(
  //       height: 200,
  //       child: WebView(
  //         initialUrl:
  //         url
  //
  //     ,
  //       ),
  //     ),
  //     borderRadius: BorderRadius.circular(20),
  //   );
  // }

  Widget _moodPlaylist(String url) {
    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 200,
        child: WebView(
          initialUrl: _urls[mood!]!,
          onWebViewCreated: (WebViewController webViewController) {
            webViewController.loadUrl(_urls[mood!]!);
          },
        ),
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }
  // Widget _moodPlaylist() {
  //   switch (mood!) {
  //     case (Mood.calm):
  //       return ClipRRect(
  //         clipBehavior: Clip.hardEdge,
  //         child: SizedBox(
  //           height: 200,
  //           child: WebView(
  //             initialUrl: _urls[0],
  //           ),
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //       );
  //     case (Mood.anxious):
  //       return ClipRRect(
  //         clipBehavior: Clip.hardEdge,
  //         child: SizedBox(
  //           height: 200,
  //           child: WebView(
  //             initialUrl: _urls[1],
  //           ),
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //       );
  //     case (Mood.relax):
  //       return ClipRRect(
  //         clipBehavior: Clip.hardEdge,
  //         child: SizedBox(
  //           height: 200,
  //           child: WebView(
  //             initialUrl: _urls[2],
  //           ),
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //       );
  //     default:
  //       return ClipRRect(
  //         clipBehavior: Clip.hardEdge,
  //         child: SizedBox(
  //           height: 200,
  //           child: WebView(
  //             initialUrl: _urls[3],
  //           ),
  //         ),
  //         borderRadius: BorderRadius.circular(20),
  //       );
  //   }
  // }
}
