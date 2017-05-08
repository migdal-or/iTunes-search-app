//
//  ViewController.m -> NavigationController.m
//  20170504-nsurldemo
//
//  Created by iOS-School-1 on 04/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "NUDNavigationController.h"
#import "NUDTable.h"
#import "NUDTableCellView.h"
#define LOCAL_MODE YES // just to skip all this iTunes bullshit and load data from local file )
#define STORE_FILE NO // save itunes data if non-local mode call?
#define ARCHIVE_FILE_PATH @"/Users/admin/Desktop/songsTable.data"
#define NAVBAR_HEIGHT 60

NSString *const NUDCellIdentifier = @"NUDCellIdentifier";

@interface NUDNavigationController () <NSURLSessionDownloadDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *clearSearch;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) __block NSArray * results;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NUDTable* songsTable;

@end

@implementation NUDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, NAVBAR_HEIGHT)]; // setTitle:@"search"];
    [self.navigationBar setBarStyle:UIBarStyleDefault];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    _table = [UITableView new];
    _table.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - NAVBAR_HEIGHT);
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    [self.view addSubview:_table];

    _searchBar = [UISearchBar new];
    _searchBar.text = @"term";
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _searchBar.frame = CGRectMake(10, 0, 200, 30);
    [self.navigationBar addSubview:_searchBar];
    
    _clearSearch = [UIButton buttonWithType:UIButtonTypeSystem];
    [_clearSearch setTitle:@"stub" forState:UIControlStateNormal];
//    _clearSearch.titleLabel.textColor = [UIColor redColor];
    _clearSearch.hidden = YES;
    _clearSearch.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _clearSearch.frame = CGRectMake(210, 0, 60, 30);
    [_clearSearch addTarget:self action:@selector(clearSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar addSubview:_clearSearch];

    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:NUDCellIdentifier];
   
    if (LOCAL_MODE) {
        [self searchBarSearchButtonClicked: _searchBar];   //do not wait for user to input search terms
    }
}

- (void)clearSearchClicked {
    _songsTable=@[];
    _clearSearch.hidden = YES;
    [_table reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (LOCAL_MODE) {
        _songsTable = [[NUDTable alloc] initWithArray: [NSKeyedUnarchiver unarchiveObjectWithFile:ARCHIVE_FILE_PATH] ];
        NSLog(@"got %d records from local file %@, showing", [_songsTable count], ARCHIVE_FILE_PATH);
        _clearSearch.hidden = NO;
        [_clearSearch setTitle:[NSString stringWithFormat:@"%d found, clear?", [_songsTable count]] forState:UIControlStateNormal] ;
        NSLog([NSString stringWithFormat:@"%d found, clear?", [_songsTable count]]);
        [_clearSearch sizeToFit];
       [_table reloadData];
    } else {
        NSLog(@"start querying iTunes");
        //encode search bar text for inserting to url
        NSString *searchTextWithoutSpaces = [_searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *searchTextForURL = [searchTextWithoutSpaces stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSString *urlSearchString = [@"https://itunes.apple.com/search?kind=song&term=" stringByAppendingString:searchTextForURL];
        NSURL *urlSearch = [NSURL URLWithString:urlSearchString];
        NSURLRequest *request = [NSURLRequest requestWithURL:urlSearch];
        
        __block NSMutableArray* arrayOfSongs = [NSMutableArray new];
        __block NUDSong * (^addSong)(NSString *, NSString *, NSString *, NSURL *);
        addSong = ^NUDSong*(NSString *trackName, NSString *artistName, NSString *collectionName, NSURL * artworkUrl) {
            if (nil == trackName) { NSLog(@"Cannot import contact without track name!"); return nil; }
            NUDSong * thisSong = [NUDSong new];
            thisSong.trackName = trackName;
            thisSong.artistName = artistName;
            thisSong.collectionName = collectionName;
            thisSong.songImage = [ [UIImage alloc] initWithData: [NSData dataWithContentsOfURL:artworkUrl] ] ;
            //        NSLog(@"song added");
            return thisSong;
        };
        
        NSURLSessionDataTask *searchTask = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                NSDictionary * searchResult;
                searchResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if ([@0 isEqualToNumber:searchResult[@"resultCount"] ]) {
                    NSLog(@"received 0 records from search, try again");
                } else {
                    //                _searchBar.hidden = YES;
                    NUDTable * songsFound;
                    songsFound = searchResult[@"results"];  //[searchResult allValues][1]
                    for (id item in songsFound) {
                        [arrayOfSongs addObject:addSong( item[@"trackName"],
                                                        item[@"artistName"],
                                                        item[@"collectionName"],
                                                        [NSURL URLWithString:item[@"artworkUrl60"]] ) ];
                    }
                    _songsTable = arrayOfSongs; //i could copy, but it would consume 2x memory
                    _clearSearch.titleLabel.text = [NSString stringWithFormat:@"%d found, clear?", [_songsTable count]];
                    [_clearSearch sizeToFit];
                    _clearSearch.hidden = NO;
                   NSLog(@"search returned %d results", _songsTable.count);
                    
                    if (STORE_FILE) {
                        if ([NSKeyedArchiver archiveRootObject:_songsTable toFile:ARCHIVE_FILE_PATH]) {
                            //success = [NSKeyedArchiver archiveRootObject:person toFile:archiveFilePath]
                            NSLog(@"archiving ok");
                        } else {
                            NSLog(@"archiving failed");
                        };
                    } else {
                        NSLog(@"not archiving file to local because of defines setup");
                    }
                    
                    [_table reloadData];
                }
            }
        }];
        [searchTask resume];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return [_songsTable count];
}

-(UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NUDTableCellView *cell = [[NUDTableCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NUDCellIdentifier];
    
    cell.track.text = _songsTable[indexPath.row].trackName;
    cell.artist.text = _songsTable[indexPath.row].artistName;
    cell.collection.text = _songsTable[indexPath.row].collectionName;
    [cell.image addSubview: [[UIImageView alloc] initWithImage:_songsTable[indexPath.row].songImage] ] ;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath   {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"table row clicked");
//    UIViewController *vc = [UIViewController new];
//    vc.view.backgroundColor = UIColor.greenColor;
//    vc.navigationItem.title = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - session downloader

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"session %@, %@, %lld, %lld, %lld", session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"download finished");
}

@end
