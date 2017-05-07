//
//  NUDTableElement.h
//  20170504-nsurldemo
//
//  Created by Admin on 05/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NUDSong : NSObject <NSCoding>

@property (nonatomic, copy) NSString * trackName;
@property (nonatomic, copy) NSString * artistName;
@property (nonatomic, copy) NSString * collectionName;
//@property (nonatomic, copy) NSURL * artworkUrl;
@property (nonatomic, copy) UIImage * songImage;

- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)initWithCoder:(NSCoder *)decoder;

@end
