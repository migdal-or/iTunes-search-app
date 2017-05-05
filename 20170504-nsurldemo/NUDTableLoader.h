//
//  NUDTableLoader.h
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUDTable.h"

@interface NUDTableLoader : NSObject

-(NUDTable*) loadSongsFromArray: (NSArray *) iTunesArray;

@end
