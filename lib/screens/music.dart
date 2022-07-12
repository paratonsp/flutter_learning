// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, missing_return

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:mini_music_visualizer/mini_music_visualizer.dart';
import 'package:blur/blur.dart';

class MusicScreen extends StatefulWidget {
  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class Track {
  const Track(
    this.titleTrack,
    this.durationTrack,
    this.previewTrack,
    this.imageTrack,
  );
  final String titleTrack;
  final int durationTrack;
  final String previewTrack;
  final String imageTrack;
}

String formatedTime(int secTime) {
  String getParsedTime(String time) {
    if (time.length <= 1) return "0$time";
    return time;
  }

  int min = secTime ~/ 60;
  int sec = secTime % 60;

  String parsedTime =
      getParsedTime(min.toString()) + ":" + getParsedTime(sec.toString());

  return parsedTime;
}

class _MusicScreenState extends State<MusicScreen>
    with TickerProviderStateMixin {
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool loadArtist = true;
  bool loadTrack = true;
  bool playTrack = false;
  bool pauseTrack = false;
  String artistName;
  String artistImage;
  String artistAlbum;
  String artistFan;
  List<Track> listTrack;

  int _index;
  bool stopTrack = true;
  String currentTitleTrack;
  String currentImageTrack;
  String currentArtistTrack;
  String currentPreviewTrack;

  _updateSelected(int index) => setState(() => _index = index);

  getArtist() async {
    final response =
        await http.get(Uri.parse("https://api.deezer.com/artist/6241820"));
    setState(() {
      artistName = jsonDecode(response.body)['name'];
      artistImage = jsonDecode(response.body)['picture_xl'];
      artistAlbum = jsonDecode(response.body)['nb_album'].toString();
      artistFan = jsonDecode(response.body)['nb_fan'].toString();
      loadArtist = false;
    });
  }

  getTrack() async {
    final response = await http
        .get(Uri.parse("https://api.deezer.com/artist/6241820/top?limit=10"));

    List<Track> temp = [];
    for (var data in jsonDecode(response.body)['data'] as List) {
      temp.add(
        Track(
          data['title'],
          data['duration'],
          data['preview'],
          data['album']['cover_big'],
        ),
      );
    }
    setState(() {
      listTrack = temp;
      loadTrack = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getArtist();
    getTrack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Music"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: (loadArtist || loadTrack)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(30),
                            height: MediaQuery.of(context).size.width - 60,
                            width: MediaQuery.of(context).size.width - 60,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    artistImage,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Colors.blueAccent.withOpacity(0.7),
                                          Colors.redAccent.withOpacity(0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Center(
                                    child: Text(
                                      artistName.toUpperCase(),
                                      maxLines: 3,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listTrack.length,
                        itemBuilder: (context, index) {
                          bool _isSelected = index == _index;
                          double bottomPad;
                          if ((listTrack.length) == index + 1) {
                            if (stopTrack) {
                              bottomPad = 15;
                            } else {
                              bottomPad = 90;
                            }
                          } else {
                            bottomPad = 15;
                          }
                          Track track = listTrack[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                left: 30, right: 30, bottom: bottomPad),
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashFactory: NoSplash.splashFactory,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: Image.network(
                                              track.imageTrack,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(track.titleTrack,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                              artistName,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  assetsAudioPlayer.builderRealtimePlayingInfos(
                                      builder: (context,
                                          RealtimePlayingInfos infos) {
                                    return (_isSelected && infos.isPlaying)
                                        ? MiniMusicVisualizer(
                                            color: Colors.red,
                                            width: 4,
                                            height: 15,
                                          )
                                        : Text(
                                            formatedTime(track.durationTrack),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                  }),
                                ],
                              ),
                              onTap: () {
                                _updateSelected(index);
                                setState(() {
                                  stopTrack = true;
                                  assetsAudioPlayer.stop();
                                });

                                if (stopTrack == true) {
                                  setState(() async {
                                    currentTitleTrack = track.titleTrack;
                                    currentImageTrack = track.imageTrack;
                                    currentArtistTrack = artistName;
                                    currentPreviewTrack = track.previewTrack;
                                    stopTrack = false;
                                    playTrack = true;
                                    pauseTrack = false;
                                    assetsAudioPlayer.open(
                                      Audio.network(track.previewTrack),
                                    );
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 0,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end);
                        final curvedAnimation = CurvedAnimation(
                          parent: animation,
                          curve: curve,
                        );
                        return SlideTransition(
                          position: tween.animate(curvedAnimation),
                          child: child,
                        );
                      },
                      child: (!stopTrack) ? bottomMiniPlayer() : SizedBox(),
                    )),
              ],
            ),
    );
  }

  bottomMiniPlayer() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Container(
        width: MediaQuery.of(context).size.width - 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.6), BlendMode.luminosity),
              image: NetworkImage(currentImageTrack)),
        ),
        padding: EdgeInsets.only(left: 7.5, top: 7.5, bottom: 7.5, right: 15),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          currentImageTrack,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(currentTitleTrack,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(
                          currentArtistTrack,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              (!playTrack)
                  ? Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    )
                  : (!pauseTrack)
                      ? Icon(
                          Icons.close,
                          color: Colors.white,
                        )
                      : Text(""),
            ],
          ),
          onTap: () {
            if (playTrack == true) {
              setState(() {
                _index = null;
                stopTrack = true;
                playTrack = false;
                pauseTrack = true;
                assetsAudioPlayer.stop();
              });
            } else {
              setState(() {
                stopTrack = false;
                playTrack = true;
                pauseTrack = false;
                assetsAudioPlayer.play();
              });
            }
          },
        ),
      ),
    );
  }
}
