//
//  NUDTableLoader.m
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "NUDTableLoader.h"
#import "NUDTable.h"
#import "NUDSong.h"

@implementation NUDTableLoader

-(NUDTable*) loadSongsFromArray: (NSArray *) iTunesArray {
    NUDSong * (^addSong)(NSString *, NSString *, NSString *, NSURL *);
    addSong = ^NUDSong*(NSString *trackName, NSString *artistName, NSString *collectionName, NSURL * artworkUrl) {
        if (nil == trackName) { NSLog(@"Cannot import contact without track name!"); return nil; }
        NUDSong * thisSong = [NUDSong new];
        thisSong.trackName = trackName;
        thisSong.artistName = artistName;
        thisSong.collectionName = collectionName;
        thisSong.artworkUrl = artworkUrl;
        return thisSong;
    };
    
    NSMutableArray* arrayOfSongs;
    
    for (id item in iTunesArray) {
        NSLog(@"got here! %@", item);
        [arrayOfSongs addObject:addSong(item[@"trackName"], item[@"artistName"], item[@"collectionName"], [NSURL URLWithString:item[@"artworkURL"] ]) ];
    }
    return [[NUDTable alloc] initWithArray: arrayOfSongs];

}

@end


