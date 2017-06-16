//
//  TPSettingsTableViewController.m
//  Triplore
//
//  Created by 宋 奎熹 on 2017/6/16.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

#import "TPSettingsTableViewController.h"
#import "TPFontTableViewCell.h"
#import "Utilities.h"

@interface TPSettingsTableViewController ()

@end

@implementation TPSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [Utilities getBackgroundColor];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.title = @"设置";
    
    UINib *nib1 = [UINib nibWithNibName:@"TPFontTableViewCell" bundle:nil];
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"TPFontTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [[Utilities getAllFonts] count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TPFontTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TPFontTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *fontDict = [Utilities getAllFonts][indexPath.row];
    [cell.fontLabel setText:fontDict[@"display_name"]];
    [cell.fontLabel setFont:[UIFont fontWithName:fontDict[@"name"] size:16.0]];
    
    if([cell.fontLabel.font.fontName isEqualToString:[Utilities getFont]]){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        [Utilities setFontAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"笔记字体";
        default:
            return @"";
    }
}

@end
