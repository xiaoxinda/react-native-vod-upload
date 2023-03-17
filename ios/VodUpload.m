// VodUpload.m

#import "VodUpload.h"
#import "TXUGCPublish.h"

@implementation VodUpload
{
    TXUGCPublish     *_videoPublish;
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"onPublishProgress",@"onPublishComplete",@"onPublishEvent",@"onMediaPublishProgress",@"onMediaPublishComplete",@"onMediaPublishEvent"];
}

/**
* 初始化
*/
RCT_EXPORT_METHOD(_init)
{
    _videoPublish = [[TXUGCPublish alloc] initWithUserID:@"yisha_ios"];
}

/**
* 上传视频
* @param paramObj 参数
* @param resolve
* @param reject
*/
RCT_EXPORT_METHOD(startPublishVideo:(NSDictionary *)paramObj
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject
){
      TXPublishParam *publishParam = [[TXPublishParam alloc] init];
      if(![paramObj objectForKey:@"signature"] || [paramObj[@"signature"] isEqualToString:@""]){
           return reject(@"fail",@"签名信息signature不能为空",nil);
      }

      if(![paramObj objectForKey:@"videoPath"] || [paramObj[@"videoPath"] isEqualToString:@""]){
           return reject(@"fail",@"视频地址videoPath不能为空",nil);
      }

      if(![paramObj objectForKey:@"fileName"] || [paramObj[@"fileName"] isEqualToString:@""]){
           return reject(@"fail",@"视频文件名称是必传的",nil);
      }

      publishParam.signature  = paramObj[@"signature"]; //签名
      publishParam.videoPath  = paramObj[@"videoPath"]; //视频地址
      publishParam.fileName = paramObj[@"fileName"]; //视频文件名称
      if([paramObj objectForKey:@"coverPath"] && ![paramObj[@"coverPath"] isEqualToString:@""]){
           publishParam.coverPath = paramObj[@"coverPath"];//封面
      }

      if([paramObj objectForKey:@"enableResume"]){
           publishParam.enableResume = [paramObj[@"enableResume"] boolValue] ? YES : NO;//是否启动断点续传，默认开启
      }

      if([paramObj objectForKey:@"enablePreparePublish"]){
           publishParam.enablePreparePublish = [paramObj[@"enablePreparePublish"] boolValue] ? YES : NO;//是否开启预上传机制，默认开启，备注：预上传机制可以大幅提升文件的上传质量
      }

      if([paramObj objectForKey:@"concurrentCount"]){
           publishParam.concurrentCount = [paramObj[@"concurrentCount"] longValue];// 分片上传并发数量，<=0 则表示SDK内部默认为2个
      }

      int startPublishStatus =[_videoPublish publishVideo:publishParam];
      if(startPublishStatus == 0){
           resolve(@"操作成功");
      }
}

/**
* 上传图片
* @param paramObj 参数
* @param resolve
* @param reject
*/
RCT_EXPORT_METHOD(startPublishMedia:(NSDictionary *)paramObj
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject
){
      TXMediaPublishParam *publishParam = [[TXMediaPublishParam alloc] init];
      if(![paramObj objectForKey:@"signature"] || [paramObj[@"signature"] isEqualToString:@""]){
           return reject(@"fail",@"签名信息signature不能为空",nil);
      }

      if(![paramObj objectForKey:@"mediaPath"] || [paramObj[@"mediaPath"] isEqualToString:@""]){
           return reject(@"fail",@"图片地址mediaPath不能为空",nil);
      }

      if(![paramObj objectForKey:@"fileName"] || [paramObj[@"fileName"] isEqualToString:@""]){
           return reject(@"fail",@"图片文件名称是必传的",nil);
      }

      publishParam.signature  = paramObj[@"signature"]; //签名
      publishParam.mediaPath  = paramObj[@"mediaPath"]; //图片地址
      publishParam.fileName = paramObj[@"fileName"]; //图片文件名称

      if([paramObj objectForKey:@"enableResume"]){
           publishParam.enableResume = [paramObj[@"enableResume"] boolValue] ? YES : NO;//是否启动断点续传，默认开启
      }

      if([paramObj objectForKey:@"enablePreparePublish"]){
           publishParam.enablePreparePublish = [paramObj[@"enablePreparePublish"] boolValue] ? YES : NO;//是否开启预上传机制，默认开启，备注：预上传机制可以大幅提升文件的上传质量
      }

      if([paramObj objectForKey:@"concurrentCount"]){
           publishParam.concurrentCount = [paramObj[@"concurrentCount"] longValue];// 分片上传并发数量，<=0 则表示SDK内部默认为2个
      }

      int startPublishStatus =[_videoPublish publishMedia:publishParam];
      if(startPublishStatus == 0){
           resolve(@"操作成功");
      }
}

//设置视频上传回调
RCT_EXPORT_METHOD(setVideoCallback)
{
    _videoPublish.delegate = self;
}

//设置图片上传回调
RCT_EXPORT_METHOD(setMediaCallback)
{
    _videoPublish.mediaDelegate = self;
}

//视频上传回调
#pragma mark - TXVideoPublishListener

- (void)onPublishProgress:(NSInteger)uploadBytes totalBytes:(NSInteger)totalBytes {
    [self sendEventWithName:@"onPublishProgress" body:@{@"uploadBytes":[NSNumber numberWithInteger:uploadBytes],@"totalBytes":[NSNumber numberWithInteger:totalBytes]}];
}
- (void)onPublishComplete:(TXPublishResult*)result {
    NSString *string = [NSString stringWithFormat:@"上传完成，错误码[%d]，信息[%@]", result.retCode, result.retCode == 0? result.videoURL: result.descMsg];
    [self sendEventWithName:@"onPublishComplete" body:string];
}
- (void)onPublishEvent:(NSDictionary*)evt {
    [self sendEventWithName:@"onPublishEvent" body:evt];
}



//图片上传回调
#pragma mark - TXMediaPublishListener

- (void)onMediaPublishProgress:(NSInteger)uploadBytes totalBytes: (NSInteger)totalBytes {
    [self sendEventWithName:@"onMediaPublishProgress" body:@{@"uploadBytes":[NSNumber numberWithInteger:uploadBytes],@"totalBytes":[NSNumber numberWithInteger:totalBytes]}];
}
- (void)onMediaPublishComplete:(TXMediaPublishResult*)result {
    NSString *string = [NSString stringWithFormat:@"上传完成，错误码[%d]，信息[%@]", result.retCode, result.retCode == 0? result.mediaURL: result.descMsg];
    [self sendEventWithName:@"onMediaPublishComplete" body:string];
}
- (void)onMediaPublishEvent:(NSDictionary*)evt {
    [self sendEventWithName:@"onMediaPublishEvent" body:evt];
}

@end
