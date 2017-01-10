//
//  PathesTableViewController.h
//  townRush
//
//  Created by Nikita Taranov on 1/10/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONData.h"
@interface PathesTableViewController : UITableViewController
@property(strong,nonatomic) RLMResults *listOfPathes;
@end
