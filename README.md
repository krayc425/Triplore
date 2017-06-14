# Triplore
iQiyi Contest Project

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

* 需要在项目的 `TARGETS -> Triplore -> General -> Linked Frameworks And Libraries` 中手动添加本地路径的 `libav.a`。

* 若出现与特定 `Pod` 相关的错误，尝试在 `TARGETS -> Triplore -> Build Phases -> Link Binary With Libraries` 中添加对应 `Pod` 库的 `.a` 文件。

* 若出现 `Invalid Bitcode Signing`, 请到最左边 `Pods -> 每一个 Target -> Build Settings` 中搜索 `Bitcode` 将 `Enable Bitcode` 设为 `NO`。

* 更换图标在 `TARGETS -> Triplore -> General -> App Icons Source` 中选择。

* 下载项目后，需要 `cd` 进项目根目录，然后打开终端执行 `pod install`。

# Acknowledgement

Produced by [songkuixi](https://github.com/songkuixi) and [Sorumi](https://github.com/Sorumi).


