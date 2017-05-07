//
//  NUDTable.m
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "NUDTable.h"
#import "NUDSong.h"

@interface NUDTable () <NSCoding>

@property(nonatomic, copy, readwrite) NSArray *table;

@end

@implementation NUDTable

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

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:_table forKey:@"table"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        //decode properties, other class vars
        _table = [decoder decodeObjectForKey:@"table"];
    }
    return self;
}

@end
