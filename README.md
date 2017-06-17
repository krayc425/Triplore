# Triplore
iQiyi Contest Project  
<img src="https://github.com/songkuixi/Triplore/blob/master/Img/Logo/Logo2-2.png" width="100px" height="100px"> 

# Preview
<table>
    <tr>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_One.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Two.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Three.png"></td>
        <td><img src="https://github.com/songkuixi/Triplore/blob/master/Img/Intro/Intro_Screen_Four.png"></td>
    </tr>
</table>

# Instruction
* 由于其中一个所需的库 `libav.a` 太过庞大 `(1.86 GB)`，所以仓库中并不包含它，在项目中需要手动将它拖到 `Triplore/IOSPlayerLib` 中，完成后项目目录（省略细节文件）如下：
    
```
.
├── IOSPlayerLib
│   ├── include
│   └── libav.a
├── Podfile
├── Podfile.lock
├── Pods
├── Triplore
├── Triplore.xcodeproj
├── Triplore.xcworkspace
└── TriploreTests
```  

* 下载项目后，`cd` 进项目根目录，然后打开终端执行 `pod install`。然后开启 `Triplore.xcworkspace` 运行项目。

* 现在默认每一个 `Pod Target` 中的 `Build Active Architecture Only` 为 `NO`，但是对于 `FMDB` 需要将其设置为 `YES`（因为 `libav.a` 中也集成了这个第三方库）。

* 需要在项目的 `TARGETS -> Triplore -> General -> Linked Frameworks And Libraries` 中手动添加本地路径的 `libav.a`。

* 若出现与特定 `Pod` 相关的错误，尝试在 `TARGETS -> Triplore -> Build Phases -> Link Binary With Libraries` 中添加对应 `Pod` 库的 `.a` 文件。

* 若出现 `Invalid Bitcode Signing`, 请到最左边 `Pods -> 每一个 Target -> Build Settings` 中搜索 `Bitcode` 将 `Enable Bitcode` 设为 `NO`。

* 更换图标在 `TARGETS -> Triplore -> General -> App Icons Source` 中选择。


# Acknowledgement

Produced by [songkuixi](https://github.com/songkuixi) and [Sorumi](https://github.com/Sorumi).


