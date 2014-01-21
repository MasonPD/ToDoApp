//
//  ToDoListViewController.m
//  ToDoApplication
//
//  Created by Linkai Xi on 1/18/14.
//  Copyright (c) 2014 Linkai Xi. All rights reserved.
//

#import "ToDoListViewController.h"
#import "ToDoItemCell.h"

@interface ToDoListViewController ()

@property (strong, nonatomic) NSMutableArray *tasks;
@property (strong, nonatomic) UIBarButtonItem *addButton;
@property (strong, nonatomic) UIBarButtonItem *addDoneButton;

@property (nonatomic) BOOL editing;
@property (nonatomic) BOOL isAdding;
@property (nonatomic) int currCellIndex;

- (void)onAddingButton:(id)sender;
- (void)onAddingDoneButton;
@end

@implementation ToDoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAddingButton:)];
    self.addDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(onAddingDoneButton)];
    self.editing = NO;
    self.isAdding = NO;
    self.currCellIndex = -1;
    
    self.navigationItem.title = @"To Do List";
    self.navigationItem.rightBarButtonItem = self.addButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UINib *toDoItemNib = [UINib nibWithNibName:@"ToDoItemCell" bundle:nil];
    [self.tableView registerNib:toDoItemNib forCellReuseIdentifier:@"ToDoItemCell"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *storedTasks = [defaults objectForKey:@"storedTasks"];
    if (storedTasks) {
        self.tasks = storedTasks;
    } else {
        self.tasks = [[NSMutableArray alloc] init];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.tasks forKey:@"storedTasks"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDoItemCell";
    ToDoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ToDoItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *task = [self.tasks objectAtIndex:indexPath.row];
    cell.taskDetail.delegate = self;
    [cell.taskDetail setText:task];
    [cell.taskDetail setUserInteractionEnabled:NO];
    return cell;
}

- (void)onAddingButton:(id)sender
{
    self.isAdding = YES;
    [self.tasks insertObject:@"" atIndex:0];
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = self.addDoneButton;
    [self.tableView selectRowAtIndexPath:0 animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    NSIndexPath *currPlace = [NSIndexPath indexPathForRow:0 inSection:0] ;
    [self tableView:self.tableView didSelectRowAtIndexPath:currPlace];
}

- (void)onAddingDoneButton
{
    [self.view endEditing:YES];
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *movingTask = [self.tasks objectAtIndex:fromIndexPath.row];
    [self.tasks removeObjectAtIndex:fromIndexPath.row];
    [self.tasks insertObject:movingTask atIndex:toIndexPath.row];
    
    [self.tableView reloadData];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    // toggle button title
    if (editing) {
        self.navigationItem.leftBarButtonItem.title = @"Done";
    } else {
        self.navigationItem.leftBarButtonItem.title = @"Edit";
    }
    [self.tableView setEditing:editing animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tasks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.editing) {
        self.navigationItem.rightBarButtonItem = self.addDoneButton;
        self.editing = YES;
        self.currCellIndex = indexPath.row;
        ToDoItemCell *cell = (ToDoItemCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.taskDetail setUserInteractionEnabled:YES];
        [cell.taskDetail becomeFirstResponder];
    } else {
        // give up change
        self.editing = NO;
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.editing) {
        self.editing = NO;
        if ([textField.text length] == 0) {
            [self.tasks removeObjectAtIndex:self.currCellIndex];
        } else {
            [self.tasks replaceObjectAtIndex:self.currCellIndex withObject:textField.text];
        }
    } else {
        if (self.isAdding) {
            [self.tasks removeObjectAtIndex:self.currCellIndex];
        }
    }
    
    self.isAdding = NO;
    self.currCellIndex = -1;
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = self.addButton;
}

@end
