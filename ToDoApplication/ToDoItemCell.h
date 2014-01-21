//
//  ToDoItemCell.h
//  ToDoApplication
//
//  Created by Linkai Xi on 1/18/14.
//  Copyright (c) 2014 Linkai Xi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoItemCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *taskDetail;

@end
