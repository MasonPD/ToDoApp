//
//  ToDoItemCell.m
//  ToDoApplication
//
//  Created by Linkai Xi on 1/18/14.
//  Copyright (c) 2014 Linkai Xi. All rights reserved.
//

#import "ToDoItemCell.h"

@implementation ToDoItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];
}

@end
