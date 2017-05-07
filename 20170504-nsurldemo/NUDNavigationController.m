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
#define STORE_FILE YES // save itunes log if non-local mode call?
#define ARCHIVE_FILE_PATH @"/Users/admin/Desktop/songsTable.data"

NSString *const NUDCellIdentifier = @"NUDCellIdentifier";

@interface NUDNavigationController () <NSURLSessionDownloadDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) __block NSArray * results;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NUDTable* songsTable;

@end

@implementation NUDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"search"];
    [self.navigationBar setBarStyle:UIBarStyleDefault];
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    _table = [UITableView new];
    _table.frame = self.view.frame;
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    _table.tableHeaderView = [UIView new];

    [self.view addSubview:_table];
    
    _searchBar = [UITextField new]; //uisearchfield
    _searchBar.text = @"term";
    _searchBar.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    _searchBar.frame = CGRectMake(10, 40, 200, 30);
    [_searchBar addTarget:self action:@selector(performSearch) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_table addSubview:_searchBar];
    
    [_table registerClass:[UITableViewCell class] forCellReuseIdentifier:NUDCellIdentifier];
   
    if (LOCAL_MODE) {
    [self performSearch];   //do not wait for user to input search terms
    }
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSLog(@"session %@, %@, %lld, %lld, %lld", session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"download finished");
}

-(void) performSearch {
    
    if (LOCAL_MODE) {
        _songsTable = [[NUDTable alloc] initWithArray: [NSKeyedUnarchiver unarchiveObjectWithFile:ARCHIVE_FILE_PATH] ];
//        NSLog(@"dir %@", [[NSFileManager defaultManager] ]);
//        if (_songsTable) {
//            //success = [NSKeyedArchiver archiveRootObject:person toFile:archiveFilePath]
//            NSLog(@"unarchiving ok");
//        } else {
//            NSLog(@"unarchiving failed");
//        };
        
        [_table reloadData];

    } else {
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
            if (! [@0 isEqualToNumber:searchResult[@"resultCount"] ]) {
//                _searchBar.hidden = YES;
                NUDTable * songsFound;
                songsFound = searchResult[@"results"];  //[searchResult allValues][1]
                for (id item in songsFound) {
                    [arrayOfSongs addObject:addSong( item[@"trackName"],
                                                    item[@"artistName"],
                                                    item[@"collectionName"],
                                                    [NSURL URLWithString:item[@"artworkUrl30"]] ) ];
                }
                _songsTable = arrayOfSongs;
                NSLog(@"search returned %d results", _songsTable.count);
                
                if (STORE_FILE) {
                    if ([NSKeyedArchiver archiveRootObject:_songsTable toFile:ARCHIVE_FILE_PATH]) {
                        //success = [NSKeyedArchiver archiveRootObject:person toFile:archiveFilePath]
                        NSLog(@"archiving ok");
                    } else {
                        NSLog(@"archiving failed");
                    };
                }
                
                [_table reloadData];
            } else {
                NSLog(@"non");
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
    
    //    @property(nonatomic, strong) UILabel* artist;
    //    @property(nonatomic, strong) UILabel* track;
    //    @property(nonatomic, strong) UILabel* collection;
    //    @property(nonatomic, strong) NSURL* imgUrl;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath   {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"table row clicked");
//    UIViewController *vc = [UIViewController new];
//    vc.view.backgroundColor = UIColor.greenColor;
//    vc.navigationItem.title = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
//    [self.navigationController pushViewController:vc animated:YES];
}

@end
