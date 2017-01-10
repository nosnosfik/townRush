//
//  PathesTableViewController.m
//  townRush
//
//  Created by Nikita Taranov on 1/10/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import "PathesTableViewController.h"

#import "ViewController.h"

@interface PathesTableViewController ()

@end

@implementation PathesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    RLMRealm *realmMainThread = [RLMRealm defaultRealm]; // (6)
				RLMResults *articles = [JSONData allObjectsInRealm:realmMainThread];
				self.listOfPathes = articles; // (7)
				[self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.listOfPathes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pathesCell" forIndexPath:indexPath];

    cell.textLabel.text =[NSString stringWithFormat:@"Route №%li", (long)[indexPath row]+1];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

-(void) unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        JSONData *path = self.listOfPathes[indexPath.row];
        [[segue destinationViewController] setStoredPath:path.JSONValue];
    
}
@end
