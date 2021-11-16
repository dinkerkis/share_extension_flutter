# share_extension_flutter

A new Flutter project.

## Screenshot
1. Share image/video

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 14 02 28](https://user-images.githubusercontent.com/82141553/141768303-daecea11-1ac3-47b6-8043-3b8978d8c7ab.png) ![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 14 02 31](https://user-images.githubusercontent.com/82141553/141768371-f9f54a82-215f-41b2-8340-1eaa9283b150.png)

2. Share text and view URL

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 13 39 25](https://user-images.githubusercontent.com/82141553/141768135-226f5c3c-3add-45e7-805e-8cc06a50fa84.png)



## Getting Started

With this package you can create a post with your text, photos and videos using share extension i.e. when you share data from another app to your app.

Please follow these steps:
1. https://pub.dev/packages/receive_sharing_intent 
    
To show you app in the share sheet, like this:

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 15 51 20](https://user-images.githubusercontent.com/82141553/141768753-50b2bb80-f405-40b6-9260-afdefa590fab.png) ![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 15 52 18](https://user-images.githubusercontent.com/82141553/141768892-807c2063-ba7e-4877-9820-9c509ecbd4ce.png)

2. https://pub.dev/packages/url_launcher

To open the link for url, like this:

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 15 55 02](https://user-images.githubusercontent.com/82141553/141769176-35e58a1f-f500-41e5-b9b8-f6c0a5ae495b.png)



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
        onCancelPressed: () {

        },
        onDonePressed: (List<SharedMediaFile>? _sharedFiles, String? _sharedText, List<String> _sharedLinks) {

        },
      ),

``` 

## 4. Description of arguments and Other benefits

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

1. shouldShowAppBar = true

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 16 24 42](https://user-images.githubusercontent.com/82141553/141769912-edb4f800-3561-4422-ba35-f2aa638aaa4d.png)

2. size = Size(500, 500)

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 14 24 42](https://user-images.githubusercontent.com/82141553/141770083-eb4041c2-fc69-481a-8e37-065c21d71408.png) ![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 14 24 53](https://user-images.githubusercontent.com/82141553/141770128-115d8ddb-6a35-4438-8acd-9b7319a4f96f.png)

3. shouldEditable = true

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 13 46 07](https://user-images.githubusercontent.com/82141553/141770393-3e069d17-d13d-4f1d-9c39-d0dded942bfd.png)

4. shouldPreview = true

![Simulator Screen Shot - iPhone 12 Pro Max - 2021-11-15 at 16 29 19](https://user-images.githubusercontent.com/82141553/141770550-cd2c3c0c-31de-420c-b9aa-7ac1d1eba674.png)

## 5. Errors??

Please check the dependencies in pubspec.yaml file and check their implementation one by one. Espacially, 
receive_sharing_intent: any
url_launcher: any

Hope it helps in development.



