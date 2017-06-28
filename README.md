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
1. 下载项目。

2. `cd` 进项目根目录，然后打开终端执行 `pod install`。  

3. 由于其中一个所需的库 `libav.a` [🔗下载地址](http://pan.baidu.com/s/1gfxfyc7)  太大 `(1.86 GB)`，所以仓库中并不包含它，在项目中需要手动将它拖到 `Triplore/IOSPlayerLib` 中。完成后项目目录（省略细节文件）如下：
    
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

#### 其他

* 更换图标在 `TARGETS -> Triplore -> General -> App Icons Source` 中选择。

# Acknowledgement

Produced by [songkuixi](https://github.com/songkuixi) and [Sorumi](https://github.com/Sorumi).


