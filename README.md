# Triplore
iQiyi Contest Project

# Instruction
由于其中一个所需的库 `libav.a` 太过庞大 `(1.86 GB)`，所以仓库中并不包含它，在项目中需要手动将它拖到 `Triplore/IOSPlayerLib` 中，完成后项目目录（省略细节文件）如下：
```Java:
├── Docs
├── README.md
└── Triplore
     ├── IOSPlayerLib
     │   ├── include
     │   │   ├── QYPlayerController.h
     │   │   └── asihttp include
     │   └── libav.a
     ├── Triplore
     └── Triplore.xcodeproj
```  

* 可能需要在项目的 `TARGETS -> Triplore -> General -> Linked Frameworks And Libraries` 中手动添加 `libav.a`
