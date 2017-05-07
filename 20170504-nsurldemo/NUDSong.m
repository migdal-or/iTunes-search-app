//
//  NUDTableElement.m
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "NUDSong.h"

@implementation NUDSong

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:_trackName forKey:@"trackName"];
    [encoder encodeObject:_artistName forKey:@"artistName"];
    [encoder encodeObject:_collectionName forKey:@"collectionName"];
//    [encoder encodeObject:_artworkUrl forKey:@"artworkUrl"];
    [encoder encodeObject:_songImage forKey:@"songImage"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        //decode properties, other class vars
        _trackName = [decoder decodeObjectForKey:@"trackName"];
        _artistName = [decoder decodeObjectForKey:@"artistName"];
        _collectionName = [decoder decodeObjectForKey:@"collectionName"];
//        _artworkUrl = [decoder decodeObjectForKey:@"table"];
        _songImage = [decoder decodeObjectForKey:@"songImage"];
    }
    return self;
}

@end
