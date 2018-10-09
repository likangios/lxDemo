//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  lxDemoDylib.m
//  lxDemoDylib
//
//  Created by perfay on 2018/10/8.
//  Copyright (c) 2018年 perfay. All rights reserved.
//

#import "lxDemoDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import <AVOSCloud/AVOSCloud.h>
#import "ControlManager.h"
CHConstructor{
    NSLog(INSERT_SUCCESS_WELCOME);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
#ifndef __OPTIMIZE__
        CYListenServer(6666);

        MDCycriptManager* manager = [MDCycriptManager sharedInstance];
        [manager loadCycript:NO];

        NSError* error;
        NSString* result = [manager evaluateCycript:@"UIApp" error:&error];
        NSLog(@"result: %@", result);
        if(error.code != 0){
            NSLog(@"error: %@", error.localizedDescription);
        }
#endif
        
    }];
}


CHDeclareClass(CustomViewController)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

//add new method
CHDeclareMethod1(void, CustomViewController, newMethod, NSString*, output){
    NSLog(@"This is a new method : %@", output);
}

#pragma clang diagnostic pop

CHOptimizedClassMethod0(self, void, CustomViewController, classMethod){
    NSLog(@"hook class method");
    CHSuper0(CustomViewController, classMethod);
}

CHOptimizedMethod0(self, NSString*, CustomViewController, getMyName){
    //get origin value
    NSString* originName = CHSuper(0, CustomViewController, getMyName);
    
    NSLog(@"origin name is:%@",originName);
    
    //get property
    NSString* password = CHIvar(self,_password,__strong NSString*);
    
    NSLog(@"password is %@",password);
    
    [self newMethod:@"output"];
    
    //set new property
    self.newProperty = @"newProperty";
    
    NSLog(@"newProperty : %@", self.newProperty);
    
    //change the value
    return @"perfay";
    
}

//add new property
CHPropertyRetainNonatomic(CustomViewController, NSString*, newProperty, setNewProperty);

CHConstructor{
    CHLoadLateClass(CustomViewController);
    CHClassHook0(CustomViewController, getMyName);
    CHClassHook0(CustomViewController, classMethod);
    
    CHHook0(CustomViewController, newProperty);
    CHHook1(CustomViewController, setNewProperty);
}

CHDeclareClass(LXPlayerViewController)

CHOptimizedMethod0(self, void, LXPlayerViewController, playerViewBeginPlay){
    CHSuper(0, LXPlayerViewController, playerViewBeginPlay);
    UIView * playerView = CHIvar(self,_playerView,__strong UIView*);
    NSObject *ijk = [playerView valueForKeyPath:@"_ijkPlayer"];
    UIView *glview = [ijk valueForKeyPath:@"_glView"];
    UIView *osdView = [glview valueForKeyPath:@"_osdView"];
    UILabel *label = [osdView valueForKeyPath:@"label"];
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"lxkey"];
    if(number.integerValue >= 2){
        label.hidden = YES;
    }
    NSLog(@"%@",label);
}

CHConstructor{
    CHLoadLateClass(LXPlayerViewController);
    CHClassHook0(LXPlayerViewController, playerViewBeginPlay);
}
CHDeclareClass(AppDelegate)

CHOptimizedMethod2(self, BOOL, AppDelegate, application,BOOL,arg1,didFinishLaunchingWithOptions,id,arg2){
   BOOL rect =  CHSuper2(AppDelegate, application,arg1,didFinishLaunchingWithOptions,arg2);
    [AVOSCloud setApplicationId:@"iCwzb9JMlNGgyNSG2rgVv9xW-gzGzoHsz" clientKey:@"F7WBhL9y43p04QAHbsUkYx3B"];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"lxkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return rect;
}

CHConstructor{
    CHLoadLateClass(AppDelegate);
    CHClassHook2(AppDelegate, application,didFinishLaunchingWithOptions);
}

CHDeclareClass(LXAboutController)

CHOptimizedMethod0(self, BOOL, LXAboutController, viewDidLoad){
     CHSuper0(LXAboutController,viewDidLoad);
    BOOL  valid = [[ControlManager sharInstance] isEnable];
    if(valid){
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"lxkey"];
        [[NSUserDefaults standardUserDefaults] setObject:@(number.integerValue + 1) forKey:@"lxkey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

CHConstructor{
    CHLoadLateClass(LXAboutController);
    CHClassHook0(LXAboutController, viewDidLoad);
}


/*
CHDeclareClass(LXProductCourseTabController)

CHOptimizedMethod5(self, void, LXProductCourseTabController, courseItemReactiveActionWith,id,arg1,andCourseID,id,arg2,andActionType,int,arg3,andLevel,id,arg4,model,id,arg5){
CHSuper5(LXProductCourseTabController,courseItemReactiveActionWith,arg1,andCourseID,arg2,andActionType,arg3,andLevel,arg4,model,arg5);

}
CHOptimizedMethod0(self, BOOL, LXProductCourseTabController, openAuth){
    BOOL rect = CHSuper0(LXProductCourseTabController, openAuth);
    return YES;
//    return  rect;
}
CHOptimizedMethod5(self, void, LXProductCourseTabController, authUserResutlStatus,int,arg1,adModel,id,arg2,videoModel,id,arg3,cellModel,id,arg4,cardID,id,arg5){

    CHSuper5(LXProductCourseTabController,authUserResutlStatus,arg1,adModel,arg2,videoModel,arg3,cellModel,arg4,cardID,arg5);
    
}
CHConstructor{
    CHLoadLateClass(LXProductCourseTabController);
    CHClassHook5(LXProductCourseTabController, courseItemReactiveActionWith,andCourseID,andActionType,andLevel,model);
    CHClassHook5(LXProductCourseTabController, authUserResutlStatus,adModel,videoModel,cellModel,cardID);
    CHClassHook0(LXProductCourseTabController,openAuth);
}
*/




