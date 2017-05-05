//
//  NUDTable.h
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUDSong.h"

@interface NUDTable : NSObject

-(instancetype) initWithArray: (NSArray *) starts;
-(NUDSong *) objectAtIndexedSubscript: (NSUInteger) index;
-(NSUInteger) count;

@end
