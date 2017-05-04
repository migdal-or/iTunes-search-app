//
//  ViewController.m
//  20170504-nsurldemo
//
//  Created by iOS-School-1 on 04/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDownloadDelegate, UITextFieldDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) __block NSDictionary * results;
@property (nonatomic, strong) UITableView *table;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    _table = [UITableView new];
    _table.frame = self.view.frame;
    _table.delegate = self;
    _table.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_table];
    
    _searchBar = [UITextField new];
    _searchBar.text = @"Input search term";
    _searchBar.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _searchBar.frame = CGRectMake(10, 10, 200, 30);
//    _searchBar.delegate = self; //uisearchfield
    [_searchBar addTarget:self action:@selector(performSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_table addSubview:_searchBar];
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"session %@, %@, %lld, %lld, %lld", session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"download finished");
}

-(void) performSearch {
    //encode spaces %20
    NSString *searchURL = [_searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *urlString = [@"https://itunes.apple.com/search?term=" stringByAppendingString:searchURL];
//    NSLog(@"url is: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSURLSessionDataTask *searchTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary * searchResult;
            searchResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
//            NSLog(@"%@", response);
            NSLog(@"count %@, %@", searchResult, [searchResult objectForKey:@"resultCount"]);
            if (0 != [searchResult objectForKey:@"resultCount"]) {
                _searchBar.hidden = YES;
                _results = [searchResult objectForKey:@"results"];
                //parse table
                [_table reloadData];
            }
        }
    }];
    [searchTask resume];
}

#pragma mark - UITableViewDataSource


- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return 5; //[self.animals count];
}

-(UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = self.animals[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath   {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = UIColor.greenColor;
    vc.navigationItem.title = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
