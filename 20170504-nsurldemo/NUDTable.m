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

@property(nonatomic, copy, readwrite) NSMutableArray *table;

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

//@property (nonatomic, copy) NSString * trackName;
//@property (nonatomic, copy) NSString * artistName;
//@property (nonatomic, copy) NSString * collectionName;
//@property (nonatomic, copy) NSURL * artworkUrl;
//[2]	(null)	@"artworkUrl60" : @"http://is1.mzstatic.com/image/thumb/Music6/v4/72/83/2e/72832e75-a81b-1add-6696-87438c430ac5/source/60x60bb.jpg"
//[16]	(null)	@"artworkUrl100" : @"http://is1.mzstatic.com/image/thumb/Music6/v4/72/83/2e/72832e75-a81b-1add-6696-87438c430ac5/source/100x100bb.jpg"
//[3]	(null)	@"collectionCensoredName" : @"Pure Heroine"
//[5]	(null)	@"collectionName" : @"Pure Heroine"
//[24]	(null)	@"artistName" : @"Lorde"
//[25]	(null)	@"trackName" : @"Team"


//ADBContact * (^addContact)(NSString *, NSString *, NSString *, NSString *);
//addContact = ^ADBContact*(NSString *firstName, NSString *lastName, NSString *phoneNumber, NSString *email) {
//
//    if (nil == firstName) { NSLog(@"Cannot import contact without first name!"); return nil; }
