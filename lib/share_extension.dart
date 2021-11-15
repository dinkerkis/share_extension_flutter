import 'dart:io';

import 'package:cropper_and_trimmer/cropper_and_trimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:share_extension_flutter/video_widget.dart';
import 'package:simple_url_preview/simple_url_preview.dart';
import 'package:url_launcher/url_launcher.dart';

Color backgroundColor = Colors.white;
Color primaryColor = Colors.black;
Color secondaryColor = Colors.white;
Color sharedTextColor = Colors.black;
TextStyle urlTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor,);
TextStyle urlDescriptionStyle = TextStyle(fontSize: 14, color: primaryColor,);
TextStyle urlSiteNameStyle = TextStyle(fontSize: 14,color: primaryColor,);

typedef DonePressed = void Function(List<SharedMediaFile>? _sharedFiles, String? _sharedText, List<String> _sharedLinks);
typedef CancelPressed = void Function();

class ShareExtensionFlutter extends StatefulWidget {

  final bool shouldShowAppBar;
  final String appBarTitle;
  final DonePressed? onDonePressed;
  final CancelPressed? onCancelPressed;
  final bool shouldEditable;
  final Color? backgroundColor;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? sharedTextColor;
  final bool shouldPreview;
  final TextStyle? urlTitleStyle;
  final TextStyle? urlDescriptionStyle;
  final TextStyle? urlSiteNameStyle;
  final Size size;

