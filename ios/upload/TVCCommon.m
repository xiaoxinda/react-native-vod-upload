//
//  VCCommon.m
//  VCDemo
//
//  Created by kennethmiao on 16/10/18.
//  Copyright © 2016年 kennethmiao. All rights reserved.
//

#import "TVCCommon.h"

@implementation TVCUploadParam

- (instancetype)init
{
    self = [super init];
    if (self) {
        _videoPath = @"";
        _coverPath = @"";
        _videoName = @"";
    }
    return self;
}

@end

@implementation TVCUploadResponse
@end
