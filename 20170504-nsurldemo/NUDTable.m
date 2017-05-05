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
