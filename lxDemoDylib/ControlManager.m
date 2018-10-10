//
//  ControlManager.m
//  LeanCloudDemo
//
//  Created by perfay on 2018/9/4.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "ControlManager.h"
#import <AVOSCloud/AVOSCloud.h>

static ControlManager *shareInstance;

static CGFloat Second_Day = 24 * 60 * 60;


@implementation ControlManager
+ (instancetype) sharInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ControlManager alloc]init];
    });
    return shareInstance;
}
- (BOOL)isPush{
    AVObject *classObject = [AVObject objectWithClassName:@"PushControl"];
    [classObject refresh];
    NSArray *object = [classObject objectForKey:@"results"];
    if (object.count) {
        NSString *isPush = [object[0] objectForKey:@"isPush"];
        if ([isPush isEqualToString:@"1"]) {
            return  YES;
        }
        else{
            return  NO;
        }
    }
    return  NO;
}
- (BOOL)vipIsValidWith:(NSString *)username{
    NSError *error;
    AVUser *user = [AVUser logInWithUsername:username password:@"123456" error:&error];
    user = [AVUser currentUser];
    NSNumber *diff = [user objectForKey:@"diff"];
    NSDate *creatData = user.createdAt;
    NSDate *now = [NSDate date];
    if(now.timeIntervalSince1970 > (creatData.timeIntervalSince1970 + diff.intValue * Second_Day )){
        return NO;
    }
    else{
        return YES;
    }
}
- (BOOL)isEnable{
    NSError *error;
    AVUser *user = [AVUser logInWithUsername:@"123456" password:@"123456" error:&error];
    user = [AVUser currentUser];
    NSNumber *able = [user objectForKey:@"enable"];
    return able.boolValue;
}
- (NSString *)testName{
    AVUser *user = [AVUser currentUser];
    NSString *name = [user objectForKey:@"TestName"];
    return name;
}

@end
