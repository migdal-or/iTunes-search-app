//
//  NUDTableCellView.m
//  20170504-nsurldemo
//
//  Created by Admin on 07/05/2017.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "NUDTableCellView.h"

@implementation NUDTableCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createLabels];
    }
    return self;
}

- (void)createLabels {
    
    _track = [UILabel new];
    [self addSubview:_track];
    _track.frame = CGRectMake(0, 0, 50, 30);
    
    _artist = [UILabel new];
    [self addSubview:_artist];
    _artist.frame = CGRectMake(55, 0, 50, 30);

    _collection = [UILabel new];
    [self addSubview:_collection];
    _collection.frame = CGRectMake(0, 40, 50, 30);

    _image = [UIImageView new];
    [self addSubview:_image];
    _image.frame = CGRectMake(55, 40, 50, 30);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
