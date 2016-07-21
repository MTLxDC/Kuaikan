
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "UserInfoManager.h"
#import "GuideViewController.h"
#import <UMMobClick/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _window.rootViewController = [self isFirstOpen] ? [GuideViewController new] : [MainTabBarController new];
    
    [_window makeKeyAndVisible];
    
    [self configUM];
    
    [UserInfoManager autoLogin];

    return YES;
}

- (void)configUM {
    
    [UMConfigInstance setAppKey:@"5790e63967e58e0b0d0037cc"];
     NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
}

- (BOOL)isFirstOpen {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    NSString *key = NSStringFromSelector(_cmd);
    
    BOOL isLastOpen = [ud boolForKey:key];
    
    if (isLastOpen) {
        return NO;
    }else {
        [ud setBool:YES forKey:key];
        return YES;
    }
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
