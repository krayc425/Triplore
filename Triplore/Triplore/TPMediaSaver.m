//
//  TPMediaSaver.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/30.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPMediaSaver.h"
#import <Photos/Photos.h>

#define TPAlbumTitle @"Triplore"

@implementation TPMediaSaver

+ (void)checkStatusWithCompletionBlock:(void(^_Nonnull)(BOOL authorized))completionBlock{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied){
        completionBlock(NO);
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            completionBlock(status == PHAuthorizationStatusAuthorized);
        }];
    } else {
        completionBlock(YES);
    }
}

+ (PHAssetCollection *)assetCollection {
    //获取所有相簿
    PHFetchResult *reult = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeAlbum) subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //遍历所有相簿查找名字叫做 TPAlbumTitle 的相簿
    for (PHAssetCollection *collection in reult) {
        //如果有 返回
        if ([collection.localizedTitle isEqualToString:TPAlbumTitle]) {
            return collection;
        }
    }
    //没有则创建
    //相簿的本地标识符
    __block NSString *collectionIdentifier = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        //获取相簿本地标识符
        collectionIdentifier= [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:TPAlbumTitle].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionIdentifier] options:nil].firstObject;
}

+ (void)saveImage:(UIImage *)img withCompletionBlock:(void(^)(BOOL success, NSError *error))completionBlock{
    //图片的本地标识符
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //1,保存图片到系统相册
        assetIdentifier = [PHAssetChangeRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) return ;
        //2,获取相簿
        PHAssetCollection *assetCollection = [self assetCollection];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //3,添加照片
            //获取图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil].firstObject;
            //添加图片的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            //添加图片
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            completionBlock(success, error);
        }];
    }];
}

+ (void)saveVideoAtURL:(NSURL *)url withCompletionBlock:(void(^)(BOOL success, NSError *error))completionBlock{
    // 用来抓取PHAsset的字符串标识
    __block NSString *assetIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //1,保存图片到系统相册
        assetIdentifier = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) return ;
        //2,获取相簿
        PHAssetCollection *assetCollection = [self assetCollection];
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //3,添加视频
            //获取图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetIdentifier] options:nil].firstObject;
            //添加图片的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            //添加视频
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            completionBlock(success, error);
        }];
    }];
}

@end
