# Triplore

2017 年[爱奇艺最强开发者大赛](https://www.nowcoder.com/activity/iqiyi2017)项目

项目名 __Triplore__ 指 __Trip__ + __Explore__ ，即旅游 + 探险，希望用户能从网络上浩如烟海的的旅游视频之中抽丝剥茧，找到自己想要的信息。并且快速便捷地把这些信息记录、整合，制作成一张自己专属的旅游笔记，以便旅游时查阅。  
<img src="https://github.com/songkuixi/Triplore/blob/master/Img/Logo/Logo2-2.png" width="100px" height="100px"> 

# 预览
<table>
    <tr>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_One.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Two.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Three.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Four.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Five.png"></td>
    </tr>
</table>

# 功能介绍

### 视频模块

1. 首页精选旅游视频，为用户提供旅游灵感。

2. 可以按关键词搜索爱奇艺全网中与旅游相关的视频。

3. 提供热门旅游国家、城市或地区的列表，让用户根据自己的旅游目的地来寻找需要的视频。每个城市下又分为 __美食__ 、 __购物__ 、 __景点__ 三个模块，这是旅游爱好者对目的地最感兴趣的信息。用户可以直接点击进入查看相关视频列表。

4. 可以将视频添加到自己的收藏夹，以供日后翻阅。

5. 播放视频时，可以横放手机来全屏观看，以获得更好的用户体验。

6. 在视频列表中可以上拉刷新，以分页式进行视频获取。

7. 会保存用户的观看历史，帮助用户找到之前观看过却记不住名字的视频。

### 笔记模块

1. 在播放视频（横屏、竖屏均可）时，可以随时 __添加文字笔记__ 或者 __对视频截图__ ，将它们拼接，形成一张旅游笔记。可以选择不同 __模板__ 和 __字体__ （均为免费商用授权）对笔记进行个性化修饰，可以为笔记添加标题。用户制作的笔记均保存在本地。

2. 在播放视频时，可以按录制按钮对视频进行 __录制__ ，并保存到相册。这样可以将视频中较为连续的有用信息存放至手机里，旅游时查看更加方便。
    
    *注：视频版权归原作者/爱奇艺所有，录制到本地的视频仅供个人观看使用，不可作任何商业用途。*

3. 对笔记进行统一管理，可以删除笔记或者修改笔记详情，包括左滑删除笔记某一项、点击编辑文字笔记的内容、长按调整笔记内容的顺序等。如果查阅笔记时觉得有内容需要补充，可以直接进入该笔记对应的视频播放页面，对笔记进行修改。

4. 可以将笔记生成 __高清图片__ 保存至相册，以供打印或者日后查阅。

5. 我们拥有一套用户系统。当用户进行注册、登录后，可以选择对笔记进行 __共享__ ，即上传到服务器，其他用户可以在线查看别人的笔记，进行 __点赞__ 、 __收藏__ ，或 __下载到本地__ ，进行二次修改后保存。

# 安装步骤

1. 下载项目。

2. `cd` 进项目根目录，然后打开终端执行 `pod install`。  

3. 由于其中一个所需的库 `libav.a` [🔗下载地址](http://pan.baidu.com/s/1gfxfyc7)  太大 `(解压后 1.86 GB)`，所以仓库中并不包含它，在项目中需要手动将它拖到 `Triplore/IOSPlayerLib` 中。完成后项目目录（省略细节文件）如下：
    
    ```
    .
    ├── IOSPlayerLib
    │   ├── include
    │   └── libav.a     <------ 放到这里
    ├── Podfile
    ├── Podfile.lock
    ├── Pods
    ├── Triplore
    ├── Triplore.xcodeproj
    ├── Triplore.xcworkspace
    └── TriploreTests
    ```  

4. 开启 `Triplore.xcworkspace`。

5. 现在默认每一个 `Pod Target` 中的 `Build Active Architecture Only` 为 `NO`，但是对于 `FMDB` 需要将其设置为 `YES`（因为 `libav.a` 中也集成了这个第三方库）。

6. 在项目的 `TARGETS -> Triplore -> General -> Linked Frameworks And Libraries` 中手动添加本地路径的 `libav.a`。

7. 本项目使用了 [LeanCloud](https://leancloud.cn) 作为后端，所以代码中需要硬编码进 `App ID` 和 `App Key`。为了安全起见，并未把它们存放在仓库中，所以有些功能如注册、登录不能使用。

8. 按 `Cmd + R` 运行项目。

#### 可能出现的问题

* 若出现与特定 `Pod` 相关的错误，尝试在 `TARGETS -> Triplore -> Build Phases -> Link Binary With Libraries` 中添加对应 `Pod` 库的 `.a` 文件。

* 若出现 `Invalid Bitcode Signing`, 请到最左边 `Pods -> 每一个 Target -> Build Settings` 中搜索 `Bitcode` 将 `Enable Bitcode` 设为 `NO`。

# 其它

感谢以下第三方库及平台

*   [AFNetworking](https://github.com/AFNetworking/AFNetworking)
*   [PYSearch](https://github.com/iphone5solo/PYSearch)
*   [DZNEmptyDataSet](https://github.com/dzenbot/DZNEmptyDataSet)
*   [FMDB](https://github.com/ccgus/fmdb)
*   [SDWebImage](https://github.com/rs/SDWebImage)
*   [SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)
*   [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD)
*   [MJRefresh](https://github.com/CoderMJLee/MJRefresh)
*   [LeanCloud](https://leancloud.cn) 

# 作者

Produced by [songkuixi](https://github.com/songkuixi) and [Sorumi](https://github.com/Sorumi).


