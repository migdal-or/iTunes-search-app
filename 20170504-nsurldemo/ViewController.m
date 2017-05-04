//
//  ViewController.m
//  20170504-nsurldemo
//
//  Created by iOS-School-1 on 04/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL *image = [NSURL URLWithString:@"https://yabs.yandex.ru/count/Ctvl2lqgMdu40000gP0088wpxBMG1L6L0fi7QfI8lHyd1mU92QQ42Ogpl6e73zopl6e73xsz7oS71weBfQwBaWxT0P6r9z512PE53Pa5GQ2GdoIla9yasP2V9AU7ewYnG5bp1wJ00000iGskyTL2jnn-cWu2iGcoi4000a3vyTL2jnn-cWu2-WJy2Rly90PnkGyOX0R1__________yFqmBk0TlyP5_am0yOX0RVXGtrsXrdnXtL0lRO6ZFhM-jKV1O0"];
    NSURLSessionDataTask *downloadTask = [session downloadTaskWithURL:image];
    // completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // nothing
//    }];
    [downloadTask resume];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"session %@, %@, %lld, %lld, %lld", session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"download finished");
}
@end
