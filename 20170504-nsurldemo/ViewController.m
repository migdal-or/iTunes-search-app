//
//  ViewController.m
//  20170504-nsurldemo
//
//  Created by iOS-School-1 on 04/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *cachePath = [cacheDirectory stringByAppendingPathComponent:@"MyCache"];
//    NSURLCache
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration];
    NSURL *url = [NSURL URLWithString:@"https://www.google.com"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"got response %@ with error %@.\n", response, error);
        NSString *responseStr = [[NSString alloc] initWithData:data encoding:NSWindowsCP1251StringEncoding];
        NSLog(@"data: %@", responseStr);
    }];
    [task resume];
}

@end
