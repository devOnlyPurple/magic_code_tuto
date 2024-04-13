// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/conseil.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class ConseilDetails extends StatefulWidget {
  ConseilDetails({
    super.key,
    required this.unConseil,
    required this.userResponse,
    required this.onLike,
    required this.onShare,
    required this.onSave,
  });
  Conseil? unConseil;
  User? userResponse;
  dynamic Function(String keyconseil) onLike;
  dynamic Function(String keyconseil) onShare;
  dynamic Function(String keyconseil) onSave;
  @override
  State<ConseilDetails> createState() => _ConseilDetailsState();
}

class _ConseilDetailsState extends State<ConseilDetails> {
  final audioPlayer = AudioPlayer(); // Create a player
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late FlickManager flickManager;
  late VideoPlayerController audioPlayerController;
  ChewieAudioController? chewieController;
  void _initAudioPlayer() async {
    audioPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.unConseil!.media!));

    await audioPlayerController.initialize();

    setState(() {});

    chewieController = ChewieAudioController(
        materialProgressColors: ChewieProgressColors(
          playedColor: Kprimary, // Couleur jaune pour la barre de progression
          handleColor: Colors
              .grey, // Couleur jaune pour la poignée de la barre de progression
          // Couleur jaune avec opacité pour la partie tamponnée de la barre de progression
          backgroundColor:
              Ksecondary, // Couleur de fond de la barre de progression
        ),
        videoPlayerController: audioPlayerController,
        autoPlay: false,
        looping: false,
        autoInitialize: true);
  }

  void _initVideoPlayer() async {
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
            Uri.parse(widget.unConseil!.media!)),
        autoPlay: false);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switch (widget.unConseil!.typeMedia!) {
      case 2:
        _initVideoPlayer();
        break;
      case 3:
        _initAudioPlayer();
        break;
      default:
    }
  }

  @override
  void dispose() {
    if (widget.unConseil!.typeMedia == 2) {
      flickManager.dispose();
    } else if (widget.unConseil!.typeMedia == 3) {
      audioPlayerController.dispose();
      chewieController!.dispose();
    }

    super.dispose();
  }

  Future setAudio() async {
    // Repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
          ),
        ),
        title: const Text(
          "Fiche de conseil",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: const Icon(Icons.calendar_month),
          ),
          const SizedBox(
            width: 10,
          ),
          
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              widget.unConseil!.typeMedia == 1
                  ? imageMethod(size)
                  : const SizedBox(),
              widget.unConseil!.typeMedia == 2
                  ? videoMethod()
                  : const SizedBox(),
              widget.unConseil!.typeMedia == 3
                  ? audioMethod()
                  : const SizedBox(),
              Br10(),
              titleAndMore(),
              Br30(),
              Html(
                data: widget.unConseil!.description!,
                style: {
                  'html': Style(textAlign: TextAlign.justify),
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Center audioMethod() {
    return Center(
      child: chewieController != null
          ? ChewieAudio(controller: chewieController!)
          : const CardLoading(
              height: 50,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
    );
  }

  Center videoMethod() {
    return Center(child: FlickVideoPlayer(flickManager: flickManager));
  }

  SizedBox imageMethod(Size size) {
    return SizedBox(
      width: size.width,
      child: CachedNetworkImage(
        imageUrl: widget.unConseil!.media!,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CardLoading(
          height: 250,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        errorWidget: (context, url, error) => const CardLoading(
          height: 250,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }

  Widget titleAndMore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.unConseil!.titre!,
          softWrap: true,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Kprimary, fontSize: 20),
        ),
        Br5(),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/user.svg',
              height: 15,
              color: kBlack,
            ),
            const SizedBox(width: 3),
            Text(
              widget.unConseil!.expert!.name!,
              softWrap: true,
              style: TextStyle(color: kBlack),
            ),
          ],
        ),
        Br10(),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  if (widget.unConseil!.isLike == 1) {
                    widget.unConseil!.allLike =
                        (widget.unConseil!.allLike ?? 0) -
                            1; // Incrémenter le nombre de likes
                    widget.unConseil!.isLike =
                        0; // Mettre à jour l'état de liking
                  } else {
                    widget.unConseil!.allLike =
                        (widget.unConseil!.allLike ?? 0) +
                            1; // Décrémenter le nombre de likes
                    widget.unConseil!.isLike =
                        1; // Mettre à jour l'état de liking
                  }
                });
                // _likeDislikeConseil(
                //     uneCategorieConseil.keyConseil!);
                widget.onLike(widget.unConseil!.keyConseil!);
              },
              child: SizedBox(
                child: Row(
                  children: [
                    Icon(
                      widget.unConseil!.isLike == 1
                          ? Icons.favorite
                          : Icons.favorite_outline_outlined,
                      size: 18,
                      color:
                          widget.unConseil!.isLike == 1 ? kRed : Colors.black,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text((widget.unConseil!.allLike).toString())
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () async {
                try {
                  // Appel de la méthode Share.share pour partager le lien
                  await Share.share(widget.unConseil!.shareLink!);

                  print("L'utilisateur a partagé l'actualité");
                } catch (e) {
                  // En cas d'erreur lors du partage
                  print("Erreur lors du partage : $e");
                } finally {
                  widget.onShare(widget.unConseil!.keyConseil!);
                  setState(() {
                    widget.unConseil!.shares =
                        (widget.unConseil!.shares ?? 0) + 1;
                  });
                }
              },
              child: SizedBox(
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 18,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(widget.unConseil!.shares.toString())
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                setState(() {
                  if (widget.unConseil!.isSave == 1) {
                    widget.unConseil!.isSave = 0;
                  } else {
                    widget.unConseil!.isSave = 1;
                  }
                });
                widget.onSave(widget.unConseil!.keyConseil!);
              },
              child: Icon(
                widget.unConseil!.isSave == 1
                    ? Icons.bookmark
                    : Icons.bookmark_border_outlined,
                size: 18,
                color: widget.unConseil!.isSave == 1 ? Kprimary : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