  ShareExtensionFlutter({Key? key,
    this.shouldShowAppBar = false,
    this.appBarTitle = '',
    this.onDonePressed,
    this.onCancelPressed,
    this.shouldEditable = true,
    this.shouldPreview = false,
    this.backgroundColor,
    this.primaryColor,
    this.secondaryColor,
    this.sharedTextColor,
    this.urlTitleStyle,
    this.urlDescriptionStyle,
    this.urlSiteNameStyle,
    this.size = Size.zero
  });

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ShareExtensionFlutter> {
  Size _screen = Size.zero;
  late StreamSubscription _intentDataStreamSubscription;
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;
  List<String> _sharedLinks = [];
  var isExpanded = true;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        _sharedText = null;
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      setState(() {
        _sharedFiles = value;
        _sharedText = null;
        print("Shared:" + (_sharedFiles?.map((f) => f.path).join(",") ?? ""));
      });
    });

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
          setState(() {
            _sharedText = value;
            print("Shared: $_sharedText");
            _sharedFiles = null;
            checkUrl();
          });
        }, onError: (err) {
          print("getLinkStream error: $err");
        });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
        print("Shared: $_sharedText");
        _sharedFiles = null;
        checkUrl();
      });
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void checkUrl() async{
    var sharedText = _sharedText ?? '';

    RegExp exp = new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(sharedText);

    _sharedLinks = [];
    matches.forEach((match) {
      var link = sharedText.substring(match.start, match.end) ;

      if (!(link.startsWith('https://') || link.startsWith('http://') )) {
        link = 'https://' + link;
      }
      print(link);
      addLink(link);
    });

  }

  Future<void> addLink(String url) async {
    if (await canLaunch(url)) {
      _sharedLinks.add(url);
    }

    setState(() {

    });
  }

  void _launchURL(_url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  Widget build(BuildContext context) {

    _screen = widget.size != Size.zero ? widget.size : MediaQuery.of(context).size;
    backgroundColor = widget.backgroundColor ?? Colors.white;
    primaryColor = widget.primaryColor ?? Theme.of(context).primaryColorDark;
    secondaryColor = widget.secondaryColor ?? Theme.of(context).primaryColorLight;
    sharedTextColor = widget.sharedTextColor ?? Colors.black;

    urlTitleStyle = widget.urlTitleStyle ?? TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: sharedTextColor,);
    urlDescriptionStyle = widget.urlDescriptionStyle ?? TextStyle(fontSize: 14, color: sharedTextColor,);
    urlSiteNameStyle = widget.urlSiteNameStyle ?? TextStyle(fontSize: 14,color: sharedTextColor,);

    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: widget.shouldShowAppBar ? AppBar(
          backgroundColor: primaryColor,
          leadingWidth: 100,
          leading: FlatButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: secondaryColor,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.onCancelPressed != null ) {
                widget.onCancelPressed;
              }
            },
          ),
          title: Text(widget.appBarTitle, style: TextStyle(
              color: secondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),),
          actions: [
            FlatButton(
              child: Text(
                'Done',
                style: TextStyle(
                    color: secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                if (widget.onDonePressed != null ) {
                  widget.onDonePressed!(_sharedFiles, _sharedText, _sharedLinks);
                }
              },
            ),
          ],
        ) : AppBar(backgroundColor: primaryColor,
          title: Text(widget.appBarTitle, style: TextStyle(
              color: secondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold
          ),),),
        body: SafeArea(child: Container(
          height: _screen.height,
          width: _screen.width,
          child:
          _sharedFiles != null ?
          PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sharedFiles?.length,
              itemBuilder: (context, index) {
                var item = _sharedFiles?[index];
                String type = item?.type.toString().replaceFirst(
                    "SharedMediaType.", "") ?? '';
                var path = item?.path ?? '';

                if (type.toLowerCase().contains('image') &&
                    path.isNotEmpty) {
                  return _imageView(path, index);
                }
                else if (type.toLowerCase().contains('video') &&
                    path.isNotEmpty) {

                  return _videoView(path, index);
                }
                return Container();
              }) :
          SingleChildScrollView(
              child: _sharedText != null ?
              _textView():
              Center(
                child: Text('Nothing shared Yet!', style: TextStyle(color: sharedTextColor),),
              )
          ),
        )
        )
    );
  }

  Widget _imageView(String path, int index) {
    return Container(
      // height: 500,
      //width: _screen.width,
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.file(File(path),
              fit: isExpanded ? BoxFit.cover : BoxFit
                  .contain,),
          ),
          _countView(_sharedFiles?.length ?? 0, index),
          widget.shouldEditable ? Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  _circularStackButton(
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CropperAndTrimmer(
                                    file: File(path),
                                    shouldPreview: widget.shouldPreview,
                                    primaryColor: primaryColor,
                                    secondaryColor: secondaryColor,
                                    backgroundColor: backgroundColor,
                                    fileType: FileType.image,
                                    onImageUpdated: (file) {
                                      _sharedFiles?[index] = SharedMediaFile(file.path, null, null, SharedMediaType.IMAGE);

                                      setState(() {

                                      });
                                    },
                                  ),
                              fullscreenDialog: true),
                        );
                      }),
                  SizedBox(width: 20),
                  _circularStackButton(
                      icon: Icons.expand, onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  }),
                ],
              ),
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget _videoView(String path, int index) {
    var file = File(path);

    return Container(
        height: _screen.height,
        width: _screen.width,
        color: backgroundColor,
        child: Stack(
            children: <Widget>[
              Center(child:
              VideoWidget(file: file,
                showProgressBar: false,
                showProgressText: false,),
              ),
              _countView(_sharedFiles?.length ?? 0, index),
              widget.shouldEditable ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                      _circularStackButton(
                          icon: Icons.edit, onTap: () {

                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CropperAndTrimmer(
                                    file: File(path),
                                    shouldPreview: widget.shouldPreview,
                                    primaryColor: primaryColor,
                                    secondaryColor: secondaryColor,
                                    backgroundColor: backgroundColor,
                                    fileType: FileType
                                        .video,
                                    onVideoUpdated: (file) {
                                      _sharedFiles?[index] = SharedMediaFile(file.path, null, null, SharedMediaType.VIDEO);
                                      setState(() {

                                      });

                                    },
                                  ),
                              fullscreenDialog: true),
                        );
                      }),
                    ],
                  ),
                ),
              ) : Container(),
            ]
        )
    );
  }

  Widget _textView() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
            children: [
              Text(_sharedText ?? "", style: TextStyle(color: sharedTextColor),),
              SizedBox(height: 20,),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _sharedLinks.length,
                  itemExtent: 130,
                  itemBuilder: (context, index) {
                    return SimpleUrlPreview(
                      url: _sharedLinks[index],
                      bgColor: Colors.white,
                      isClosable: widget.shouldEditable,
                      titleLines: 2,
                      descriptionLines: 3,
                      imageLoaderColor: secondaryColor,
                      //previewHeight: 150,
                      previewContainerPadding: EdgeInsets.all(10),
                      onTap: () {
                        print('Hello Flutter URL Preview');
                        _launchURL(_sharedLinks[index]);
                      },
                      titleStyle: urlTitleStyle,
                      descriptionStyle: urlDescriptionStyle,
                      siteNameStyle: urlSiteNameStyle,
                    );
                  }),
            ])
    );
  }

  Widget _countView(int total, int index) {

    if (total == 1) {
      return Container();
    }

    return Align(
        alignment: Alignment.topRight,
        child: Container(
            decoration: BoxDecoration(shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                color: primaryColor),
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            child: Text('${index + 1}/${total}',
                style: TextStyle(color: secondaryColor))
        )
    );
  }

  Widget _circularStackButton({
    required IconData icon,
    String? text,
    required Function() onTap
  }) {
    return InkWell(
        onTap: ()  {
          if (onTap != null) {
            onTap();
          }
        },
        child:
        text == null ?
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Icon(
              icon,
              color: secondaryColor,
            ),
          ),
        ):
        Container(
          margin: EdgeInsets.only(left: 5),
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 36,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: secondaryColor),
                SizedBox(width: 10),
                Text(
                  text,
                  style: TextStyle(color: secondaryColor, fontSize: 12),
                )
              ],
            ),
          ),
        )
    );
  }
}

