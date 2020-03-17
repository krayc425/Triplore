<img src="https://github.com/songkuixi/Triplore/blob/master/Img/Logo/Logo2-2.png" width="100px" height="100px"> 

# Triplore (English)

This project was submitted for the [2017 iQiyi National Programming Contest](https://www.nowcoder.com/activity/iqiyi2017) and won the **First Prize** and **Best Individual**.

The name **Triplore** is the combination of **Trip** and **Explore**, hoping it can help users grab useful information from massive online videos, and combine these information into a piece of note which can be reviewed when travelling.

# Instruction【Important】

Unfortunately, the video player library `libav.a` provided by iQiyi is in 32 bit architecture and Apple requires that all apps are compiled under 64 bit architecture, so this project **can not** run very much likely. Please just refer to the source code and idea.

# Preview

<table>
    <tr>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_One.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Two.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Three.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Four.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Five.png"></td>
    </tr>
</table>

# Introduction

### Video 

##### Video List

1. Provide selected travelling videos on homepage, to help users find inspiration.

2. Search all videos related to travelling provided by iQiyi.

3. Offer list of popular travelling destinations, including cities and countries. It is divided into "Food", "Shopping" and "Scene" categories so that users can pick what they want directly.

4. Add videos into their "Favorites".

5. Pull to refresh in video list, getting videos by pages.

6. Save user's "Watch history", helping users find videos they have watched.

##### Player

1. Put phone in landscape mode to watch video in full screen mode.

2. Swipe up and down in the left / right part of the player to adjust brightness / volume. 
 
3. There is a control pnael on player view, which has following functions:

### Notes

1. When playing videos, use control panel to **take a screenshot" or "add annotations"**, and combine them to a travelling note.

2. Use different templates and fonts to decorate the note.

3. When playing videos, use control panel to **record** a clip of video and save to local albums.

4. Edit / delete notes, including swipe left to delete an item in note, click to edit annotations, press long to adjust note item orders. When reading notes, users can go to player to watch the video again and edit the note.

5. Convert note into a high resolution picture and save to album.

6. After signing in, users can share notes on our server, others can see other's notes and mark them as "Like".

# Setup

**Testing on a real device is highly recommended.**

1. Download this repo.

2. Because one of the library provided by iQiyi `libav.a` is too big（`1.86 GB` after unzipping），we need to download it from [🔗Download](http://pan.baidu.com/s/1gfxfyc7)  and drag it to following place.
    
    ```
    .
    ├── IOSPlayerLib
    │   ├── include
    │   └── libav.a     <------ HERE
    ├── Podfile
    ├── Podfile.lock
    ├── Pods
    ├── Triplore
    ├── Triplore.xcodeproj
    ├── Triplore.xcworkspace
    └── TriploreTests
    ```  

3. Open `Triplore.xcworkspace` and press `Cmd + R` to run。

#### FAQ

##### Error related to 3rd party libraries

* Add corresponding `.a` in `TARGETS -> Triplore -> Build Phases -> Link Binary With Libraries`.

##### `Invalid Bitcode Signing`

* Set every `Enable Bitcode` to `NO` in `Pods -> EVERY Target -> Build Settings`.

##### `libav.a` Not Found

* Add `libav.a` on your local machine in `TARGETS -> Triplore -> General -> Linked Frameworks And Libraries`.

# Others

Thanks to following 3rd party libraries / platforms (in alphabetical order)

*   [AFNetworking](https://github.com/AFNetworking/AFNetworking)
*   [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)
*   [FMDB](https://github.com/ccgus/fmdb)
*   [LeanCloud](https://leancloud.cn) 
*   [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
*   [PYSearch](https://github.com/iphone5solo/PYSearch)
*   [SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)
*   [SDWebImage](https://github.com/rs/SDWebImage)
*   [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
*   [TYPagerController](https://github.com/12207480/TYPagerController)

# Author

Produced by [songkuixi](https://github.com/songkuixi) and [Sorumi](https://github.com/Sorumi) with <3.
