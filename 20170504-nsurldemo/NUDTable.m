//
//  NUDTable.m
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "NUDTable.h"
#import "NUDSong.h"

@interface NUDTable ()

@property(nonatomic, copy, readwrite) NSArray *table;

@end

@implementation NUDTable

-(instancetype) initSongsFromArray: (NSArray *) iTunesArray {
    self = [super init];
    NUDSong * (^addSong)(NSString *, NSString *, NSString *, NSURL *);
    addSong = ^NUDSong*(NSString *trackName, NSString *artistName, NSString *collectionName, NSURL * artworkUrl) {
        if (nil == trackName) { NSLog(@"Cannot import contact without track name!"); return nil; }
        NUDSong * thisSong = [NUDSong new];
        thisSong.trackName = trackName;
        thisSong.artistName = artistName;
        thisSong.collectionName = collectionName;
        thisSong.artworkUrl = artworkUrl;
        return [thisSong copy];
    };
    
    NSMutableArray* arrayOfSongs;
    
    for (id item in iTunesArray) {
        NSLog(@"got here! %@", item);
        [arrayOfSongs addObject:addSong(item[@"trackName"], item[@"artistName"], item[@"collectionName"], [NSURL URLWithString:item[@"artworkURL"] ]) ];
    }
    
    if (self) {
        _table = arrayOfSongs;
    }

    return self;
    
}

-(instancetype) initWithArray: (NSArray * ) start {
    self = [super init];
    if (self) {
        _table = start;
    }
    return self;
}

-(NSUInteger) count {
    return [self.table count];
}


- (NUDSong *)objectAtIndexedSubscript:(NSUInteger)index {
    return self.table[index];
}
@end
