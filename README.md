# cropper_and_trimmer

A new Flutter project.

## Screenshot
1. Crop Image


2. Crop/Trim Video


## Getting Started

With this package you can create a post with your text, photos and videos using share extension i.e. when you share data from another app to your app.

Please follow these steps:
1. https://pub.dev/packages/receive_sharing_intent 
    
To show you app in the share sheet, like this:

2. https://pub.dev/packages/url_launcher

To open the link for url, like this:



## iOS Target

This package will work for iOS 13 or later versions.

## iOS plist config

Because the album is a privacy privilege, you need user permission to access it. You must to modify the Info.plist file in Runner project.

``` 
    <key>NSCameraUsageDescription</key>
    <string>Use</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Use</string>
    <key>NSAppleMusicUsageDescription</key>
    <string>Use</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Use</string>
    
``` 

## 1.  Add in pubspec.yaml file under

dependencies:
``` 
 share_extension_flutter:  
   git:  
     url: https://github.com/dinkerkis/share_extension_flutter.git
``` 

## 2. Add package

``` 
import 'package:share_extension_flutter/share_extension_flutter.dart';

``` 


## 3.  Use in the code like this:

``` 
ShareExtensionFlutter(
        shouldShowAppBar: false,
        appBarTitle: "Share Extension Post",
        shouldPreview: true,
        primaryColor: Colors.orange,
        secondaryColor: Colors.black,
        backgroundColor: Colors.white,
        sharedTextColor: Colors.black,
        size: Size(500, 500),
        onCancelPressed: () {

        },
        onDonePressed: (List<SharedMediaFile>? _sharedFiles, String? _sharedText, List<String> _sharedLinks) {

        },
      ),

``` 
##4. Description of arguments and Other benefits

``` 
  final bool shouldShowAppBar; // Do you want to show cancel and done button?
  final String appBarTitle; // It is the app bar title.
  final DonePressed? onDonePressed; //It will be called on done button click and get the final image/video.
  final CancelPressed? onCancelPressed; //It will be called on cancel button click.
  final bool shouldEditable; // Do you want to edit the image/video shared?
  final Color? backgroundColor; //It is the background color, default is white.
  final Color? primaryColor; //It is the primary color, default is black.
  final Color? secondaryColor; //It is the secondary color, default is white.
  final Color? sharedTextColor; //It is the text color for shared text, default is black.
  final bool shouldPreview; // Do want to see the preview after editing.
  final TextStyle? urlTitleStyle; //It is the style for url title.
  final TextStyle? urlDescriptionStyle; //It is the style for url description.
  final TextStyle? urlSiteNameStyle; //It is the style for url site name .
  final Size size; // It is the size of the content.
``` 
